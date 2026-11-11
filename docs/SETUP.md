# Sofle (nice!nano v2, ZMK) – setup, build, flash, recovery

Personal fork of [Hieupham0012/Sofle-oled_wireless](https://github.com/Hieupham0012/Sofle-oled_wireless).
This repo is the **source of truth** for the keymap. Anything edited in ZMK Studio is *not* in Git (see [Studio](#zmk-studio-vs-the-compiled-keymap)).

## Baseline record

| Item | Value |
|---|---|
| Upstream baseline commit | `bbd2a24a8e99f8a63e458722c3d2f1b3b06bb89f` ("Update README.md") |
| Baseline tag (this fork) | `baseline-upstream-bbd2a24` – `git switch --detach baseline-upstream-bbd2a24` always gives the seller's exact config |
| ZMK | `v0.3.0` = commit `edf5c0814fd3ea202e43aad2d68fd32e882a518c` (Zephyr 3.5.0) |
| Targets (`build.yaml`) | `nice_nano_v2` + `sofle_left` (Studio on), `sofle_right`, `settings_reset` |
| Artifact files | `sofle_left-nice_nano_v2-zmk.uf2`, `sofle_right-nice_nano_v2-zmk.uf2`, `settings_reset-nice_nano_v2-zmk.uf2` (inside the CI artifact `firmware`) |

**Local baseline build (Docker, 2026-11-11): succeeded.** Same container image, same `west` steps as the CI workflow.
Flash use: left 43.1 %, right 34.7 %. SHA-256 of that build:

```
e13db75a0a34b1b093ff80671b12c8e034f0b8b3ae3e36bdd5f3b1eb643f3ef2  sofle_left-nice_nano_v2-zmk.uf2
50f807d822c3f35400af2737149d0b4b0d5c7bc6ce081d68eec16466ded72845  sofle_right-nice_nano_v2-zmk.uf2
4031c0b2f3482cd7070ea5c57b95f3713785c4ca61441bdd986d81fe7de16957  settings_reset-nice_nano_v2-zmk.uf2   # NEVER FLASH for normal use
```

Pristine rebuild of branch `setup/docs-and-tooling` (ZMK pinned by SHA) produced **byte-identical** `.uf2` files, so the pin is a no-op and builds are reproducible in this container.

Warnings seen (all benign): `label` property deprecated (use `display-name`); right half ignores `CONFIG_ZMK_USB=y`
(peripherals have no USB HID); array-bounds warnings only in the `settings_reset` target (no keymap).

**GitHub Actions baseline build: succeeded** (run 42958605642, branch `baseline-build`); its `.uf2` files are byte-identical to the local build above.
Run it again any time with `gh workflow run build.yml -R anhbipro144/Sofle-oled_wireless --ref baseline-build`.

### What is installed (as of 2026-11-11)

| Half | Firmware | Proof |
|---|---|---|
| Left | keymap v1.2 from `feature/nvim-miryoku-v1` (`e68e329`, SHA-256 `768996189ff6f37d…`) | flashed from the verified CI artifact |
| Right | seller baseline (`50f807d822c3f354…`) | its `CURRENT.UF2` dump is block-identical to the baseline build |

Before the first flash, the left half's dump was block-identical to the seller baseline too, so the seller `.uf2` files are exact restore points for both halves.
Dumps + `INFO_UF2.TXT` (both halves: nice!nano, UF2 bootloader 0.6.0, S140 6.1.1) are kept locally in `~/persona/sofle-zmk/installed-backup/{left,right}/`, not in Git.
Known-good `.uf2` files: GitHub release `installed-2026-11-11` on this fork (once published).

## Required tools

- `git`, `gh` (logged in as `anhbipro144`), SSH host alias `github.com-personal` (key `~/.ssh/neo_mac`). Remotes: `origin` = your fork, `upstream` = seller (push disabled).
- Docker (colima is fine, ≥6 GB RAM) for `scripts/local-build.sh`. No other toolchain needed.
- A **data** USB cable, a browser with WebUSB/Web Serial (Chrome/Edge) for <https://zmk.studio>.
- Commit identity in this repo is local-only (`nbi6731@gmail.com`), not your work address.

## Edit → build → flash loop

```sh
nvim config/sofle.keymap
scripts/local-build.sh                 # ~5 min first time (cached after); writes firmware-local/*.uf2 + build.log
git commit -am "…" && git push         # CI builds the same thing
gh run list -L3                        # find the run
gh run download <run-id> -n firmware -D ~/Downloads/sofle-fw
```

- The `Draw ZMK keymaps` workflow commits `keymap-drawer/*.svg|yaml` back to your branch after keymap pushes → `git pull --rebase` before your next push.
- GitHub keeps artifacts 90 days. Keep known-good `.uf2` files in a GitHub release (`installed-2026-11-11` holds the current ones).
- Pinned: ZMK in `config/west.yml` (commit SHA). **Not pinned:** the CI container `zmkfirmware/zmk-build-arm:stable` is a floating tag baked into
  the upstream `build-user-config.yml@v0.3.0`; if CI ever breaks without a change of yours, that is the first suspect
  (fix: copy that workflow into this repo and pin the image to `:3.5`).

## How the two halves differ

| | Left (`sofle_left`) | Right (`sofle_right`) |
|---|---|---|
| Role | BLE **central** – the half your computer pairs with | peripheral – pairs only with the left half |
| ZMK Studio | on (`snippet: studio-rpc-usb-uart`, `-DCONFIG_ZMK_STUDIO=y`) | off |
| Keymap | resolves all key presses | compiled in but unused |
| Config (`sofle.conf`) | applies | applies |

Consequences: a **keymap-only change needs only the left half flashed**. A `sofle.conf` or `west.yml` change needs **both**.
Plugging USB into the right half does not give Studio. Flashing normal firmware does not touch the settings partition,
so Bluetooth bonds and Studio overrides survive.

## Backup + flash routine (one half at a time)

The reset button is the small tactile switch next to the OLED, above the TRRS jack (no disassembly). The switch beside the USB-C port is power.

1. Plug that one half in by USB (power switch ON so the battery charges; USB alone powers the controller). Double-tap reset → drive `NICENANO` mounts.
2. Identify and back up: copy `CURRENT.UF2` and `INFO_UF2.TXT` off the drive. `INFO_UF2.TXT` must say `Model: nice!nano`.
   `CURRENT.UF2` dumps the application flash only (`0x1000`–`0xACF00` on this bootloader): no Bluetooth bonds, no Studio edits.
3. Confirm which half / firmware it is:
   `scripts/uf2-compare.py /Volumes/NICENANO/CURRENT.UF2 <expected-current>.uf2` → `0 … differing` means it is the half you think it is.
4. Copy the new `.uf2` onto the drive (`sofle_left-…` to the left half only). The drive disappears and the half reboots on its own;
   it should reappear as USB device `Sofle` / `ZMK Project`. Never copy `settings_reset-…uf2`.
5. Test typing. After flashing a *different keymap*, do Studio → **Restore Stock Settings** (below).
6. Keymap-only change → flash only the left half. Leave the right half alone unless `sofle.conf` / `west.yml` changed.

## Returning to baseline

- Fast: `git switch --detach baseline-upstream-bbd2a24 && scripts/local-build.sh`, flash left (and right if `.conf` differed), Studio → Restore Stock Settings.
- Or flash the saved baseline `.uf2` files (hashes above) / the Actions artifact from branch `baseline-build`.
- If a bad keymap still lets you type: `SYS` layer (hold both layer keys) → left-corner `&bootloader`, or just double-tap reset. The UF2 bootloader lives outside the application flash, so a bad keymap does not remove it; reflash over it.

## Bluetooth / split troubleshooting (none of these need `settings_reset`)

- **Right half not typing:** it only talks to the left half. Power-cycle both, left first. Check both halves run firmware built from the *same* commit.
- **Keys work on USB but not BLE:** pick the profile again (`SYS` layer → BT0–BT4), and make sure the computer has not selected another device.
- **Host shows "connected" but no input** (usually after the host forgot the keyboard): remove the keyboard from the host's Bluetooth list, then on the keyboard select that profile and press `BT_CLR` (SYS layer) – it clears only that profile's bond – and pair again. Your decision to make; nothing in this repo does it for you.
- **Windows battery/connection quirks and Intel BT chips** are already addressed in `sofle.conf` (`BT_GATT_ENFORCE_SUBSCRIPTION=n`, `ZMK_BLE_EXPERIMENTAL_CONN=y`); do not remove them without a reason.
- `BT_CLR` (SYS layer, bottom-right corner) clears the **current** profile's bond only. It is deliberately placed where it cannot be hit by accident.
- Last resort only (wipes *all* bonds and Studio overrides, requires re-pairing both halves, and the right half must be re-paired to the left): flash `settings_reset` to **both** halves, then the normal firmware to both. Not part of any normal workflow.

## ZMK Studio vs. the compiled keymap

Verified in ZMK v0.3 source (`app/src/keymap.c`, `app/src/studio/*`):
- Studio saves edits to the keyboard's settings partition under `keymap/layer_order`, `keymap/l_n/<id>`, `keymap/l/<id>/<position>`.
- At boot those saved values are applied **on top of** the compiled keymap. So after you flash a new compiled keymap, any layer/key you ever edited in Studio still shows the Studio value.
- Overrides are keyed by layer id + position, so changing layer count/order/meaning makes stale overrides land on the wrong layers.
- Studio is **unlocked** in this config (`CONFIG_ZMK_STUDIO_LOCKING=n`): anything on USB can edit the keymap.

**Studio → Restore Stock Settings** deletes only those `keymap/*` keys (`zmk_keymap_reset_settings`). It does **not** touch Bluetooth bonds or split pairing.
Use it: (a) after flashing a different compiled keymap (always, for the Neovim layout), (b) when a Studio experiment went wrong, (c) when the keyboard does not match the repo.
Do not use it to "save" anything: it discards your Studio edits.

## Why `settings_reset` must not be used for updates

`settings_reset` erases the **entire** settings partition: all Bluetooth bonds (both halves, all profiles), the split pairing, RGB/ext-power state, and Studio overrides.
Normal `.uf2` flashing never needs it – settings live in a separate flash region that normal firmware leaves alone. Using it for routine updates just forces needless re-pairing.
It is built by `build.yaml` as an artifact only; keep it unflashed.

## Unverified hardware assumptions

- Controllers are nice!nano v2 or exact clones (pinout, bootloader, battery sense, ext-power pin).
- Underglow: nice!nano v2's default `led_strip` chain length is used; this repo does not set the LED count of your Sofle.
- OLED is the SSD1306 128×32 on I2C `0x3c` defined by ZMK's `sofle` shield; `CONFIG_BT_CTLR_TX_PWR_PLUS_8=y` raises TX power (battery cost).
- Seller `main` may differ from what is installed. Shield definitions (`sofle_*`) come from ZMK itself and are untouched here.
