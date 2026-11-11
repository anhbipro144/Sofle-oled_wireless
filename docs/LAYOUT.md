# Neovim-oriented layout v1 (`feature/nvim-miryoku-v1`)

**Status: experimental, not merged.** v1 (`da32702…`) flashed to the left half on 2026-11-11; v1.1 (Alt/Cmd swap) flashed to the left half the same day; v1.2 (NAV/Option swap) flashed to both halves the same day. v1.4 (`\` on a right thumb, Delete moved to NAV; SYM adds `\` and `?` for the left hand) flashed to the left half the same day. v1.5 (`\` key becomes Raycast, Option+Space) flashed to the left half the same day (current; the keymap lives on the left/central half, the right half's v1.2 build is byte-identical). The seller's keymap is untouched on `main`
(also in `docs/reference/sofle.keymap.seller`). To flash this, read `docs/SETUP.md` first.

Local pristine build (Docker, same steps as CI) succeeded: 4 layers x 60 bindings in the compiled devicetree, `sys_trigger` = layers 1+2 -> 3,
no new warnings (the `label` deprecation warnings are gone). Same flash/RAM use as the seller build (43.1 % / 34.7 %).
```
146675425073281f…  sofle_left-nice_nano_v2-zmk.uf2
101bcab3140d74f6…  sofle_right-nice_nano_v2-zmk.uf2
```
(first 16 hex chars of SHA-256, v1.5; right half unchanged since v1). v1 (`da32702…`) was also built by GitHub Actions with identical hashes.

## Layout

`.` = passes through to the layer below, blank = key disabled. Left encoder click = mute, right = nothing. Encoders unchanged (volume / page up-down).

```
[BASE]
|  `   |  1   |  2   |  3   |  4   |  5   |              |  6   |  7   |  8   |  9   |  0   |  -   |
| TAB  |  Q   |  W   |  E   |  R   |  T   |              |  Y   |  U   |  I   |  O   |  P   |  =   |
| ESC  |  A   |  S   |  D   |  F   |  G   |              |  H   |  J   |  K   |  L   |  ;   |  '   |
|SHIFT |  Z   |  X   |  C   |  V   |  B   | MUTE |      |  N   |  M   |  ,   |  .   |  /   |SHIFT |
       | GUI  | NAV  | ALT  | CTRL |SPACE |              |ENTER | BSPC | SYM  |RAYCST|INPUT |

[NAV]
|  .   |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   |  .   |  .   |  .   |
|  .   |      |      |      |      |      |              | HOME | PGDN | PGUP | END  |      |  .   |
|  .   | GUI  | ALT  | CTRL |SHIFT |      |              |  <-  |  v   |  ^   |  ->  |      |  .   |
|  .   |      |      |      |      |      |  .   |  .   |      |      |      |      |      |  .   |
       |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   | DEL  |  .   |

[SYM]
|  .   |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   |  .   |  .   |  .   |
|  .   |  {   |  &   |  *   |  (   |  }   |              |  [   |  7   |  8   |  9   |  ]   |  .   |
|  ?   |  :   |  $   |  %   |  ^   |  +   |              |  ;   |  4   |  5   |  6   |  =   |  .   |
|  .   |  ~   |  !   |  @   |  #   |  |   |  .   |  .   |  `   |  1   |  2   |  3   |  \   |  .   |
       |  .   |  .   |  \   |  )   |  _   |              |  .   |  .   |  .   |  .   |  .   |

[SYS]
|  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |              |  F7  |  F8  |  F9  | F10  | F11  | F12  |
|      | BT0  | BT1  | BT2  | BT3  | BT4  |              | RGB  | HUI  | SAI  | BRI  | EFF  |      |
| CAPS |EXTPW |      |      |      |      |              |      | HUD  | SAD  | BRD  |      |      |
| BOOT |      |      |      |      |      |      |      |      |      |      |      |      |BTCLR |
       |      |      |      |      |      |              |      |      |      |      |      |
