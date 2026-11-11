#!/usr/bin/env bash
# Build every target in build.yaml locally, mirroring zmkfirmware/zmk's build-user-config.yml.
# Usage: scripts/local-build.sh [outdir]   (default: ./firmware-local, gitignored)
# Needs a running Docker. Never flashes anything; only writes .uf2 files + build.log to outdir.
# shortcut: only the `include:` form of build.yaml is parsed, extend if you switch to board/shield arrays.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$(mkdir -p "${1:-$REPO/firmware-local}" && cd "${1:-$REPO/firmware-local}" && pwd)"
IMAGE="${ZMK_IMAGE:-zmkfirmware/zmk-build-arm:stable}"   # same floating tag the v0.3.0 CI workflow uses

docker run --rm \
  -v "$REPO:/src:ro" -v "$OUT:/out" -v zmk-west-cache:/work \
  -e HOST_UID="$(id -u)" -e HOST_GID="$(id -g)" \
  "$IMAGE" bash -euo pipefail -c '
    trap "chown -R $HOST_UID:$HOST_GID /out" EXIT
    cd /work
    rm -rf .west config && cp -R /src/config /work/config      # modules/zmk/zephyr stay cached in the volume
    west init -l /work/config
    west update --fetch-opt=--filter=tree:0
    west zephyr-export
    git -C /work/zmk rev-parse HEAD | sed "s/^/ZMK commit: /"
    python3 - <<PY | while IFS="|" read -r board shield snippet cmake; do
import yaml
for t in yaml.safe_load(open("/src/build.yaml"))["include"]:
    print("|".join([t["board"], t.get("shield",""), t.get("snippet",""), t.get("cmake-args","")]))
PY
      name="${shield:+$shield-}$board-zmk"
      echo "=== BUILD $name"
      # shellcheck disable=SC2086
      west build -s zmk/app -d "/work/build/$name" -b "$board" ${snippet:+-S "$snippet"} -- \
        -DZMK_CONFIG=/work/config ${shield:+-DSHIELD="$shield"} $cmake
      cp "/work/build/$name/zephyr/zmk.uf2" "/out/$name.uf2"
    done
  ' 2>&1 | tee "$OUT/build.log"

ls -l "$OUT"/*.uf2
