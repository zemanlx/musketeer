#!/bin/bash

# Initialize both submodules
git submodule init

git submodule update ../lib/cbmc

# The forks of diffblue/cbmc that should be fetched into the submodule
# allowing for getting commits that aren't yet merged into the upstream fork
req_forks=( "$@" )

cd ../lib/cbmc/

for fork in "${req_forks[@]}"
do
  # We should use the following command to check whether the fork exists:
  # but it is unreliable so we just assume it exists.
  # curl https://api.github.com/repos/$fork/cbmc | jq ".id" -e
  # Return code is 0 if the repos exists

  # Check whether the specific fork is already a remote
  git remote | grep $fork > /dev/null
  result=$?

  if [ $result -ne 0 ]
  then
    # Fork not found - add it
    echo Adding fork $fork
    remote_add_result=`git remote add $fork git@github.com:$fork/cbmc.git`
  fi

  # Fetch all the forks to ensure we are up to date
  echo Fetching fork $fork
  git fetch $fork

done
