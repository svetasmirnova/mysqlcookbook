package main

import (
    "database/sql"
    "fmt"
    "log"

    _ "github.com/go-sql-driver/mysql"
)

type Profile struct {
    id         int
    name       string
    cats       string
}

func main() {

    db, err := sql.Open("mysql", "cbuser:Cbuser2021!@tcp(127.0.0.1:3306)/cookbook")
    defer db.Close()

    if err != nil {
        log.Fatal(err)
    }

    res, err := db.Query("SELECT id,name,cats FROM profile where cats is not null")

    defer res.Close()

    if err != nil {
        log.Fatal(err)
    }

    for res.Next() {

        var profile Profile
        err := res.Scan(&profile.id, &profile.name, &profile.cats)

        if err != nil {
            log.Fatal(err)
        }

        fmt.Printf("%v\n", profile)
    }
}
