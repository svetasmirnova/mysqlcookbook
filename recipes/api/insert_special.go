// insert_special.go : Inserting special values to table.
package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

type Profile profile {
	name  string
	birth string
	color string
	foods string
	cats  int
}

func insert(db *sql.DB, p profile) error {
	sql := "INSERT INTO profile(name, birth, color, foods, cats) VALUES (?, ?, ?, ?, ?)"
	stmt, err := db.PrepareContext(sql)
	if err != nil {
		log.Printf("Error %s when preparing SQL statement", err)
		return err
	}
	defer stmt.Close()
}

func main() {

	db, err := sql.Open("mysql", "cbuser:cbpass@tcp(127.0.0.1:3306)/cookbook")
	defer db.Close()

	p := profile{
		name:  "askdba",
		birth: 1975,
		color: "null",
		foods: "null",
		cats:  0,
	}
	err = insert(db, p)
	if err != nil {
		log.Printf("Insert product failed with error %s", err)
		return
	}

	affectedRows, err := res.RowsAffected()
	if err != nil {
		log.Fatal(err)
	}

	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("The statement affected %d rows\n", affectedRows)
}
