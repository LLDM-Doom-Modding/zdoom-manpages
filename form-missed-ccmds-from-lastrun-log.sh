#!/bin/bash

LASTRUN_LOG_FILE="_lastrun.txt"

# This script searches in '$LASTRUN_LOG_FILE' for all patterns of format:
#
#   Wrong manpage '$NAME' with ID '$LOCZID' in file …
#
# and outputs a valid CSV lines for translation lump.

[ ! -f "$LASTRUN_LOG_FILE" ] && echo "'$LASTRUN_LOG_FILE' not found." && exit 1


cat "$LASTRUN_LOG_FILE" \
	| LC_ALL=C grep -E "^Wrong manpage '\+?[_[:alnum:]]+' with ID '[_[:alnum:]]+' in file" \
	| sed -E "s/.+'(\+?[_[:alnum:]]+)'\swith\sID\s'([_[:alnum:]]+)'.+/\1 \2/1" \
	| awk '{
		# "$1" == "wdir", "$2" == "CCMD_WDIR"
		NAME = $1
		LOCZID = $2

		printf( ",,MANPAGES_%s_NAME,%s,%s\n", LOCZID, NAME, NAME )
		printf( ",,MANPAGES_%s_DESC,,\n", LOCZID )
		printf( ",,MANPAGES_%s_EXMP,,\n", LOCZID )
	}'
