// select_nullv2.go : Selecting NULL values in Golang
package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

type Profile struct {
	name     string
	birthday sql.NullTime
}

func (p *Profile) String() string {
	b := ""
	if p.birthday.Valid {
		b = p.birthday.Time.Format("2006-January-02")
	}
	return fmt.Sprintf("%s %s", p.name, b)
}

func main() {

	db, err := sql.Open("mysql", "cbuser:cbpass@tcp(127.0.0.1:3306)/cookbook?parseTime=true")
	defer db.Close()

	if err != nil {
		log.Fatal(err)
	}

	sql := "SELECT name, birth as birthday from profile WHERE id = 9"
	res, err := db.Query(sql)
	defer res.Close()

	if err != nil {
		log.Fatal(err)
	}

	for res.Next() {
		var profile Profile
		err = res.Scan(&profile.name, &profile.birthday)
		if err != nil {
			log.Fatal(err)
		}

		fmt.Println(profile.String())
	}
}
