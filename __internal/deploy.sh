#!/bin/bash

# Ozgur: Heavily based on the following.
# http://github.com/steveklabnik/automatically_update_github_pages_with_travis_example

set -o errexit
set -o nounset

git config --global user.name "Özgür Akgün"
git config --global user.email "ozgurakgun@gmail.com"

if [ $TRAVIS_PULL_REQUEST != "false" ]; then
    echo "This is pull request number $TRAVIS_PULL_REQUEST."
    echo "The build will be deployed to to the 'previews' repository."
    rev=$(git rev-parse --short HEAD)
    rm -rf repo-upstream
    git clone "https://github.com/dlrep/previews.git" repo-upstream
    cd repo-upstream
    git checkout -B gh-pages                # create the branch if it doesn't exist
    git checkout gh-pages                   # checkout the files
    rm -rf $TRAVIS_PULL_REQUEST
    cp -r ../_site $TRAVIS_PULL_REQUEST
    git add --all
    git commit -m "Preview build for PR dlrep/dlrep#$TRAVIS_PULL_REQUEST, commit dlrep/dlrep@$rev"
    git push "https://$GH_TOKEN@github.com/dlrep/previews.git" gh-pages > stdout 2> stderr
    cat stdout stderr | grep -v 'github.com/dlrep'

elif [ $TRAVIS_BRANCH == "master" ]; then
    echo "This is the master branch."
    echo "The build will be deployed to to the 'production' repository."
    rev=$(git rev-parse --short HEAD)
    rm -rf repo-upstream
    git clone "https://github.com/dlrep/production.git" repo-upstream
    cd repo-upstream
    git checkout -B gh-pages                # create the branch if it doesn't exist
    git checkout gh-pages                   # checkout the files
    rm -rf *
    cp -r ../_site/* .
    git add --all
    git commit -m "Deploying commit dlrep/dlrep@$rev"
    git push "https://$GH_TOKEN@github.com/dlrep/production.git" gh-pages > stdout 2> stderr
    cat stdout stderr | grep -v 'github.com/dlrep'

else
    echo "Skipping deploy."

fi