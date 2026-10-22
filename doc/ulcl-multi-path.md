# ULCL Multi-path

## Topology

```text
ci1(ue1) - gnb1 - i-upf1 - psa-upf1
ci2(ue2) - gnb2 - i-upf2 - psa-upf2
```

## Test Command

```bash
./ci-test-e2e-ulcl.sh --build --test TestULCLMultiPathUe
```

The runner executes `test-e2e-ulcl-mp.sh TestULCLMultiPathUe1` and `test-e2e-ulcl-mp.sh TestULCLMultiPathUe2` in their respective UE containers.

## Test File

- [e2e_ulclMultiPath_test.go](../test/goTest/e2e_ulclMultiPath_test.go)
- [test-e2e-ulcl-mp.sh](../test/test-e2e-ulcl-mp.sh)

## Test Cases

For each UE, the shell script runs the original subscription, then full and partial overlap subscriptions: six sessions in total. All cases reuse the original Go test.

| Subscription | Service filter | Static MEC route |
| --- | --- | --- |
| Original | `1.1.1.1/32` | `10.100.100.0/24` |
| Full overlap | `10.100.100.0/24` | `10.100.100.0/24` |
| Partial overlap | `10.100.0.0/16` | `10.100.100.0/24` |

1. Ping N6GW (10.100.50.10): expected ping success
2. Ping MEC (10.100.100.10): expected ping success

Added subscription files are `webconsole-subscription-data-mp-<UE>-<case>.json`. They use MBR 20 Mbps with no GBR. The assertions check connectivity, not QFI/QER contents, rate enforcement or final charging settlement.

## Test Steps

1. Post ue subscription data to db via web console's api
2. Activate free-ue
3. Run [test cases](#test-cases)
4. Deactivate free-ue
5. Delete ue subscription data from db via web console's api
