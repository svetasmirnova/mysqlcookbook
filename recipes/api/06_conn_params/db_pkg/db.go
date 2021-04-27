// db.go : Configuration parser package
package db

// stdlib
import (
	"fmt"
	"os"

	"gopkg.in/ini.v1"
)

// external
func MyCnf(client string) (string, error) {
	cfg, err := ini.LoadSources(ini.LoadOptions{AllowBooleanKeys: true}, os.Getenv("HOME")+"/.my.cnf")
	if err != nil {
		return "", err
	}
	for _, s := range cfg.Sections() {
		if client != "" && s.Name() != client {
			continue
		}
		host := s.Key("host").String()
		port := s.Key("port").String()
		dbname := s.Key("dbname").String()
		user := s.Key("user").String()
		password := s.Key("password").String()
		return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", user, password, host, port, dbname), nil
	}
	return "", fmt.Errorf("No matching entry found in ~/.my.cnf")
}
