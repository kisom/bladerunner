package main

import (
	"flag"

	"git.sr.ht/~kisom/goutils/die"
	packer "git.wntrmute.dev/kyle/bladerunner/packer/packerlib"
)

func main() {
	var specFile, outputDir string

	flag.StringVar(&specFile, "f", "ubuntu-boards.yml", "`path` to Ubuntu board spec file")
	flag.StringVar(&outputDir, "o", "", "`directory` to store Ubuntu boards")
	flag.Parse()

	boardSpecs, err := packer.LoadUbuntuSpecs(specFile)
	die.If(err)

	err = boardSpecs.WriteBoards(outputDir)
	die.If(err)
}
