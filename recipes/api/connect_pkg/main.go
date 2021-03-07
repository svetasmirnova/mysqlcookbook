// main.go : Main program to call custom Go package
package main

import (
  "fmt"
  "github.com/mysqlcookbook/connect_pkg"
)

func main() {
    connect.Mysql()
    fmt.Println("Connected to cookbook database")
}
