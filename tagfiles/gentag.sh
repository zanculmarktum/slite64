#!/bin/sh
#
# Generates tagfile(s) based on ../templates.

REPO_HOME=${REPO_HOME:-/fig/iso/slackware}
BRANCH=14.2

for TAGFILE in $REPO_HOME/slackware64-$BRANCH/slackware64/*/tagfile; do
  if [ ! -f "$TAGFILE" ]; then
    echo "${0##*/}: $TAGFILE: not found" >&2
    exit 1
  fi
  SERIES=${TAGFILE%/*}
  SERIES=${SERIES##*/}

  rm -Rf $SERIES
  mkdir -p $SERIES
  cp $TAGFILE $SERIES
done

# Sets everything to SKP.
sed -e 's/:[^:]*$/:SKP/' -i */tagfile

# Sets to ADD if specified on ../templates.
CMD="sed -i"
for LINE in $(sed -e 's/^\s*#.*//' -e 's/[^:]*:\( \)\?//' -e 's/\./\\&/' ../templates/base); do
  CMD="$CMD -e 's/^\($LINE\):...$/\1:ADD/'"
done
CMD="$CMD */tagfile"
# $CMD should produces something like:
#  sed -i \
#   -e 's/^\(foo\):...$/\1:ADD/' \
#   -e 's/^\(bar\):...$/\1:ADD/' \
#   -e 's/^\(baz\):...$/\1:ADD/' \
#  */tagfile
# where foo, bar, baz is a package name
# taken from ../templates.
eval $CMD

# vim:ts=2:sw=2:et
