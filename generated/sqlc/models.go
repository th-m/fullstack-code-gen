// Code generated by sqlc. DO NOT EDIT.

package sqlc

import (
	"database/sql"
)

type User struct {
	ID   string         `json:"id"`
	Name sql.NullString `json:"name"`
}