// null-in-result.go : Selecting NULL values in Golang
package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/go-sql-driver/mysql"
)

type Profile struct {
	name     string
	birthday sql.NullString
    foods    sql.NullString
}

func main() {

	db, err := sql.Open("mysql", "cbuser:cbpass@tcp(127.0.0.1:3306)/cookbook")
	defer db.Close()

	if err != nil {
		log.Fatal(err)
	}

	sql := "SELECT name, birth, foods FROM profile"
	res, err := db.Query(sql)
	defer res.Close()

	if err != nil {
		log.Fatal(err)
	}

	for res.Next() {
		var profile Profile
		err = res.Scan(&profile.name, &profile.birthday, &profile.foods)
		if err != nil {
			log.Fatal(err)
		}

        if (profile.birthday.Valid && profile.foods.Valid) {
		  fmt.Printf("name: %s, birth: %s, foods: %s\n", 
                      profile.name, profile.birthday.String, profile.foods.String)
        } else if profile.birthday.Valid {
          fmt.Printf("name: %s, birth: %s, foods: NULL\n",
                      profile.name, profile.birthday.String)
        } else if profile.foods.Valid {
          fmt.Printf("name: %s, birth: NULL, foods: %s\n",
                      profile.name, profile.foods.String)
        } else {
          fmt.Printf("name: %s, birth: NULL, foods: NULL\n",
                      profile.name)
        }
	}
}
