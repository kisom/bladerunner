package packer

type Board struct {
	Variables      interface{}   `json:"variables"`
	Builders       []Builder     `json:"builders"`
	Provisioners   []Provisioner `json:"provisioners"`
	PostProcessors []string      `json:"post-processors"`
}
