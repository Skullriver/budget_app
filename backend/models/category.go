package models

type Category struct {
	ID     int64  `json:"id" db:"id"`
	UserID int64  `json:"user_id" db:"userid"`
	Name   string `json:"name" db:"name"`
	Icon   string `json:"icon" db:"iconcode"`
	Color  string `json:"color" db:"colorcode"`
}
