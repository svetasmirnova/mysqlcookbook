
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
}

func main() {

    db, err := sql.Open("mysql", "cbuser:Cbuser2021!@tcp(127.0.0.1:3306)/cookbook")
    defer db.Close()

    if err != nil {
        log.Fatal(err)
    }

    sql := "UPDATE profile SET cats = cats+1 WHERE name = 'Sybil'"
    res, err := db.Exec(sql)

    if err != nil {
        panic(err.Error())
    }

    affectedRows, err := res.RowsAffected()

    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("The statement affected %d rows\n", affectedRows)
}
