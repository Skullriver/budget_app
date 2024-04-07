package services

import (
	"budget_app/models"
	"budget_app/repository"
	"budget_app/utility"
	"context"
	"fmt"
	"time"
)

type TransactionService struct {
	UserRepository        repository.UserRepository
	TransactionRepository repository.TransactionRepository
	WalletRepository      repository.WalletRepository
}

func (s *TransactionService) CreateIncome(ctx context.Context, req utility.CreateIncomeRequest, userID int64) (int64, error) {

	layout := "2006-01-02" // Go's layout string for "yyyy-MM-dd"

	parsedDate, err := time.Parse(layout, req.Date)
	if err != nil {
		fmt.Println("Error parsing date:", err)
		return -1, err
	}

	// Map the request to your internal models.Category struct
	newIncome := models.Income{
		UserID:      userID,
		Amount:      req.Amount,
		Date:        parsedDate,
		CategoryID:  int64(req.CategoryID),
		Description: req.Notes,
		WalletID:    int64(req.WalletID),
	}

	// Call the repository function to create the new category in the database
	err = s.TransactionRepository.CreateIncome(ctx, &newIncome)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Update the wallet balance
	wallet, err := s.WalletRepository.GetWalletByID(ctx, newIncome.WalletID)
	if err != nil {
		fmt.Println("Error getting wallet:", err)
		return -1, err
	}

	updatedBalance := wallet.Balance + req.Amount
	updateReq := models.Wallet{
		ID:       wallet.ID,
		Name:     wallet.Name,
		Currency: wallet.Currency,
		Balance:  updatedBalance,
		Icon:     wallet.Icon,
		Color:    wallet.Color,
		UserID:   wallet.UserID, // Or simply use userID if appropriate
	}
	err = s.WalletRepository.UpdateWallet(ctx, &updateReq)
	if err != nil {
		fmt.Println("Error updating wallet balance:", err)
		return -1, err
	}

	// Return the new category ID and nil error if creation was successful
	return newIncome.ID, nil

}

func (s *TransactionService) CreateExpense(ctx context.Context, req utility.CreateExpenseRequest, userID int64) (int64, error) {

	layout := "2006-01-02" // Go's layout string for "yyyy-MM-dd"

	parsedDate, err := time.Parse(layout, req.Date)
	if err != nil {
		fmt.Println("Error parsing date:", err)
		return -1, err
	}

	// Map the request to your internal models.Category struct
	newExpense := models.Expense{
		UserID:      userID,
		Amount:      req.Amount,
		Date:        parsedDate,
		CategoryID:  int64(req.CategoryID),
		Description: req.Notes,
		WalletID:    int64(req.WalletID),
	}

	// Call the repository function to create the new category in the database
	err = s.TransactionRepository.CreateExpense(ctx, &newExpense)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Update the wallet balance
	wallet, err := s.WalletRepository.GetWalletByID(ctx, newExpense.WalletID)
	if err != nil {
		fmt.Println("Error getting wallet:", err)
		return -1, err
	}

	updatedBalance := wallet.Balance - req.Amount
	updateReq := models.Wallet{
		ID:       wallet.ID,
		Name:     wallet.Name,
		Currency: wallet.Currency,
		Balance:  updatedBalance,
		Icon:     wallet.Icon,
		Color:    wallet.Color,
		UserID:   wallet.UserID, // Or simply use userID if appropriate
	}
	err = s.WalletRepository.UpdateWallet(ctx, &updateReq)
	if err != nil {
		fmt.Println("Error updating wallet balance:", err)
		return -1, err
	}

	// Return the new category ID and nil error if creation was successful
	return newExpense.ID, nil

}

