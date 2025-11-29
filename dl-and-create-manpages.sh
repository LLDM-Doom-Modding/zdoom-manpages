#!/bin/bash

set -ex

PARSESCRIPT="./parse-html-to-manpages.sh"

[ ! -x "$PARSESCRIPT" ] && echo "No parsing script '$PARSESCRIPT' found!" && exit 1

rm -rvf "manpages/en"


get_and_parse() {
	DLFILE="Downloaded_CCMD.html"

	curl "$1" -o "$DLFILE" --connect-timeout 5

	[[ $(cat "$DLFILE" | wc -l) == 0 ]] && echo "Empty output for '$1'." && return 1

	"$PARSESCRIPT" "$DLFILE"

	rm -v "$DLFILE"
}


get_and_parse "https://zdoom.org/wiki/CCMDs:Customization"
get_and_parse "https://zdoom.org/wiki/CCMDs:Debug"
get_and_parse "https://zdoom.org/wiki/CCMDs:Informational"
get_and_parse "https://zdoom.org/wiki/CCMDs:Multiplayer"
get_and_parse "https://zdoom.org/wiki/CCMDs:Control"
get_and_parse "https://zdoom.org/wiki/CCMDs:Other"
