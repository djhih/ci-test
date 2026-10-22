# ULCL Internet probes fail with mismatched routing and NAT

## Symptoms

N6GW/MEC connectivity checks pass, but UE Internet probes to 1.1.1.1 fail.

## Cause

A PSA-UPF connects to both `privnet` and `n6-net`. Its UE MASQUERADE rule targets the N6 interface selected by `natIfCIDR: 10.100.50.0/24`, but Docker may select the internal-network gateway as the default route. Internet traffic then leaves through an interface without the matching UE NAT rule.

## Diagnosis

Inspect each PSA-UPF after startup:

```bash
docker exec psa-upf-0 ip -br addr
docker exec psa-upf-0 ip route get 1.1.1.1
docker exec psa-upf-0 iptables -t nat -S POSTROUTING
```

The Internet route must use the intended N6 gateway and interface, and the UE MASQUERADE rule must target that same interface. Identify the interface from its subnet rather than assuming it is always eth0 or eth1.

## Workaround

For this topology, route Internet traffic through N6 gateway 10.100.50.1. A local Compose override can give each PSA-UPF's `n6-net` attachment `gw_priority: 1` (Docker Compose 2.33.1 or later). Recreate the affected containers and verify their routes before rerunning the suite. See [Docker's gateway priority documentation](https://docs.docker.com/reference/compose-file/services/#gw_priority).

The E2E tests do not modify routes or NAT rules automatically.
