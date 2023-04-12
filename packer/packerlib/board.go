package packerlib

type Board struct {
	Variables      map[string]string `json:"variables"`
	Builders       []Builder         `json:"builders"`
	Provisioners   []Provisioner     `json:"provisioners"`
	PostProcessors []string          `json:"post-processors"`
}
