# Settings

Wrapper script for `gnome-control-center`

## XDG_CURRENT_DESKOP

Gnome only runs when env var `XDG_CURRENT_DESKTOP=GNOME`

- https://github.com/NixOS/nixpkgs/issues/10559#issuecomment-372866821

## Playbin

Derivation has runtime dependency `gst_all_1.gst-plugin-base` to provide `playbin`, a package noted in an error log message:
`ERROR: GstPlay: 'playbin' element not found, please check your setup`

- https://github.com/NixOS/nixpkgs/issues/10559#issuecomment-372866822

## Enabling logs

```bash
G_MESSAGES_DEBUG=all settings
```
