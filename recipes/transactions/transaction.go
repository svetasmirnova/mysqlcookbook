// transaction.go: simple transaction demonstration

// By default, this creates an InnoDB table.  If you specify a storage
// engine on the command line, that will be used instead.  Normally,
// this should be a transaction-safe engine that is supported by your
// server.  However, you can pass a nontransactional storage engine
// to verify that rollback doesn't work properly for such engines.

// The script uses a table named "money" and drops it if necessary.
// Change the name if you have a valuable table with that name. :-)
package main

import (
  "log"
  "database/sql"
  "github.com/svetasmirnova/mysqlcookbook/recipes/lib"
)

func initTable(db *sql.DB, tblEngine string) (bool, error) {
  var queries [4]string
  var err error = nil
  queries[0] = "DROP TABLE IF EXISTS money"
  queries[1] = "CREATE TABLE money (name CHAR(5), amt INT) ENGINE = " + tblEngine
  queries[2] = "INSERT INTO money (name, amt) VALUES('Eve', 10)"
  queries[3] = "INSERT INTO money (name, amt) VALUES('Ida', 0)"

  for _, query := range queries {
    _, err = db.Exec(query)
    if err != nil {
      return false, err
    }
  }

  return true, nil
}

func main() {
  db, err := cookbook.Connect()
  if err != nil {
    log.Fatal(err)
  }
  defer db.Close()

  res, err := initTable(db, "InnoDB")
  if !res {
    log.Fatal(err)
  }
}
