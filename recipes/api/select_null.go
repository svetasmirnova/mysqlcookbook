package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

type Profile struct {
	name     string
	birthday string
}

func main() {

	db, err := sql.Open("mysql", "cbuser:Cbuser2021!@tcp(127.0.0.1:3306)/cookbook")
	defer db.Close()

	if err != nil {
		log.Fatal(err)
	}

	sql := "SELECT name, COALESCE(birth, '') as birthday from profile WHERE id = 5"
	//sql := "SELECT name, birth as birthday from profile WHERE id = 9"
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

		fmt.Printf("%v\n", profile)
	}
}
