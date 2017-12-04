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
GDAX_KEY="[a-f0-9]{32}"
GDAX_SECRET="[a-zA-Z0-9=\/+]{88}"
POLONIEX_KEY="(([A-Z0-9]{8}\-){3})([A-Z0-9]{8})"
POLONIEX_SECRET="[a-f0-9]{128}"
BITTREX_KEY="[a-f0-9]{32}"
BITTREX_SECRET="[a-f0-9]{32}"

FORBIDDEN_EXP=( $GDAX_KEY $GDAX_SECRET $POLONIEX_KEY $POLONIEX_SECRET $BITTREX_KEY $BITTREX_SECRET)

EXCLUDE="'.lock'"
COMMAND1="ls -p | grep -v '/$'"
COMMAND2="grep -v $EXCLUDE"
FAIL_MESSAGE="COMMIT REJECTED Found possible secret keys. Please remove them before committing or use --no-verify to ignore and commit anyway.\n If this helped you, consider donating Bitcoin to: 183J9CYci5Xbe3YXct1BHyRjyxH89QiUCc I had BTC stolen :( just trying to earn it back ;)"

for expression in "${FORBIDDEN_EXP[@]}"
do
    :
    output=$(ls -p | grep -v '/$' | GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n -iE $expression)

    if [ $? -eq 0 ]
    then
        ls -p | grep -v '/$' | GREP_COLOR='4;5;37;41' xargs grep --color --with-filename -n -iE $expression
        echo '\n' $FAIL_MESSAGE '\n' && exit 1
    fi
done

STASHES=$(git stash list)
if [[ $STASHES == "$STASH_NAME" ]]; then
  git stash pop -q
fi