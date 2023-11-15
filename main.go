package main

import (
	"context"
	"database/sql"
	"database/sql/driver"
	"fmt"
	"github.com/godror/godror"
	"log"
	"time"
)

type User struct {
	ID       int
	Name     string
	Email    string
	Gender   string
	Password string
}

func main() {
	db, err := connectToDB()
	handleError(err)
	getTotalCountUsers(db)
	getRefCursor(db)
}

// func getTotalCountUsers(db *sql.DB, email string) (User, error) {
func getTotalCountUsers(db *sql.DB) {
	var total int
	row := db.QueryRow("select PKG_USERS.TOTALUSERS() from USERS")
	err := row.Scan(&total)
	handleError(err)
	fmt.Println("total = ", total)
}

func getRefCursor(db *sql.DB) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*10)
	defer cancel()

	var (
		user  = User{}
		query = "begin :1 := pkg_users.get_user_data_by_email(:2); end;"
		rc    driver.Rows
		mail  = "shundey1@yandex.ru"
	)

	_, err := db.Exec(query, sql.Out{Dest: &rc}, mail)
	handleError(err)
	defer rc.Close()

	sub, err := godror.WrapRows(ctx, db, rc)
	handleError(err)
	defer sub.Close()

	for sub.Next() {
		err = sub.Scan(&user.ID, &user.Name, &user.Email, &user.Gender, &user.Password)
		handleError(err)
	}
	fmt.Println("user = ", user)
}

func connectToDB() (*sql.DB, error) {
	db, err := sql.Open("godror",
		`user="diyorbek" password="Tatu65019$" connectString="localhost:1522/XE"
					   libDir="C:\\Oracle\\instantclient_21_12\\bin"`)
	if err != nil {
		return nil, err
	}

	return db, nil
}

func handleError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}
