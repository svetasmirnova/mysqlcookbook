// connect.go : Connect package 
package connect

import (
  "fmt"
  "database/sql"
  _"github.com/go-sql-driver/mysql"
)

func Mysql() {
  db, err := sql.Open("mysql","cbuser:cbpass@tcp(127.0.0.1:3306)/cookbook")
  if err != nil {
    panic(err.Error())
  }
  defer db.Close()
  fmt.Println("Called mysql() to connect cookbook database")
}
 
