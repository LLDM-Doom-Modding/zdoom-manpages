#!/bin/bash

set -ex

cd en

ls | sed -E "s=.+$=page & en/&=1" | column -t --output-separator " " > ../manpages-wiki-autosync.cfg

ls +* | sed -E "s=\+(.+)$=alias \1 +\1=1" | column -t --output-separator " " >> ../manpages-wiki-autosync.cfg
