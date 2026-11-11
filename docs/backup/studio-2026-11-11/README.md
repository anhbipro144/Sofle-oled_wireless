# Installed keymap as seen in ZMK Studio – 2026-11-11 (before any flashing)

Screenshots of the four layers on the keyboard as delivered. Taken from the left (central) half over USB.

## Reading the screenshots

- Studio labels show the **unshifted** key: `!` appears as `1`, `(` as `9`, `+` as `=`, `_` as `-`, `?` as `/`, `|` as `\`, `:` as `;`.
  Evidence: on `lower`, the numpad `*` (`KP_MULTIPLY`, no Shift) shows as `*`, while the shifted `&kp ASTERISK` next to it shows as `8`.
- Blank = `&trans`, `&none`, **or** a non-key behavior (Bluetooth, RGB, ext-power, layer keys). Studio here does not label those.

## Comparison with the seller keymap (`docs/reference/sofle.keymap.seller`, commit bbd2a24)

| Layer | Matches? | Notes |
|---|---|---|
| default | yes | `=`/`-` on the right edge are `+`/`_`; thumb `/` is `?`; blank thumbs are LOWER / RAISE |
| lower | yes | shifted symbols shown unshifted; F1–F12 row; `{ }` labels also stand for `[ ]` on the right |
| raise | yes for all labelled keys | top row (BT_CLR, BT_SEL 0–4) blank, not verifiable from screenshots |
| adjust | only the stray `W` is visible | BT / RGB / ext-power keys blank, not verifiable from screenshots |

Conclusion: the installed keymap is consistent with the seller's `bbd2a24` keymap, so there are probably **no Studio overrides**.
Not proven: Studio cannot show whether a key was edited, and unlabelled behaviors cannot be compared.
Flashing `baseline-upstream-bbd2a24` + Studio "Restore Stock Settings" reproduces this layout.
