package repository

import (
	"budget_app/models"
	"context"
	"database/sql"
	"errors"
	"fmt"
)

var ErrNoWallet = errors.New("no wallet found")

type WalletRepository interface {
	CreateWallet(ctx context.Context, wallet *models.Wallet) error
	GetWalletByID(ctx context.Context, id int64) (*models.Wallet, error)
	GetWalletsByUserID(ctx context.Context, id int64) ([]*models.Wallet, error)
	UpdateWallet(ctx context.Context, wallet *models.Wallet) error
	DeleteWallet(ctx context.Context, id int64) error
}

type postgresWalletRepository struct {
	db *sql.DB
}

func NewPostgresWalletRepository(db *sql.DB) WalletRepository {
	return &postgresWalletRepository{db: db}
}

func (r *postgresWalletRepository) CreateWallet(ctx context.Context, wallet *models.Wallet) error {
	query := "INSERT INTO wallets (userid, name, currency, initialbalance, balance, icon, color) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, wallet.UserID, wallet.Name, wallet.Currency, wallet.InitialBalance, wallet.InitialBalance, wallet.Icon, wallet.Color)
	err := row.Scan(&wallet.ID)
	if err != nil {
		return fmt.Errorf("failed to create wallet: %v", err)
	}
	return nil
}

func (r *postgresWalletRepository) GetWalletByID(ctx context.Context, id int64) (*models.Wallet, error) {
	query := "SELECT id, userid, name, currency, balance, icon, color FROM wallets WHERE id = $1"
	row := r.db.QueryRowContext(ctx, query, id)
	wallet := &models.Wallet{}
	err := row.Scan(&wallet.ID, &wallet.UserID, &wallet.Name, &wallet.Currency, &wallet.Balance, &wallet.Icon, &wallet.Color)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, fmt.Errorf("no wallet found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get wallet: %v", err)
	}
	return wallet, nil
}

func (r *postgresWalletRepository) GetWalletsByUserID(ctx context.Context, id int64) ([]*models.Wallet, error) {
	query := "SELECT id, userid, name, currency, initialbalance, balance, icon, color, createdat FROM wallets WHERE userid = $1 ORDER BY createdat"
	rows, err := r.db.QueryContext(ctx, query, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var wallets []*models.Wallet
	for rows.Next() {
		var c models.Wallet
		err := rows.Scan(&c.ID, &c.UserID, &c.Name, &c.Currency, &c.InitialBalance, &c.Balance, &c.Icon, &c.Color, &c.CreatedAt)
		if err != nil {
			return nil, err
		}
		wallets = append(wallets, &c)
	}

	return wallets, nil
}

func (r *postgresWalletRepository) UpdateWallet(ctx context.Context, wallet *models.Wallet) error {
	query := "UPDATE wallets SET name = $1, currency = $2, balance = $3, icon = $4, color = $5 WHERE id = $6"
	_, err := r.db.ExecContext(ctx, query, wallet.Name, wallet.Currency, wallet.Balance, wallet.Icon, wallet.Color, wallet.ID)
	if err != nil {
		return fmt.Errorf("failed to update wallet: %v", err)
	}
	return nil
}

func (r *postgresWalletRepository) DeleteWallet(ctx context.Context, id int64) error {
	query := "DELETE FROM wallets WHERE id = $1"
	_, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete wallet: %v", err)
	}
	return nil
}
