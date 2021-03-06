#!/bin/bash

set -e

echo "creating team extrateam under login target test_extrateam"

# create the extra team using the main target
fly -t test_main set-team --team-name=extrateam --ldap-user=included1

# we have to logout prio otherwise if we logged into the testserver back in time the login process below will succeed
# but it will actually not work.. just another bug in conccourse
fly -t test_extrateam logout || true
# create a login for the new team
fly -t test_extrateam login -c http://127.0.0.1:8080 -b --team-name=extrateam || (echo "please login yourself since http://127.0.0.1:8080 is not the right docker-machine ip for you" && exit 1)


# deploy the pipline
fly sp -t test_extrateam configure -c examples/simple/pipeline.yml -p mypipeline -n
# unpause the pipeline
fly -t test_extrateam unpause-pipeline -p mypipeline
