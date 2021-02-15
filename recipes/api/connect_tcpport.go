package main

import (
    "database/sql"
    "fmt"
    "log"

    _ "github.com/go-sql-driver/mysql"
)

func main() {
   db, err := sql.Open("mysql","root:Alkin2020!@tcp(localhost:3306)/cookbook?charset=utf8")

    if err != nil {
        log.Fatal(err)
    }


    defer db.Close()

    if err != nil {
        log.Fatal(err)
    }

    fmt.Println("Connected!")
}
