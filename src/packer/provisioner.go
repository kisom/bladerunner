package packer

type Provisioner map[string]interface{}

// ShellProvisioner provisions machines built by Packer using shell scripts.
func ShellProvisioner(scripts ...string) Provisioner {
	return map[string]interface{}{
		"type":    "shell",
		"scripts": scripts,
	}
}

// ShellLocalProvisioner will run a shell script of your choosing on the
// machine where Packer is being run - in other words, shell-local will run
// the shell script on your build server, or your desktop, etc., rather than
// the remote/guest machine being provisioned by Packer.
func ShellLocalProvisioner(scripts ...string) Provisioner {
	return map[string]interface{}{
		"type":    "shell-local",
		"scripts": scripts,
	}
}

// uploads files to machines built by Packer. The recommended usage of the file
// provisioner is to use it to upload files, and then use shell provisioner to
// move them to the proper place, set permissions, etc.
func FileProvisioner(src, dest string) Provisioner {
	return map[string]interface{}{
		"type":        "file",
		"source":      src,
		"destination": dest,
	}
}

// BreakpointProvisioner pauses until the user presses "enter" to resume the build.
func BreakpointProvisioner(note string) Provisioner {
	return map[string]interface{}{
		"type":    "breakpoint",
		"disable": false,
		"note":    note,
	}
}

func (b Board) WithShellProvisioner(scripts ...string) Board {
	b.Provisioners = append(b.Provisioners, ShellProvisioner(scripts...))
	return b
}

func (b Board) WithShellLocalProvisioner(scripts ...string) Board {
	b.Provisioners = append(b.Provisioners, ShellLocalProvisioner(scripts...))
	return b
}

func (b Board) WithFileProvisioner(src, dest string) Board {
	b.Provisioners = append(b.Provisioners, FileProvisioner(src, dest))
	return b
}

func (b Board) WithBreakpointProvisioner(note string) Board {
	b.Provisioners = append(b.Provisioners, BreakpointProvisioner(note))
	return b
}

type FileSet struct {
	Source      string `yaml:"source"`
	Destination string `yaml:"destination"`
}

func (fs FileSet) Provisioner() Provisioner {
	return FileProvisioner(fs.Source, fs.Destination)
}

func (b Board) WithFileSetsProvisioner(fileSets []FileSet) Board {
	for _, fs := range fileSets {
		b.Provisioners = append(b.Provisioners, fs.Provisioner())
	}
	return b
}
