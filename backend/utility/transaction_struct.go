package utility

type CreateIncomeRequest struct {
	Amount     int    `json:"amount"`
	CategoryID int    `json:"categoryID"`
	Date       string `json:"date"`
	WalletID   int    `json:"walletID"`
	Notes      string `json:"notes,omitempty"`
}

type CreateExpenseRequest struct {
	Amount     int    `json:"amount"`
	CategoryID int    `json:"categoryID"`
	Date       string `json:"date"`
	WalletID   int    `json:"walletID"`
	Notes      string `json:"notes,omitempty"`
}

type CreateTransferRequest struct {
	Amount              int    `json:"amount"`
	Date                string `json:"date"`
	SourceWalletID      int    `json:"sourceWalletID"`
	DestinationWalletID int    `json:"destinationWalletID"`
	Notes               string `json:"notes,omitempty"`
}

type CreateIncomeResponse struct {
	IncomeID int64 `json:"incomeID"`
}
type CreateExpenseResponse struct {
	ExpenseID int64 `json:"expenseID"`
}
type CreateTransferResponse struct {
	TransferID int64 `json:"transferID"`
}

type UpdateIncomeRequest struct {
	ID         int64  `json:"id"`
	UserID     int64  `json:"userID,omitempty"`
	Amount     int    `json:"amount,omitempty"`
	CategoryID int    `json:"categoryID,omitempty"`
	Date       string `json:"date,omitempty"`
	WalletID   int    `json:"walletID,omitempty"`
	Notes      string `json:"description,omitempty"`
	CreatedAt  string `json:"createdAt,omitempty"`
}

type UpdateIncomeResponse struct {
	IncomeID int64 `json:"incomeID"`
}

type DeleteIncomeResponse struct {
	Status bool `json:"status"`
}
