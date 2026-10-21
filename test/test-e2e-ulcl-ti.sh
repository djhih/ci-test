#!/bin/bash

##########################
#
# usage:
# ./test-ulcl-ti.sh
#
# e.g. ./test-ulcl-ti.sh
#
##########################

echo "test TestULCLTrafficInfluence with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestULCLTrafficInfluence
go_test_exit_code=$?
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestULCLTrafficInfluence with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestULCLTrafficInfluence
go_test_exit_code=$?
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

# Additional TI cases: check N6GW, MEC and Internet ping behavior.
suite_exit_code=$go_test_exit_code

echo "test TestTrafficInfluencePingFull with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-full-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingFull$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-full-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluencePingFull with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-full-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingFull$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-full-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluencePingPartial with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-partial-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingPartial$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-partial-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluencePingPartial with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-partial-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingPartial$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-partial-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluencePingMixed with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-mixed-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingMixed$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-mixed-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluencePingMixed with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-mixed-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=5m -run '^TestTrafficInfluencePingMixed$'
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-mixed-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

# return the test exit code
exit $suite_exit_code