func (s *TransactionService) CreateTransfer(ctx context.Context, req utility.CreateTransferRequest, userID int64) (int64, error) {

	layout := "2006-01-02" // Go's layout string for "yyyy-MM-dd"

	parsedDate, err := time.Parse(layout, req.Date)
	if err != nil {
		fmt.Println("Error parsing date:", err)
		return -1, err
	}

	// Map the request to your internal models.Category struct
	newTransfer := models.Transfer{
		UserID:              userID,
		Amount:              req.Amount,
		Date:                parsedDate,
		Description:         req.Notes,
		SourceWalletID:      int64(req.SourceWalletID),
		DestinationWalletID: int64(req.DestinationWalletID),
	}

	// Call the repository function to create the new category in the database
	err = s.TransactionRepository.CreateTransfer(ctx, &newTransfer)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Update the source wallet balance
	sourceWallet, err := s.WalletRepository.GetWalletByID(ctx, newTransfer.SourceWalletID)
	if err != nil {
		fmt.Println("Error getting wallet:", err)
		return -1, err
	}

	updatedBalance := sourceWallet.Balance - req.Amount
	updateReq := models.Wallet{
		ID:       sourceWallet.ID,
		Name:     sourceWallet.Name,
		Currency: sourceWallet.Currency,
		Balance:  updatedBalance,
		Icon:     sourceWallet.Icon,
		Color:    sourceWallet.Color,
		UserID:   sourceWallet.UserID, // Or simply use userID if appropriate
	}
	err = s.WalletRepository.UpdateWallet(ctx, &updateReq)
	if err != nil {
		fmt.Println("Error updating source wallet balance:", err)
		return -1, err
	}

	// Update the source wallet balance
	destWallet, err := s.WalletRepository.GetWalletByID(ctx, newTransfer.DestinationWalletID)
	if err != nil {
		fmt.Println("Error getting wallet:", err)
		return -1, err
	}

	updatedBalance = destWallet.Balance + req.Amount
	updateReq = models.Wallet{
		ID:       destWallet.ID,
		Name:     destWallet.Name,
		Currency: destWallet.Currency,
		Balance:  updatedBalance,
		Icon:     destWallet.Icon,
		Color:    destWallet.Color,
		UserID:   destWallet.UserID, // Or simply use userID if appropriate
	}
	err = s.WalletRepository.UpdateWallet(ctx, &updateReq)
	if err != nil {
		fmt.Println("Error updating destination wallet balance:", err)
		return -1, err
	}

	// Return the new category ID and nil error if creation was successful
	return newTransfer.ID, nil

}

func (s *TransactionService) UpdateIncome(ctx context.Context, req utility.UpdateIncomeRequest, userID int64) (int64, error) {

	layout := "2006-01-02" // Go's layout string for "yyyy-MM-dd"

	parsedDate, err := time.Parse(layout, req.Date)
	if err != nil {
		fmt.Println("Error parsing date:", err)
		return -1, err
	}

	// Map the request to your internal models.Category struct
	income := models.Income{
		ID:          req.ID,
		UserID:      userID,
		Amount:      req.Amount,
		Date:        parsedDate,
		CategoryID:  int64(req.CategoryID),
		Description: req.Notes,
		WalletID:    int64(req.WalletID),
	}

	// Call the repository function to create the new income in the database
	err = s.TransactionRepository.UpdateIncome(ctx, &income)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Return the new income ID and nil error if creation was successful
	return income.ID, nil

}

func (s *TransactionService) DeleteIncome(ctx context.Context, incomeID int, userID int64) (bool, error) {

	income, err := s.TransactionRepository.GetIncomeByID(ctx, int64(incomeID))
	if err != nil {
		return false, err
	}
	if income.UserID != userID {
		return false, err
	}

	err = s.TransactionRepository.DeleteIncome(ctx, int64(incomeID))
	if err != nil {
		return false, err
	}

	return true, nil
}

func (s *TransactionService) GetIncomeByID(ctx context.Context, incomeID int, userID int64) (*models.Income, error) {

	income, err := s.TransactionRepository.GetIncomeByID(ctx, int64(incomeID))
	if err != nil {
		return nil, err
	}
	if income.UserID != userID {
		return nil, err
	}

	return income, nil
}

func (s *TransactionService) GetIncomesByUserID(ctx context.Context, userID int64) ([]*models.IncomeResponse, error) {

	incomes, err := s.TransactionRepository.GetIncomesByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return incomes, nil
}
func (s *TransactionService) GetExpensesByUserID(ctx context.Context, userID int64) ([]*models.ExpenseResponse, error) {

	expenses, err := s.TransactionRepository.GetExpensesByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return expenses, nil
}
func (s *TransactionService) GetTransfersByUserID(ctx context.Context, userID int64) ([]*models.TransferResponse, error) {

	transfers, err := s.TransactionRepository.GetTransfersByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return transfers, nil
}

func (s *TransactionService) GetStatisticsBy(ctx context.Context, userID int64, month string, typeParam string, walletIDInt int64) ([]*models.CategoryStatistic, error) {

	statistics, err := s.TransactionRepository.GetStatisticsBy(ctx, userID, month, typeParam, walletIDInt)
	if err != nil {
		return nil, err
	}

	return statistics, nil
}

func (s *TransactionService) GetStatistics(ctx context.Context, userID int64, month string, walletIDInt int64) (*models.WalletStatistics, error) {

	statistics, err := s.TransactionRepository.GetStatistics(ctx, userID, month, walletIDInt)
	if err != nil {
		return nil, err
	}

	return statistics, nil
}
