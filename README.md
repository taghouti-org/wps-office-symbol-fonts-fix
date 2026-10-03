# WPS Office Missing Symbol Fonts Fix (Linux)

Fixes the WPS Office **System Check** warning on Linux:

> Some formula symbols might not be displayed correctly due to missing fonts Symbol, Wingdings, Wingdings 2, Wingdings 3, Webdings, MT Extra.

## Problem

WPS Office uses six Microsoft symbol fonts to draw math formulas, bullets and special characters. Linux distributions don't ship them, so WPS shows this warning at every start, and symbols render as the wrong characters.

## Solution

A small installer that downloads **only these six fonts** and installs them for your user:

- Fonts come from the community [ttf-wps-fonts](https://github.com/dv-anomaly/ttf-wps-fonts) repository, **pinned to a fixed commit**.
- Every file is **checked against a SHA-256 checksum** before it's installed.
- Nothing else is installed. That repository now also contains a full set of Windows fonts (Arial, Calibri, Segoe…); they're deliberately left out so your other fonts don't change.
- No `sudo` needed.

## Quick Install

```bash
curl -L https://gist.github.com/taghouttarek/da69be8da0e4f9eaec5484a94d7ed01f/raw/install-wps-symbol-fonts.sh | bash
```

Then **save your documents and restart WPS Office**. WPS only checks fonts at startup.

## Check it worked

```bash
for f in "Symbol" "Wingdings" "Wingdings 2" "Wingdings 3" "Webdings" "MT Extra"; do
    printf "%-12s -> %s\n" "$f" "$(fc-match "$f" family)"
done
```

Each line should show the same name on both sides (e.g. `Wingdings -> Wingdings`). Before the fix, they fall back to something like `Noto Sans` or `DejaVu Sans`.

## Requirements

- Linux with fontconfig (`fc-cache`, `fc-match`), `curl` and `sha256sum`
- Tested on Kubuntu 24.04 with WPS Office

## What gets installed

| Font | File |
|------|------|
| Symbol | `symbol.ttf` |
| Wingdings | `wingding.ttf` |
| Wingdings 2 | `WINGDNG2.ttf` |
| Wingdings 3 | `WINGDNG3.ttf` |
| Webdings | `WEBDINGS.TTF` |
| MT Extra | `mtextra.ttf` |

All into `~/.local/share/fonts/wps-symbol-fonts/`.

## Uninstall

```bash
rm -rf ~/.local/share/fonts/wps-symbol-fonts
fc-cache -f
```

## Note on licensing

These are proprietary Microsoft fonts. This gist doesn't redistribute them; the installer downloads them from the third-party repository above. Make sure your use complies with the fonts' license (for example, if you own a Windows or Microsoft Office license, you can copy the same files from `C:\Windows\Fonts` instead).