```

Thumb keys, outermost to innermost on the left, innermost to outermost on the right:
`GUI [NAV] ALT CTRL SPACE | ENTER BSPC [SYM] RAYCAST INPUT`. `RAYCAST` = Option+Space in one key (Raycast's hotkey). Delete = hold NAV + that same key. `INPUT` = Control+Space in one key (macOS input-source switch). `\` is on the SYM layer.
Layers are plain momentary holds (`&mo`), **not** tap-hold. Hold NAV + SYM together to get SYS.

## Modifiers on macOS (one rule: the Sofle is remapped only here, in firmware)

ZMK names → macOS names: `GUI` = Command ⌘, `ALT` = Option ⌥, `CTRL` = Control ⌃. What each key sends is exactly what macOS receives:
the Mac's modifier remap (`nix-files/macos.nix`, Caps Lock → Esc, Globe → Cmd) is stored for the built-in keyboard (`modifiermapping.0-0-0`)
and has **no** entry for the Sofle (`ZMK Project` 7504/24926). Keep it that way; a second remap layer for the Sofle is what makes things confusing.

| Job | Keys on the Sofle | Defined in |
|---|---|---|
| AeroSpace workspace 1–10 / move window | middle left thumb `ALT` + `1`…`0` (+ `SHIFT` to move) | `aerospace.nix` (`alt-N`) |
| AeroSpace workspace 11–19 | `ALT` + `CTRL` + `1`…`9` (adjacent thumbs: press both with one thumb) | `aerospace.nix` (`alt-ctrl-N`) |
| AeroSpace focus / move window | `ALT` + `h j k l` (+ `SHIFT`) | `aerospace.nix` |
| Vim `Ctrl-w`, `Ctrl-d`, … | 4th left thumb `CTRL` + key | – |
| macOS Cmd-C/V/Tab | outermost left thumb `GUI` + key | – |
| Raycast | 4th right thumb (sends Option+Space) | `LA(SPACE)` in `sofle.keymap` |
| Input source | outermost right thumb (sends Control+Space) | `LC(SPACE)` in `sofle.keymap` |
| Esc | `ESC` key itself (left home-row edge) | firmware; the Mac's Caps → Esc remap does not apply to the Sofle |

## Against your requirements

| Requirement | v1 |
|---|---|
| QWERTY, native `hjkl`, number row | unchanged on BASE |
| Easy Esc | plain `ESC` on the left home-row edge (where the old Tab/Caps were) – one pinky step, no timing |
| Easy Ctrl | plain `CTRL` thumb key next to Space; `Ctrl-w`, `Ctrl-d/u/r/o/v` are thumb + any finger |
| Backspace on right thumb | `BSPC` moved from the 3rd to the **2nd** right thumb key (next to Enter) |
| Space / Enter | innermost thumbs, as before |
| `( ) [ ] { }` | SYM: `(` left index (top row), `)` left thumb; `[ ]` right hand Y/P keys; `{ }` left pinky/inner-index top row |
| `=` `-` `_` | `=` and `-` are plain keys on the right edge of BASE; `_` is a left thumb in SYM (snake_case) |
| `:` `;` `/` | `;` and `/` stay on BASE; `:` is Shift+`;` as usual, or left pinky home in SYM |
| `\` `\|` `?` | `\` is a plain right-thumb key (Shift for `\|`). In SYM: `\` on the middle left thumb and right hand, `?` on the left outer pinky (home row), `\|` left inner-index bottom row |
| Navigation | NAV: arrows on `h j k l` (right hand), Home/PgDn/PgUp/End above, plain GUI/ALT/CTRL/SHIFT under left home row |
| Bluetooth + recovery | SYS: BT0–BT4, `BOOT` (bottom-left corner), `BTCLR` (bottom-right corner) |
| No combos / home-row mods | none used |

## What changed from the seller's layout

- Esc: top-left corner → left home-row edge. Tab: home row → Q row. CapsLock: base → SYS.
- Ctrl: 3rd → 2nd left thumb. Seller's LOWER (symbols, left thumb) and RAISE (navigation, right thumb) are **swapped in meaning**:
  now NAV is the left thumb and SYM the right thumb (Miryoku orientation: the layer is held by the *opposite* hand of the keys you use).
- Shift: no longer on a thumb (bottom edge keys on both sides). `?` thumb removed (it is Shift+`/`).
- `+` and `_` on the right edge of BASE became `=` and `-` (shifted forms still work). Backtick top-left.
- `BT_CLR` is no longer on the top-left corner of two layers (one stray press away); it is bottom-right of SYS.
- The seller's ADJUST layer had a stray `&kp W` on its top-right key; dropped.
- Layer names `base/nav/sym/sys` (uses `display-name`, silencing the `label` deprecation warning).
- Hardware config (`sofle.conf`, `build.yaml`, shield) untouched.

## Trade-offs

- **No hold-taps in v1.** Every symbol needs a layer hold; the payoff is that `dd`, `ciw`, `gg` and `Ctrl-w` can never be misread
  as a hold, because there is nothing to time. Home-row mods and Esc/Ctrl-on-tap-hold are the usual source of Vim mis-fires on fast rolls.
- **Esc on the pinky home edge, not a thumb.** Thumbs are spent on Ctrl, Space, Enter, Backspace, and the two layers. Reach is a small cost; CapsLock-as-Esc is the classic Vim position.
- **One Ctrl (left thumb).** Right-hand letters (`u o i p`) are fine; no right Ctrl until you ask for one.
- **SYM follows Miryoku's numpad shape**, so it is less obvious than a shifted number row at first. The right-hand digit block is redundant while the number row exists; it is there to keep `[ ] ; = \ \`` together and to ease the later move to Miryoku. `(` and `)` are split across index/thumb – that is the least pretty spot, adjust after a week of use.
- **Cmd on the outermost left thumb** is a stretch. Option (AeroSpace, used most) sits in the middle of the cluster next to Ctrl, so `alt-ctrl-N` is one thumb; NAV moved one key outward. Move Cmd once you know how often you press it.
- **Studio:** layer ids/names changed. After flashing, do Studio → *Restore Stock Settings* or old Studio edits will paint over this layout.

## Vim sanity check

`dd`, `ciw`, `gg`, `yy`, `:wq` are BASE keys (+Shift), no layer, no timing. `Ctrl-w h/j/k/l` = left thumb + W, then plain hjkl. `<Esc>` is one key.
Symbols inside insert mode: hold the right thumb (SYM), press with the left hand.

## Where to evolve next (not implemented)

Do one step at a time, a week each, and keep SETUP.md's recovery steps handy:
1. Layer-tap on Space (NAV) and Enter (SYM) so the thumbs free up.
2. Home-row mods, GUI/ALT/CTRL/SHIFT on A S D F / J K L ; with a `balanced` hold-tap,
   `tapping-term-ms` ≈ 280, `require-prior-idle-ms` ≈ 150, `quick-tap-ms` ≈ 175, and `hold-trigger-key-positions` set to the *opposite* hand so same-hand rolls always tap.
   Re-test `dd`, `ciw`, `gg`, `Ctrl-w` after every change. See <https://zmk.dev/docs/keymaps/behaviors/hold-tap>.
3. Drop the number row once the SYM numpad feels natural. Then mouse layer / combos if you want them.
Reference: <https://github.com/manna-harbour/miryoku_zmk>.
