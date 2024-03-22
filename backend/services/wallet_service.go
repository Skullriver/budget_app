package services

import (
	"budget_app/models"
	"budget_app/repository"
	"budget_app/utility"
	"context"
)

type WalletService struct {
	UserRepository   repository.UserRepository
	WalletRepository repository.WalletRepository
}

func (s *WalletService) CreateWallet(ctx context.Context, req utility.CreateWalletRequest, userID int64) (int64, error) {

	// Map the request to your internal models.Wallet struct
	newWallet := models.Wallet{
		Name:           req.Name,
		Currency:       req.Currency,
		InitialBalance: req.InitialBalance,
		Icon:           req.Icon,
		Color:          req.Color,
		UserID:         userID,
	}

	// Call the repository function to create the new wallet in the database
	err := s.WalletRepository.CreateWallet(ctx, &newWallet)
	if err != nil {
		// Handle any error that occurred during the Wallet creation
		return -1, err
	}

	// Return the new Wallet ID and nil error if creation was successful
	return newWallet.ID, nil

}

func (s *WalletService) UpdateWallet(ctx context.Context, req utility.UpdateWalletRequest, userID int64) (int64, error) {

	// Map the request to your internal models.Wallet struct
	wallet := models.Wallet{
		Name:     req.Name,
		Currency: req.Currency,
		Balance:  req.Balance,
		Icon:     req.Icon,
		Color:    req.Color,
		UserID:   userID,
		ID:       req.ID,
	}

	// Call the repository function to create the new Wallet in the database
	err := s.WalletRepository.UpdateWallet(ctx, &wallet)
	if err != nil {
		// Handle any error that occurred during the Wallet creation
		return -1, err
	}

	// Return the new Wallet ID and nil error if creation was successful
	return wallet.ID, nil

}

func (s *WalletService) DeleteWallet(ctx context.Context, walletID int, userID int64) (bool, error) {

	wallet, err := s.WalletRepository.GetWalletByID(ctx, int64(walletID))
	if err != nil {
		return false, err
	}
	if wallet.UserID != userID {
		return false, err
	}

	err = s.WalletRepository.DeleteWallet(ctx, int64(walletID))
	if err != nil {
		return false, err
	}

	return true, nil
}

func (s *WalletService) GetWalletByID(ctx context.Context, walletID int, userID int64) (*models.Wallet, error) {

	wallet, err := s.WalletRepository.GetWalletByID(ctx, int64(walletID))
	if err != nil {
		return nil, err
	}
	if wallet.UserID != userID {
		return nil, err
	}

	return wallet, nil
}

func (s *WalletService) GetWalletsByUserID(ctx context.Context, userID int64) ([]*models.Wallet, error) {

	wallets, err := s.WalletRepository.GetWalletsByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return wallets, nil
}
