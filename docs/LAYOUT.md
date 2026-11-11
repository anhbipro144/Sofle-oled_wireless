# Neovim-oriented layout v1 (`feature/nvim-miryoku-v1`)

**Status: experimental. Built, never flashed, not merged.** The seller's keymap is untouched on `main`
(also in `docs/reference/sofle.keymap.seller`). To flash this, read `docs/SETUP.md` first.

Local pristine build (Docker, same steps as CI) succeeded: 4 layers x 60 bindings in the compiled devicetree, `sys_trigger` = layers 1+2 -> 3,
no new warnings (the `label` deprecation warnings are gone). Same flash/RAM use as the seller build (43.1 % / 34.7 %).
```
da3270215e65c65c…  sofle_left-nice_nano_v2-zmk.uf2
101bcab3140d74f6…  sofle_right-nice_nano_v2-zmk.uf2
```
(first 16 hex chars of SHA-256; your own build will match). GitHub Actions has not built this yet (see SETUP.md, "Baseline record").

## Layout

`.` = passes through to the layer below, blank = key disabled. Left encoder click = mute, right = nothing. Encoders unchanged (volume / page up-down).

```
[BASE]
|  `   |  1   |  2   |  3   |  4   |  5   |              |  6   |  7   |  8   |  9   |  0   |  -   |
| TAB  |  Q   |  W   |  E   |  R   |  T   |              |  Y   |  U   |  I   |  O   |  P   |  =   |
| ESC  |  A   |  S   |  D   |  F   |  G   |              |  H   |  J   |  K   |  L   |  ;   |  '   |
|SHIFT |  Z   |  X   |  C   |  V   |  B   | MUTE |      |  N   |  M   |  ,   |  .   |  /   |SHIFT |
       | ALT  | GUI  | NAV  | CTRL |SPACE |              |ENTER | BSPC | SYM  | DEL  | ALT  |

[NAV]
|  .   |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   |  .   |  .   |  .   |
|  .   |      |      |      |      |      |              | HOME | PGDN | PGUP | END  |      |  .   |
|  .   | GUI  | ALT  | CTRL |SHIFT |      |              |  <-  |  v   |  ^   |  ->  |      |  .   |
|  .   |      |      |      |      |      |  .   |  .   |      |      |      |      |      |  .   |
       |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   |  .   |  .   |

[SYM]
|  .   |  .   |  .   |  .   |  .   |  .   |              |  .   |  .   |  .   |  .   |  .   |  .   |
|  .   |  {   |  &   |  *   |  (   |  }   |              |  [   |  7   |  8   |  9   |  ]   |  .   |
|  .   |  :   |  $   |  %   |  ^   |  +   |              |  ;   |  4   |  5   |  6   |  =   |  .   |
|  .   |  ~   |  !   |  @   |  #   |  |   |  .   |  .   |  `   |  1   |  2   |  3   |  \   |  .   |
       |  .   |  .   |  .   |  )   |  _   |              |  .   |  .   |  .   |  .   |  .   |

[SYS]
|  F1  |  F2  |  F3  |  F4  |  F5  |  F6  |              |  F7  |  F8  |  F9  | F10  | F11  | F12  |
|      | BT0  | BT1  | BT2  | BT3  | BT4  |              | RGB  | HUI  | SAI  | BRI  | EFF  |      |
| CAPS |EXTPW |      |      |      |      |              |      | HUD  | SAD  | BRD  |      |      |
| BOOT |      |      |      |      |      |      |      |      |      |      |      |      |BTCLR |
       |      |      |      |      |      |              |      |      |      |      |      |
```

Thumb keys, outermost to innermost on the left, innermost to outermost on the right:
`ALT GUI [NAV] CTRL SPACE | ENTER BSPC [SYM] DEL ALT`.
Layers are plain momentary holds (`&mo`), **not** tap-hold. Hold NAV + SYM together to get SYS.

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
| `\` `\|` | SYM: `\` right hand, `\|` left inner-index bottom row |
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
- **GUI/ALT on the outer thumbs** are a stretch; macOS Cmd shortcuts cost more than on a Mac keyboard. Move them once you know which you press most.
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
