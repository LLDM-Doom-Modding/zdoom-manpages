#!/bin/bash

for checkprog in lynx; do
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
	| awk 'match($0, "<div class=\"printfooter\" data-nosnippet=\"\">"){ exit; } 1' \
	| head -n -1 \
	| awk 'BEGIN {print "<html><body>"} END {print "</body></html>"} 1' \
	> "$TRIMMEDFILE"


# Dump file:

lynx -dump "$TRIMMEDFILE" -width 99999 -list_inline > "$LINKSDUMPFILE"


# Parse dumped HTML and split into several files:

cat "$LINKSDUMPFILE" \
	| grep -vE "^\w{2,}" \
	| sed -E "s=\[(https?|file)://[^ ]+\]([0-9A-Za-z_\-]+)={{\2}}=g" \
	| awk '
	BEGIN {
		CMD=""; HEADER=""; DESCR=""; DESCRBREAK="";
		system( "mkdir -p '"$MANPAGES_OUTPUT_DIR"'" )
	}

	function file_exists(file) {
		if ( (getline _ < file) >= 0 ) {
			return 1;
		}
	}

	# Headers:
	/^\s{,5}\*/ {
		#print "\nHEADER \"" $0 "\", CMD \"" $2 "\"\n"

		if ( DESCR != "" && CMD != "" ) {
			if ( file_exists( "'"$MANPAGES_OUTPUT_DIR"'" CMD ) ) {
				print "Overwriting file \"'"$MANPAGES_OUTPUT_DIR"'" CMD "\"."
			} else {
				print "New file \"'"$MANPAGES_OUTPUT_DIR"'" CMD "\"."
			}

			sub( /^\s+/, "", DESCR )
			print HEADER "\n\n" DESCR > "'"$MANPAGES_OUTPUT_DIR"'" CMD
		}

		DESCR=""
		DESCRBREAK=""
		HEADER=$0
		CMD=$2
		sub( /^\s*\*\s*/, "", HEADER )
	}

	# Descriptions:
	! /^\s{,5}\*/ {
		sub( /\s+/, " " )
		DESCR=DESCR $0 "\n"

		#print "DESCR: " DESCR
	}

#	CMD && DESCR && ! /./ {
#		if ( DESCRBREAK ) {
#			print "EMPTY. DESCR: " DESCR
#		} else {
#			DESCRBREAK="1"
#		}
#	}
'


# Cleaning:

rm -vf "$TRIMMEDFILE"
rm -vf "$LINKSDUMPFILE"
