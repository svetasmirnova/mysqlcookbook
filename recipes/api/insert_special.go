package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

func main() {

	db, err := sql.Open("mysql", "cbuser:Cbuser2021!@tcp(127.0.0.1:3306)/cookbook")
	defer db.Close()

	sql := "INSERT INTO profile (name,birth,color,foods,cats) VALUES ('De\\'Mont','1973-01-12', null,'eggroll',4)"
	res, err := db.Exec(sql)
	if err != nil {
		panic(err.Error())
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
