package utility

type CreateWalletRequest struct {
	Name           string `json:"name"`
	Currency       string `json:"currency"`
	InitialBalance int    `json:"initial_balance"`
	Icon           string `json:"icon"`
	Color          string `json:"color"`
}
type CreateWalletResponse struct {
	WalletID int64 `json:"walletID"`
}

type UpdateWalletRequest struct {
	ID             int64  `json:"id"`
	UserID         int64  `json:"userID,omitempty"`
	Name           string `json:"name,omitempty"`
	Currency       string `json:"currency,omitempty"`
	InitialBalance int    `json:"initialBalance,omitempty"`
	Balance        int    `json:"balance,omitempty"`
	Icon           string `json:"iconCode,omitempty"`
	Color          string `json:"colorCode,omitempty"`
}

type UpdateWalletResponse struct {
	WalletID int64 `json:"walletID"`
}

type DeleteWalletResponse struct {
	Status bool `json:"status"`
}
