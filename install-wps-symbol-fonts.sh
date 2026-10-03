#!/bin/bash
set -e

# WPS Office symbol fonts fix
# Installs only the six fonts WPS reports as missing in its "System Check":
# Symbol, Wingdings, Wingdings 2, Wingdings 3, Webdings, MT Extra.
# Fonts come from github.com/dv-anomaly/ttf-wps-fonts, pinned to a commit
# and verified by SHA-256.

REPO_COMMIT="8c980c24289cb08e03f72915970ce1bd6767e45a"
BASE_URL="https://raw.githubusercontent.com/dv-anomaly/ttf-wps-fonts/$REPO_COMMIT"
FONT_DIR="$HOME/.local/share/fonts/wps-symbol-fonts"

FONTS=(
    "bbf1192965e5266fbf23370416337d2861fc1e8bd349def93f2994ba67382fc3  symbol.ttf"
    "9bcd6064e3b52fa30a347edd6e82506e2ec8b1602930b423c629a82c10468a5b  wingding.ttf"
    "fa671b6fddedd57f158ab90b6aa6a7c33db6f41ab620db72b7ad1e57c38bda5f  WINGDNG2.ttf"
    "ac9ee085920a3d8b076d5e0c61dc9df42c4bac28d1fc968344f9ceddb3972f69  WINGDNG3.ttf"
    "1161ce511c44eb5464a4f8144aaf3eb965a50ed66957ad7d38e497ab9d958e5a  WEBDINGS.TTF"
    "e117624aacdf36dadbfdfaa6ce0b67e697c8d0fad927c554042404027f25415e  mtextra.ttf"
)

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "==> Downloading fonts..."
for entry in "${FONTS[@]}"; do
    file="${entry##* }"
    curl -fsSL -o "$TMP_DIR/$file" "$BASE_URL/$file"
done

echo "==> Verifying checksums..."
(cd "$TMP_DIR" && printf '%s\n' "${FONTS[@]}" | sha256sum -c --quiet)

echo "==> Installing to $FONT_DIR..."
mkdir -p "$FONT_DIR"
cp "$TMP_DIR"/*.ttf "$TMP_DIR"/*.TTF "$FONT_DIR/"

echo "==> Updating font cache..."
fc-cache -f "$FONT_DIR" >/dev/null

echo
for family in "Symbol" "Wingdings" "Wingdings 2" "Wingdings 3" "Webdings" "MT Extra"; do
    printf "  %-12s -> %s\n" "$family" "$(fc-match "$family" family)"
done
echo
echo "Done. Restart WPS Office (save your documents first)."
