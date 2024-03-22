package models

import "time"

type Wallet struct {
	ID             int64     `json:"id" db:"id"`
	UserID         int64     `json:"userID" db:"userid"`
	Name           string    `json:"name" db:"name"`
	Currency       string    `json:"currency" db:"currency"`
	InitialBalance int       `json:"initialBalance" db:"initialbalance"`
	Balance        int       `json:"balance" db:"balance"`
	Icon           string    `json:"iconCode" db:"icon"`
	Color          string    `json:"colorCode" db:"color"`
	CreatedAt      time.Time `json:"createdAt" db:"createdat"`
}
