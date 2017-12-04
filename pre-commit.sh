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
# FILES_PATTERN='\.(js|coffee)(\..+)?$'
echo "\nChecking commit...\n"
FORBIDDEN='[a-zA-Z0-9|$-\/|:-?|{-~|]{32}'
EXCLUDE='.lock'
git diff --cached --name-only | \
    grep -v $EXCLUDE | \
    GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n -iE $FORBIDDEN \
    && echo 'COMMIT REJECTED Found possible secret keys. Please remove them before committing or use --no-verify to ignore and commit anyway' \
    && echo 'If this helped you, consider donating BTC to: 183J9CYci5Xbe3YXct1BHyRjyxH89QiUCc I had .25 BTC stolen just trying to earn it back ;)' \
    && exit 1

STASHES=$(git stash list)
if [[ $STASHES == "$STASH_NAME" ]]; then
  git stash pop -q
fi