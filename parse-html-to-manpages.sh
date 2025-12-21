#!/bin/bash

for checkprog in lynx sponge; do
	if ! command -v "$checkprog" 2>&1 > /dev/null; then
		echo "No '$checkprog' command found required by the script."
		exit 1
	fi
done


set -ex

HTMLFILE="$1"

[ ! -f "$HTMLFILE" ] && echo "No file '$HTMLFILE' found!" && exit 2

TRIMMEDFILE="${HTMLFILE%.html}_trimmed.html"
LINKSDUMPFILE="${HTMLFILE%.html}_links-dump.html"

MANPAGES_OUTPUT_DIR="manpages/en/"


# Cut everything unnecessary from file, left only "<body>CCMD1 \n CCMD2 \n CCMD3 \n ...</body>":

cat "$HTMLFILE" \
	| grep -F '<span class="mw-headline"' -A 999999 \
	| awk 'match($0, "<div class=\"printfooter\" data-nosnippet=\"\">"){ exit; } match($0, "<h2><span class=\"mw-headline\" id=\"See_Also\">See Also</span></h2>") { exit; } 1' \
	| awk 'BEGIN {print "<html><body>"} END {print "</body></html>"} 1' \
	> "$TRIMMEDFILE"

exit 24


# Dump file:

lynx -dump "$TRIMMEDFILE" -width 99999 -list_inline > "$LINKSDUMPFILE"



cat "$LINKSDUMPFILE" \
	| grep -vE "^\w{2,}" \
	| sed -E "s=\[(https?|file)://[^ ]+\]([0-9A-Za-z_\-]+)={{\2}}=g" \
	| sponge "$LINKSDUMPFILE"

exit 23
python3 parse-html-to-manpages.py "$LINKSDUMPFILE"


# Cleaning:

rm -vf "$TRIMMEDFILE"
rm -vf "$LINKSDUMPFILE"
