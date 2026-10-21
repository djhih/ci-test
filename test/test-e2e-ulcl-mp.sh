#!/bin/bash

##########################
#
# usage:
# ./test-ulcl-mp.sh <test-name>
#
# e.g. ./test-ulcl-mp.sh <TestULCLMultiPathUe1|TestULCLMultiPathUe2>
#
##########################

echo "test $1"

target_webconsole_subscription_data_file=""

case "$1" in
    "TestULCLMultiPathUe1")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-1.json"
    ;;
    "TestULCLMultiPathUe2")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-2.json"
    ;;
esac

echo "target_webconsole_subscription_data_file: $target_webconsole_subscription_data_file"

# post ue data to db
./api-webconsole-subscribtion-data-action.sh post $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -run $1
go_test_exit_code=$?
cd ..

# delete ue data from db
./api-webconsole-subscribtion-data-action.sh delete $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

# Additional static path overlap cases (the original default case above is unchanged).
suite_exit_code=$go_test_exit_code

echo "test $1 full"

target_webconsole_subscription_data_file=""

case "$1" in
    "TestULCLMultiPathUe1")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-1-full.json"
    ;;
    "TestULCLMultiPathUe2")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-2-full.json"
    ;;
esac

echo "target_webconsole_subscription_data_file: $target_webconsole_subscription_data_file"

# post ue data to db
./api-webconsole-subscribtion-data-action.sh post $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=3m -run "^$1$"
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue data from db
./api-webconsole-subscribtion-data-action.sh delete $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

echo "test $1 partial"

target_webconsole_subscription_data_file=""

case "$1" in
    "TestULCLMultiPathUe1")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-1-partial.json"
    ;;
    "TestULCLMultiPathUe2")
        target_webconsole_subscription_data_file="json/webconsole-subscription-data-mp-2-partial.json"
    ;;
esac

echo "target_webconsole_subscription_data_file: $target_webconsole_subscription_data_file"

# post ue data to db
./api-webconsole-subscribtion-data-action.sh post $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to post subscription data"
    exit 1
fi

# run test
cd goTest
go test -v -vet=off -count=1 -timeout=3m -run "^$1$"
go_test_exit_code=$?
cd ..
if [ $go_test_exit_code -ne 0 ]; then
    suite_exit_code=1
fi

# delete ue data from db
./api-webconsole-subscribtion-data-action.sh delete $target_webconsole_subscription_data_file
if [ $? -ne 0 ]; then
    echo "Failed to delete subscription data"
    exit 1
fi

exit $suite_exit_code
