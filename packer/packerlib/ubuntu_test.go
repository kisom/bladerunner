package packerlib

import "testing"

func TestJSONPath(t *testing.T) {
	baseName := "cm4-cluster-ubuntu-22.04.2"
	spec := UbuntuBoardSpec{
		ImageName: "cm4-cluster-ubuntu-22.04.2" + ".img",
	}

	outPath := spec.JSONPath("")
	expected := baseName + ".json"
	if outPath != expected {
		t.Fatalf("bad JSON path name: have %s, expect %s", outPath, expected)
	}
}
