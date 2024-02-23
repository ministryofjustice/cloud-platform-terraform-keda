package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

var (
	wntErr bool
)

func TestKEDAValidateSuccess(t *testing.T) {
	t.Parallel()
	t.Log("Testing KEDA module")
	wntErr = false

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-test/success",
	}

	_, err := terraform.InitE(t, terraformOptions)
	if err != nil {
		t.Fatal(err)
	}

	v, err := terraform.PlanE(t, terraformOptions)
	if err != nil && !wntErr {
		t.Fatalf("Wanted Error: %v\nExpected nil got %v", wntErr, err)

	} else {
		t.Logf("Wanted Error: %v\nExpected nil got %v", wntErr, err)
		t.Log(v)
	}

}

func TestKEDAValidateFailure(t *testing.T) {
	t.Parallel()
	t.Log("Testing KEDA module")
	wntErr = true

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-test/failure",
	}

	_, err := terraform.InitE(t, terraformOptions)
	if err != nil {
		t.Fatal(err)
	}

	v, err := terraform.PlanE(t, terraformOptions)
	if err != nil && wntErr {
		t.Logf("Wanted Error: %v\nExpected error got %v", wntErr, err)
		t.Log(v)
	} else {
		t.Fatalf("Wanted Error: %v\nExpected error got %v", wntErr, err)
	}
}
