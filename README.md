# ci-test

## Functional IT

IT means that the target function in free5GC will be test by go test code to ensure each step is worked as expected, like: registration / PDU session establishment.

![it-topo](./doc/images/it-topo.png)

- TestRegistration
- TestDeregistration
- TestGUTIRegistration
- TestEAPAKAPrimeAuthentication
- TestDuplicateRegistration
- TestServiceRequest
- TestPDUSessionReleaseRequest
- TestNasReroute
- TestN2Handover
- TestXnHandover
- TestPaging
- TestReSynchronization
- TestMultiAmfRegistration
- TestDC
- TestDynamicDC
- TestXnDcHandover
- TestRequestTwoPDUSessions
- TestNon3GPP
- TestTngf

- OAuth version

## E2E

E2E test will launch a simulate UE via [free-ran-ue](https://github.com/free-ran-ue). This will help to establish a UE network tunnel for testing data plane traffic to data network, like: `ping`.

### Basic

![basic-topo](./doc/images/basic-topo.png)

- [RegPduCharging](./doc/RegPduCharging.md)

### ULCL

![ulcl-topo](./doc/images/ulcl-topo.png)

- [Traffic Influence](./doc/ulcl-traffic-influence.md)
- [Multi-path](./doc/ulcl-multi-path.md)

## Test Workflow

1. Call `ci-test-xxx.sh` at root path.
2. The test directory will be mounted to the test container. The script called at first step will execute the test case in the container.

### Build and run local sources

After checking out the required revisions in `free5gc/` and its submodules, run:

```bash
./ci-operation.sh build &&
./ci-test-e2e-ulcl.sh --test TestULCLTrafficInfluence --build
```

`ci-operation.sh build` runs `make nfs`: it compiles the local sources into
`free5gc/all-base`, then builds the service images for the IT, basic E2E and ULCL
composes. Rebuilding only `all-base` does not update service images that already
copied binaries from an older build.

The test runners' `--build` option selects the local build compose and passes
`--build` to `docker compose up`, so service images are rebuilt from the current
`all-base` before testing. Run `ci-operation.sh build` again after changing NF
sources; the runners do not compile `all-base` themselves. Without `--build`, the
runners use the published-image compose as before. These commands do not update
Git revisions automatically.
