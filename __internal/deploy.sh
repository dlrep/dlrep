#!/bin/bash

# Ozgur: Heavily based on the following.
# http://github.com/steveklabnik/automatically_update_github_pages_with_travis_example

set -o errexit
set -o nounset

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

git config --global user.name "dlrep-bot"
git config --global user.email "ozgurakgun+dlrep@gmail.com"
git config --global push.default simple

REV=$(git rev-parse --short HEAD)
TIME=$(date "+%Y-%m-%d %H:%M:%S")

if [ $TRAVIS_PULL_REQUEST != "false" ]; then
    echo "This is pull request number $TRAVIS_PULL_REQUEST."
    echo "The build will be deployed to to the 'previews' repository."

    # rebuild with custom baseurl
    JEKYLL_ENV=development bundle exec jekyll build --baseurl "/previews/PR-$TRAVIS_PULL_REQUEST"

    # clone repo
    rm -rf repo-upstream
    git clone "https://github.com/dlrep/previews.git" repo-upstream
    cd repo-upstream
    git checkout gh-pages                   # checkout the files

    # copy current files
    rm -rf PR-$TRAVIS_PULL_REQUEST
    cp -r ../_site PR-$TRAVIS_PULL_REQUEST

    # ship it
    git add --all
    if [[ -n $(git status -s) ]]; then
        echo "Deploying..."
        git commit -m "PR dlrep/dlrep#$TRAVIS_PULL_REQUEST, commit dlrep/dlrep@$REV (at $TIME)"
        (cd $SCRIPT_DIR ; wget -c https://www.dropbox.com/s/rva9x5ot3xdy596/dlrep-private?dl=0 ; chmod +x $SCRIPT_DIR/dlrep-private)
        $SCRIPT_DIR/dlrep-private push
        export GITHUB_COMMENT="Preview build: http://dlrep.github.io/previews/PR-$TRAVIS_PULL_REQUEST"
        $SCRIPT_DIR/dlrep-private comment $TRAVIS_PULL_REQUEST $GITHUB_COMMENT
    else
        echo "There were no changes."
        echo "Skipping deploy."
    fi


elif [ $TRAVIS_BRANCH == "master" ]; then
    echo "This is the master branch."
    echo "The build will be deployed to to the 'production' repository."

    # rebuild with custom baseurl
    JEKYLL_ENV=production bundle exec jekyll build --baseurl "http://dlrep.org"

    # clone repo
    rm -rf repo-upstream
    git clone "https://github.com/dlrep/production.git" repo-upstream
    cd repo-upstream
    git checkout gh-pages                   # checkout the files

    # copy current files
    rm -rf *
    echo "dlrep.org" > CNAME
    cp -r ../_site/* .

    # ship it
    git add --all
    if [[ -n $(git status -s) ]]; then
        echo "Deploying..."
        git commit -m "Deploying commit dlrep/dlrep@$REV (at $TIME)"
        git push "https://$GH_TOKEN@github.com/dlrep/production.git" gh-pages > stdout 2> stderr
        cat stdout stderr | sed "s/$GH_TOKEN/TOKEN/g"
    else
        echo "There were no changes."
        echo "Skipping deploy."
    fi


else
    echo "Skipping deploy."


fi
