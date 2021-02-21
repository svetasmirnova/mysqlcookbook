
package main

import (
    "database/sql"
    "fmt"
    "log"

    _ "github.com/go-sql-driver/mysql"
)

type Artist struct {
    id         int
    name       string
}

func main() {

    db, err := sql.Open("mysql", "cbuser:Cbuser2021!@tcp(127.0.0.1:3306)/cookbook")
    defer db.Close()

    if err != nil {
        log.Fatal(err)
    }

    sql := "INSERT INTO actors(id,name) values (11,'Dwayne Johnson')"

    res, err := db.Exec(sql)
    if err != nil {
        panic(err.Error())
    }

    res, err := db.Commit()

    if err != nil {
        panic(err.Error())
    }

    affectedRows, err := res.RowsAffected()

    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("The statement affected %d rows\n", affectedRows)
    res, err := db.Query("SELECT * FROM actors")

    defer res.Close()

    if err != nil {
        log.Fatal(err)
    }

    for res.Next() {

        var artist Artist
        err := res.Scan(&artist.id, &artist.actor)

        if err != nil {
            log.Fatal(err)
        }

        fmt.Printf("%v\n", artist)
    }
}
