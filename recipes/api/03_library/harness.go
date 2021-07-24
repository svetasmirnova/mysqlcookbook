package main

import (
  "fmt"
  "github.com/svetasmirnova/mysqlcookbook/recipes/lib"
)

func main() {
  db, err := cookbook.Connect()
  defer db.Close()

  if err != nil {
    fmt.Println("Cannot connect to server")
    fmt.Printf("Error message: %s\n", err.Error())
  } else {
    fmt.Println("Connected")
  }
}
