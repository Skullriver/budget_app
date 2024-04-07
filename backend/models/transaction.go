package models

import "time"

type Transaction interface {
	Serialize() map[string]interface{}
	GetType() string
	GetDate() time.Time
}

func (i IncomeResponse) Serialize() map[string]interface{} {
	return map[string]interface{}{
		"type":           i.GetType(),
		"id":             i.ID,
		"userID":         i.UserID,
		"amount":         i.Amount,
		"categoryID":     i.CategoryID,
		"categoryName":   i.CategoryName,
		"categoryIcon":   i.CategoryIcon,
		"categoryColor":  i.CategoryColor,
		"description":    i.Description,
		"date":           i.Date,
		"walletID":       i.WalletID,
		"walletCurrency": i.WalletCurrency,
		"createdAt":      i.CreatedAt,
	}
}

func (i IncomeResponse) GetType() string {
	return "Income"
}
func (i IncomeResponse) GetDate() time.Time {
	return i.Date
}

func (i ExpenseResponse) Serialize() map[string]interface{} {
	return map[string]interface{}{
		"type":           i.GetType(),
		"id":             i.ID,
		"userID":         i.UserID,
		"amount":         i.Amount,
		"categoryID":     i.CategoryID,
		"categoryName":   i.CategoryName,
		"categoryIcon":   i.CategoryIcon,
		"categoryColor":  i.CategoryColor,
		"description":    i.Description,
		"date":           i.Date,
		"walletID":       i.WalletID,
		"walletCurrency": i.WalletCurrency,
		"createdAt":      i.CreatedAt,
	}
}

func (i ExpenseResponse) GetType() string {
	return "Expense"
}
func (i ExpenseResponse) GetDate() time.Time {
	return i.Date
}

func (i TransferResponse) Serialize() map[string]interface{} {
	return map[string]interface{}{
		"type":                i.GetType(),
		"id":                  i.ID,
		"userID":              i.UserID,
		"amount":              i.Amount,
		"description":         i.Description,
		"date":                i.Date,
		"sourceWalletID":      i.SourceWalletID,
		"destinationWalletID": i.DestinationWalletID,
		"walletCurrency":      i.WalletCurrency,
		"createdAt":           i.CreatedAt,
	}
}

func (i TransferResponse) GetType() string {
	return "Transfer"
}
func (i TransferResponse) GetDate() time.Time {
	return i.Date
}

type Income struct {
	ID          int64     `json:"id" db:"id"`
	UserID      int64     `json:"userID" db:"userid"`
	Amount      int       `json:"amount" db:"amount"`
	CategoryID  int64     `json:"categoryID" db:"categoryid"`
	Description string    `json:"description" db:"description"`
	Date        time.Time `json:"date" db:"date"`
	WalletID    int64     `json:"walletID" db:"walletid"`
	CreatedAt   time.Time `json:"createdAt" db:"createdat"`
}

type IncomeResponse struct {
	ID             int64     `json:"id" db:"id"`
	UserID         int64     `json:"userID" db:"userid"`
	Amount         int       `json:"amount" db:"amount"`
	CategoryID     int64     `json:"categoryID" db:"categoryid"`
	CategoryName   string    `json:"categoryName" db:"name"`
	CategoryIcon   string    `json:"categoryIcon" db:"iconcode"`
	CategoryColor  string    `json:"categoryColor" db:"colorcode"`
	Description    string    `json:"description" db:"description"`
	Date           time.Time `json:"date" db:"date"`
	WalletID       int64     `json:"walletID" db:"walletid"`
	WalletCurrency string    `json:"walletCurrency" db:"currency"`
	CreatedAt      time.Time `json:"createdAt" db:"createdat"`
}

type Expense struct {
	ID          int64     `json:"id" db:"id"`
	UserID      int64     `json:"userID" db:"userid"`
	Amount      int       `json:"amount" db:"amount"`
	CategoryID  int64     `json:"categoryID" db:"categoryid"`
	Description string    `json:"description" db:"description"`
	Date        time.Time `json:"date" db:"date"`
	WalletID    int64     `json:"walletID" db:"walletid"`
	CreatedAt   time.Time `json:"createdAt" db:"createdat"`
}

type ExpenseResponse struct {
	ID             int64     `json:"id" db:"id"`
	UserID         int64     `json:"userID" db:"userid"`
	Amount         int       `json:"amount" db:"amount"`
	CategoryID     int64     `json:"categoryID" db:"categoryid"`
	CategoryName   string    `json:"categoryName" db:"name"`
	CategoryIcon   string    `json:"categoryIcon" db:"iconcode"`
	CategoryColor  string    `json:"categoryColor" db:"colorcode"`
	Description    string    `json:"description" db:"description"`
	Date           time.Time `json:"date" db:"date"`
	WalletID       int64     `json:"walletID" db:"walletid"`
	WalletCurrency string    `json:"walletCurrency" db:"currency"`
	CreatedAt      time.Time `json:"createdAt" db:"createdat"`
}

type Transfer struct {
	ID                  int64     `json:"id" db:"id"`
	UserID              int64     `json:"userID" db:"userid"`
	Amount              int       `json:"amount" db:"amount"`
	Description         string    `json:"description" db:"description"`
	Date                time.Time `json:"date" db:"date"`
	SourceWalletID      int64     `json:"sourceWalletID" db:"sourcewalletid"`
	DestinationWalletID int64     `json:"destinationWalletID" db:"destinationwalletid"`
	CreatedAt           time.Time `json:"createdAt" db:"createdat"`
}

type TransferResponse struct {
	ID                  int64     `json:"id" db:"id"`
	UserID              int64     `json:"userID" db:"userid"`
	Amount              int       `json:"amount" db:"amount"`
	Description         string    `json:"description" db:"description"`
	Date                time.Time `json:"date" db:"date"`
	SourceWalletID      int64     `json:"sourceWalletID" db:"sourcewalletid"`
	DestinationWalletID int64     `json:"destinationWalletID" db:"destinationwalletid"`
	WalletCurrency      string    `json:"walletCurrency" db:"currency"`
	CreatedAt           time.Time `json:"createdAt" db:"createdat"`
}

type CategoryStatistic struct {
	Category  string `json:"category"`
	Amount    int    `json:"amount"`
	ColorCode string `json:"colorCode"`
}

type WalletStatistics struct {
	WalletID      int64 `json:"id"`
	TotalIncome   int64 `json:"totalIncome"`
	TotalExpenses int64 `json:"totalExpenses"`
}
