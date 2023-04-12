package packerlib

// RootPartitionSizes describes how big a single root partition should
// be given a standard 256M boot partition. This should cover standard
// install media sizes.
var RootPartitionSizes = map[string]string{
	"4G":  "3.7G",
	"8G":  "7.7G",
	"16G": "15.7G",
	"32G": "31.7G",
}

// Safe defaults that can be used when a custom option isn't needed.
const (
	QemuDefaultPath          = "/usr/bin/qemu-aarch64-static"
	RootPartitionSafeDefault = "2.8G"
	StandardPath             = "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
)

// Partition describes a partition in the generated image.
type Partition struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	StartSector int    `json:"start_sector"` // should be a uint64, except JSON
	Size        string `json:"size"`
	Mountpoint  string `json:"mountpoint"`
}

// Builder specifically refers to an Arm builder as used for the images
// generated for a computeblade.
type Builder struct {
	Type                      string      `json:"type"`
	FileURLs                  []string    `json:"file_urls"`
	FileChecksumURL           string      `json:"file_checksum_url"`
	FileChecksumType          string      `json:"file_checksum_type"`
	FileTargetExtension       string      `json:"file_target_extension"`
	FileUnarchiveCommand      []string    `json:"file_unarchive_cmd"`
	ImageBuildMethod          string      `json:"image_build_method"`
	ImagePath                 string      `json:"image_path"`
	ImageSize                 string      `json:"image_size"`
	ImageType                 string      `json:"image_type"`
	ImagePartitions           []Partition `json:"image_partitions"`
	ImageChrootEnviron        []string    `json:"image_chroot_env"`
	QemuBinarySourcePath      string      `json:"qemu_binary_source_path"`
	QemuBinaryDestinationPath string      `json:"qemu_binary_destination_path"`
}

func NewBuilder(fileURLs []string) Builder {
	return Builder{
		Type:     "arm",
		FileURLs: fileURLs,
	}
}

// With256MBootPartition returns a standard 256M boot partition.
func (b Builder) With256MBootPartition() Builder {
	p := Partition{
		Name:        "boot",
		Type:        "c",
		StartSector: 2048,
		Size:        "256M",
		Mountpoint:  "/boot/firmware",
	}

	b.ImagePartitions = append(b.ImagePartitions, p)
	return b
}

// WithSingleRootPartition should be called after With256MBootPartition,
// as it assumes a root partition immediately following the boot.
func (b Builder) WithSingleRootPartition(size string) Builder {
	p := Partition{
		Name:        "root",
		Type:        "83",
		StartSector: 526336,
		Size:        size,
		Mountpoint:  "/",
	}

	b.ImagePartitions = append(b.ImagePartitions, p)
	return b
}

// WithStandardImage generates a standard image with a boot and root partition.
func (b Builder) WithStandardImage(size string, outputPath string) Builder {
	b.ImageBuildMethod = "reuse"
	b.ImagePath = outputPath
	b.ImageSize = size
	b.ImageType = "dos"

	rootPartitionSize := RootPartitionSizes[size]
	if rootPartitionSize == "" {
		rootPartitionSize = RootPartitionSafeDefault
	}

	b = b.With256MBootPartition()
	b = b.WithSingleRootPartition(rootPartitionSize)

	// Append a standard PATH environment.
	b.ImageChrootEnviron = append(b.ImageChrootEnviron, StandardPath)

	return b
}

// WithStandard32GImage adds a standard 32G image spec to the Builder.
func (b Builder) WithStandard32GImage(outputPath string) Builder {
	return b.WithStandardImage("32G", outputPath)
}

// WithQemuDefaults sets the standard qemu path in the builder.
func (b Builder) WithQemuDefaults() Builder {
	b.QemuBinarySourcePath = QemuDefaultPath
	b.QemuBinaryDestinationPath = QemuDefaultPath

	return b
}

// WithSHA256Checksum sets a SHA256 checksum URL.
func (b Builder) WithSHA256Checksum(url string) Builder {
	b.FileChecksumURL = url
	b.FileChecksumType = "sha256"

	return b
}

func (b Builder) withXZ() Builder {
	b.FileTargetExtension = "xz"
	b.FileUnarchiveCommand = []string{
		"xz",
		"--decompress",
	}

	return b
}

func (b Builder) withUnzip() Builder {
	b.FileTargetExtension = "zip"
	b.FileUnarchiveCommand = []string{
		"unzip",
	}

	return b
}

func (b Builder) withTGZ() Builder {
	b.FileTargetExtension = "tgz"
	b.FileUnarchiveCommand = []string{
		"tar",
		"xzf",
	}

	return b
}

func (b Builder) withTarGZ() Builder {
	b.FileTargetExtension = "tar.gz"
	b.FileUnarchiveCommand = []string{
		"tar",
		"xzf",
	}

	return b
}

func (b Builder) withGZ() Builder {
	b.FileTargetExtension = "gz"
	b.FileUnarchiveCommand = []string{
		"gunzip",
	}

	return b
}

// WithUnarchiver fills in the appropriate unarchiver command given the
// archive extension.
func (b Builder) WithUnarchiver(extension string) Builder {
	switch extension {
	case "xz":
		b = b.withXZ()
	case "zip":
		b = b.withUnzip()
	case "tgz":
		b = b.withTGZ()
	case "tar.gz":
		b = b.withTarGZ()
	case "gz":
		b = b.withGZ()
	}

	b.FileUnarchiveCommand = append(b.FileUnarchiveCommand, "$ARCHIVE_PATH")
	return b
}
