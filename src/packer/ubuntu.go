package packer

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"path/filepath"
	"strings"

	"gopkg.in/yaml.v2"
)

type urlSet struct {
	FileURLs    []string
	ChecksumURL string
}

// ubuntuImage returns a local cache path and a remote fetch path for an
// Ubuntu image for a given version.
func ubuntuImage(version string) urlSet {
	imageBase := fmt.Sprintf("ubuntu-%s-preinstalled-server-arm64+raspi.img.xz", version)
	imageDir := fmt.Sprintf("https://cdimage.ubuntu.com/releases/%s/release/", version)
	checksumURL := fmt.Sprintf("http://cdimage.ubuntu.com/releases/%s/release/SHA256SUMS", version)

	localImage := "build/" + imageBase
	remoteImage := imageDir + imageBase

	return urlSet{
		FileURLs: []string{
			localImage,
			remoteImage,
		},
		ChecksumURL: checksumURL,
	}
}

func UbuntuBuilder(version, size, outputPath string) Builder {
	urlSet := ubuntuImage(version)
	outputPath = "build/" + outputPath

	b := NewBuilder(urlSet.FileURLs)
	return b.
		WithSHA256Checksum(urlSet.ChecksumURL).
		WithUnarchiver("xz").
		WithStandardImage(size, outputPath).
		WithQemuDefaults()
}

type UbuntuBoardSpec struct {
	Version      string    `yaml:"version"`
	Size         string    `yaml:"size"`
	ImageName    string    `yaml:"name"`
	LocalScripts []string  `yaml:"local-scripts"`
	Files        []FileSet `yaml:"files"`
	Scripts      []string  `yaml:"scripts"`
}

func (spec UbuntuBoardSpec) JSONPath(base string) string {
	dest := spec.ImageName
	ext := filepath.Ext(dest)
	if ext != "" {
		ext = "." + ext
		dest = strings.TrimSuffix(dest, ext)
	}

	dest += ".json"
	if base != "" {
		dest = filepath.Join(base, dest)
	}
	return dest
}

func (spec UbuntuBoardSpec) Board() Board {
	board := Board{
		Variables: map[string]string{},
		Builders: []Builder{
			UbuntuBuilder(spec.Version, spec.Size, spec.ImageName),
		},
	}

	if len(spec.LocalScripts) != 0 {
		board = board.WithShellLocalProvisioner(spec.LocalScripts...)
	}

	if len(spec.Files) != 0 {
		board = board.WithFileSetsProvisioner(spec.Files)
	}

	if len(spec.Scripts) != 0 {
		board = board.WithShellProvisioner(spec.Scripts...)
	}

	return board
}

func LoadUbuntuSpecs(path string) (specFile UbuntuBoardSpecFile, err error) {
	log.Println("loading from", specFile)
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return
	}

	log.Println("parsing specs")
	err = yaml.Unmarshal(data, &specFile)
	if err != nil {
		return
	}

	return specFile, nil
}

// UbuntuBoardSpecFile describes a set of specifications for Ubuntu boards.
//
// In the future, this may include additional data.
type UbuntuBoardSpecFile struct {
	Boards []UbuntuBoardSpec `yaml:"boards"`
}

func (specFile UbuntuBoardSpecFile) WriteBoards(outputDir string) error {
	for _, spec := range specFile.Boards {
		board := spec.Board()
		dest := spec.JSONPath(outputDir)

		contents, err := json.Marshal(board)
		if err != nil {
			return err
		}

		buf := &bytes.Buffer{}
		err = json.Indent(buf, contents, "", "    ")
		if err != nil {
			return err
		}
		contents = buf.Bytes()

		log.Println("writing spec to", dest)
		err = ioutil.WriteFile(dest, contents, 0644)
		if err != nil {
			return err
		}
	}

	return nil
}
