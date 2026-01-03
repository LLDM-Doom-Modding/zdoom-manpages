#!/bin/bash

for checkprog in curl truncate python3; do
	if ! command -v "$checkprog" 2>&1 > /dev/null; then
		echo "No '$checkprog' command found required by the script."
		exit 1
	fi
done


set -ex

UNITED_HTML="United_CCMDs.html"
UNITED_HTML_FOR_PARSE="United_CCMDs_for_parse.html"

add_html_united() {
	local DLFILE="Downloaded_ZDoom_Wiki_page.html"

	curl "$1" -o "$DLFILE" -L --max-redirs 5 --connect-timeout 5

	[[ $(cat "$DLFILE" | wc -l) == 0 ]] && echo "Empty output for '$1'." && return 1

	cat "$DLFILE" \
		| grep -F '<span class="mw-headline"' -A 999999 \
		| awk 'match($0, "<div class=\"printfooter\" data-nosnippet=\"\">"){ exit; } match($0, "<h2><span class=\"mw-headline\" id=\"See_Also\">See Also</span></h2>") { exit; } 1' \
		>> "$UNITED_HTML"

	rm -v "$DLFILE"
}


truncate --size=0 "$UNITED_HTML"

add_html_united "https://zdoom.org/wiki/CCMDs:Customization"
add_html_united "https://zdoom.org/wiki/CCMDs:Debug"
add_html_united "https://zdoom.org/wiki/CCMDs:Informational"
add_html_united "https://zdoom.org/wiki/CCMDs:Multiplayer"
add_html_united "https://zdoom.org/wiki/CCMDs:Control"
add_html_united "https://zdoom.org/wiki/CCMDs:Other"

echo '<html><body>' > "$UNITED_HTML_FOR_PARSE"
cat "$UNITED_HTML" >> "$UNITED_HTML_FOR_PARSE"
echo '</body></html>' >> "$UNITED_HTML_FOR_PARSE"

python3 parse-html-bs4-to-manpages.py "$UNITED_HTML_FOR_PARSE"

rm -v "$UNITED_HTML"
rm -v "$UNITED_HTML_FOR_PARSE"
