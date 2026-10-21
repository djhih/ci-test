package test

import (
	"os"
	"os/exec"
	"testing"
	"time"

	"test/freeRanUe"
	"test/pinger"
)

func TestULCLTrafficInfluence(t *testing.T) {
	// FreeRanUe
	fru, err := freeRanUe.NewFreeRanUe()
	if err != nil {
		t.Fatalf("Failed to create FreeRanUe: %v", err)
	}
	err = fru.Activate()
	if err != nil {
		t.Fatalf("Failed to activate FreeRanUe: %v", err)
	}
	defer func() {
		if err := fru.Deactivate(); err != nil {
			t.Errorf("Failed to deactivate FreeRanUe: %v", err)
		}
	}()

	// before TI
	t.Run("Before TI", func(t *testing.T) {
		pingN6gwSuccessMecFailed(t)
	})

	// post TI
	tiOperation(t, "put")

	// after TI
	t.Run("After TI", func(t *testing.T) {
		pingN6gwFailedMecSuccess(t)
	})

	// delete TI
	tiOperation(t, "delete")

	// reset TI
	t.Run("Reset TI", func(t *testing.T) {
		pingN6gwSuccessMecFailed(t)
	})

	// flow level ping
	t.Run("Flow Level Ping", func(t *testing.T) {
		pingOneOneOneOne(t)
	})

	// check charging record
	t.Run("Check Charging Record", func(t *testing.T) {
		checkChargingRecord(t)
	})
}

func pingN6gwSuccessMecFailed(t *testing.T) {
	err := pinger.Pinger(N6GW_IP, NIC_1)
	if err != nil {
		t.Errorf("Ping n6gw failed: expected ping success, but got %v", err)
	}
	err = pinger.Pinger(MEC_IP, NIC_1)
	if err == nil {
		t.Errorf("Ping mec success: expected ping failed, but got success")
	}
}

func pingN6gwFailedMecSuccess(t *testing.T) {
	err := pinger.Pinger(N6GW_IP, NIC_1)
	if err == nil {
		t.Errorf("Ping n6gw success: expected ping failed, but got success")
	}
	err = pinger.Pinger(MEC_IP, NIC_1)
	if err != nil {
		t.Errorf("Ping mec failed: expected ping success, but got %v", err)
	}
}

func pingOneOneOneOne(t *testing.T) {
	err := pinger.Pinger(ONE_IP, NIC_1)
	if err != nil {
		t.Errorf("Ping one.one.one.one failed: expected ping success, but got %v", err)
	}
}

func tiOperation(t *testing.T, operation string) {
	cmd := exec.Command("bash", "../api-udr-ti-data-action.sh", operation)
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Errorf("TI operation failed: expected %s success, but got %v, output: %s", operation, err, output)
	}
	time.Sleep(300 * time.Millisecond)
}

func TestTrafficInfluencePing(t *testing.T) {
	scenario := os.Getenv("TI_SCENARIO")
	n6gwDuringTI := true
	switch scenario {
	case "":
		t.Skip("TI_SCENARIO is set by the added TI shell cases")
	case "full", "partial":
	case "mixed":
		n6gwDuringTI = false
	default:
		t.Fatalf("Unknown TI scenario: %s", scenario)
	}

	// Clear TI before registering the UE and after any test failure.
	tiOperation(t, "delete")
	fru, err := freeRanUe.NewFreeRanUe()
	if err != nil {
		t.Fatalf("Failed to create FreeRanUe: %v", err)
	}
	if err = fru.Activate(); err != nil {
		t.Fatalf("Failed to activate FreeRanUe: %v", err)
	}
	defer func() {
		if err := fru.Deactivate(); err != nil {
			t.Errorf("Failed to deactivate FreeRanUe: %v", err)
		}
	}()
	defer tiOperation(t, "delete")

	pingTargets := func(t *testing.T, n6gwSuccess, mecSuccess bool) {
		err := pinger.Pinger(N6GW_IP, NIC_1)
		if (err == nil) != n6gwSuccess {
			t.Errorf("Ping n6gw: expected success=%t, got error=%v", n6gwSuccess, err)
		}
		err = pinger.Pinger(MEC_IP, NIC_1)
		if (err == nil) != mecSuccess {
			t.Errorf("Ping mec: expected success=%t, got error=%v", mecSuccess, err)
		}
		pingOneOneOneOne(t)
	}

	t.Run("Before TI", func(t *testing.T) {
		pingTargets(t, true, false)
	})

	// Post this scenario's TI JSON using the same endpoint as the original test.
	cmd := exec.Command("curl", "-sS", "--fail-with-body", "--connect-timeout", "5", "--max-time", "20",
		"-X", "PUT", "-H", "Content-Type: application/json",
		"--data-binary", "@../json/ti-data-"+scenario+".json",
		"http://udr.free5gc.org:8000/nudr-dr/v2/application-data/influenceData/1")
	if output, err := cmd.CombinedOutput(); err != nil {
		t.Fatalf("TI put failed: %v, output: %s", err, output)
	}
	time.Sleep(300 * time.Millisecond)

	t.Run("After TI", func(t *testing.T) {
		pingTargets(t, n6gwDuringTI, true)
	})

	tiOperation(t, "delete")
	t.Run("Reset TI", func(t *testing.T) {
		pingTargets(t, true, false)
	})
}
