#!/bin/sh
#
# Will check for API keys in what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# Use --no-verify to ignore

STASH_NAME="pre-commit-$(date +%s)"
git stash save -q --keep-index $STASH_NAME

# Test prospective commit
echo "\nChecking commit...\n"
FORBIDDEN='[a-zA-Z0-9|$-\/|:-?|{-~|]{32}'
EXCLUDE='.lock'
COMMAND="git diff --cached --name-only | grep -v $EXCLUDE | GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n -iE $FORBIDDEN"
FAIL_MESSAGE = "COMMIT REJECTED Found possible secret keys. Please remove them before committing or use --no-verify to ignore and commit anyway.\n If this helped you, consider donating Bitcoin to: 183J9CYci5Xbe3YXct1BHyRjyxH89QiUCc I had .25 BTC stolen :( just trying to earn it back ;)"

if $($COMMAND); then
  echo $FAIL_MESSAGE && exit 1
fi

STASHES=$(git stash list)
if [[ $STASHES == "$STASH_NAME" ]]; then
  git stash pop -q
fi