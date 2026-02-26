#!/bin/bash

set -ex

# Pipe through tempfile because "set -x" in "echo $VAR" is too verbose.
TEMPFILE="$(mktemp)"
cat "raw_data/all_ccmds.txt" | sort > "$TEMPFILE"


# Main pages, "page CMDNAME LANGUAGE_IDENTIFIER":
cat "$TEMPFILE" \
	| awk '/^[^-+]/ { print "page " $0 " CCMD_" toupper( $0 ) }' \
	| column -t --output-separator " " \
	> manpages-wiki-autosync.cfg


# Aliases, "alias ALTNAME CMDNAME":
cat "$TEMPFILE" \
	| awk '/^[-+]/ { NM = substr($0, 2); if ( $0 ~ "^+" ) { print "page \t" $0 "\t CCMDHOLD_" toupper( NM ) } else { print "alias\t" $0 "\t +" NM } }' \
	| column -t --separator "	" --output-separator " " \
	>> manpages-wiki-autosync.cfg


rm "$TEMPFILE"
