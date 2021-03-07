// mycnf.go : Reads ~/.my.cnf file for DSN construct
package main

import (
	"fmt"

	"github.com/mysqlcookbook/db"
)

func main() {

	fmt.Println("Calling db.MyCnf()") 
        var dsn string

        dsn, err := db.MyCnf("client")
        if err != nil {
	fmt.Printf("error: %v\n", err)
        } else {
	fmt.Printf("DSN is: %s\n", dsn)
        }
       
}
