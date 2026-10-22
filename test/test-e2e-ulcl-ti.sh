#!/bin/bash

##########################
#
# usage:
# ./test-ulcl-ti.sh
#
# e.g. ./test-ulcl-ti.sh
#
##########################

suite_exit_code=0

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
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
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
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

# Additional TI cases: check N6GW, MEC and Internet ping behavior.

echo "test TestTrafficInfluenceFlowRuleOverlapFull with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-full-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapFull
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-full-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluenceFlowRuleOverlapFull with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-full-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapFull
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-full-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluenceFlowRuleOverlapPartial with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-partial-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapPartial
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-partial-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluenceFlowRuleOverlapPartial with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-partial-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapPartial
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-partial-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluenceFlowRuleOverlapMixed with offline charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-mixed-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapMixed
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-mixed-offline.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test TestTrafficInfluenceFlowRuleOverlapMixed with online charging"

# post ue (ci-test free-ran-ue) data to db
./api-webconsole-subscribtion-data-action.sh post json/webconsole-subscription-data-ti-mixed-online.json
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run TestTrafficInfluenceFlowRuleOverlapMixed
if [ $? -ne 0 ]; then
    suite_exit_code=1
fi
cd ..

# delete ue (ci-test free-ran-ue) data from db
./api-webconsole-subscribtion-data-action.sh delete json/webconsole-subscription-data-ti-mixed-online.json
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

# return the test exit code
exit $suite_exit_code
