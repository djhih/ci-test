# ULCL regression tests

## Traffic influence

The original offline/online blocks and original Go test functions remain unchanged. Six blocks are appended to `test/test-e2e-ulcl-ti.sh`: full, partial and mixed, each with offline/online subscription JSON. The added `TestTrafficInfluencePing` checks N6GW (`10.100.50.10`), MEC (`10.100.100.10`) and Internet (`1.1.1.1`) reachability before TI, after TI and after deletion. It reuses the original pinger and does not query PCF policies or charging records.

```bash
./ci-test-e2e-ulcl.sh --build --test TestULCLTrafficInfluence
```

| Added case | Service filter | TI remote filter | N6GW during TI | MEC during TI | 1.1.1.1 during TI |
| --- | --- | --- | --- | --- | --- |
| full | `10.100.100.0/24` | `10.100.100.0/24` | reachable | reachable | reachable |
| partial | `10.100.0.0/16` | `10.100.100.0/24` | reachable | reachable | reachable |
| mixed | `10.100.100.0/24` | `10.100.0.0/16` | unreachable | reachable | reachable |

Before adding TI and after deleting TI, N6GW and Internet must be reachable while MEC must be unreachable. During TI, MEC must be reachable in all three cases. The mixed TI filter covers N6GW and sends that traffic toward MEC, whose lab configuration does not forward it to N6GW; the narrower full/partial TI filters exclude N6GW. All three filters exclude `1.1.1.1`.

Subscription files are `webconsole-subscription-data-ti-<case>-<charging>.json`; TI payloads are `ti-data-<case>.json`. There is no case manifest, policy-comparison framework or assertion self-test. Added cases only check the stated connectivity; they do not establish that the service's QoS/QER binding is correct. Original test behavior, including its existing checks, is retained above them.

Earlier runs without the CHF requestedUnit fix passed the original offline/online TI assertions while errors remained in NF logs. Ping success does not prove successful final account settlement.

## Static multipath

The MP additions remain: the original default block is followed by full and partial overlap using the same post subscription / run test / delete subscription format. Only the terminal exit was moved after the appended blocks. All cases reuse the original `TestULCLMultiPathUe1` / `TestULCLMultiPathUe2` Go tests.

```bash
./ci-test-e2e-ulcl.sh --build --test TestULCLMultiPathUe
```

| Case | Service filter | Expected binding |
| --- | --- | --- |
| Original | Original `1.1.1.1/32` | Static MEC uses the default flow |
| full | `10.100.100.0/24` | Static MEC uses dedicated service QoS |
| partial | `10.100.0.0/16` | MEC and other N6 traffic share service QoS across paths |

Added fixtures are `webconsole-subscription-data-mp-<UE>-<case>.json`, preserving each UE's SUPI/slice with MBR 20 Mbps and no GBR. Each MP test verifies that both N6GW and MEC are reachable. These assertions do not inspect PFCP wire QFI, enforce MBR, or verify final charging settlement.

## Versions and checks

Build images containing the intended [PCF #87](https://github.com/free5gc/pcf/pull/87), [SMF #253](https://github.com/free5gc/smf/pull/253) and, when testing the requestedUnit correction, [CHF #79](https://github.com/free5gc/chf/pull/79). The original `--build` flag selects the build compose file; it does not check out PR revisions or update old images automatically.

The suites run eight TI sessions (two original and six added) and six MP sessions. The original host runner and API helpers are unchanged.

Before interpreting Internet probe failures, check that each PSA-UPF default route uses its N6 interface, matching the interface selected by its UE MASQUERADE rule. Docker may select the internal network gateway on a container with multiple networks; in that case N6GW/MEC probes can work while UE Internet probes fail because the packet leaves through an interface without UE NAT. Correct that environment route before rerunning the suite.

```bash
bash -n test/test-e2e-ulcl-ti.sh test/test-e2e-ulcl-mp.sh
cd test/goTest
go test -run '^$' ./...
```

CHF #79 corrects rejection of final ONLINE usage without requestedUnit. The SMF/PCF ordering that deletes charging data before CHF's final settlement is a separate problem: ABMF may not find the account and can time out. It remains outside that PR.
