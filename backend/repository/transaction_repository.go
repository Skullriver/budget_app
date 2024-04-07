package repository

import (
	"budget_app/models"
	"context"
	"database/sql"
	"errors"
	"fmt"
)

var ErrNoTransaction = errors.New("no Transaction found")

type TransactionRepository interface {
	CreateIncome(ctx context.Context, income *models.Income) error
	CreateExpense(ctx context.Context, expense *models.Expense) error
	CreateTransfer(ctx context.Context, transfer *models.Transfer) error
	GetIncomeByID(ctx context.Context, id int64) (*models.Income, error)
	GetIncomesByUserID(ctx context.Context, id int64) ([]*models.IncomeResponse, error)
	GetExpensesByUserID(ctx context.Context, id int64) ([]*models.ExpenseResponse, error)
	GetTransfersByUserID(ctx context.Context, id int64) ([]*models.TransferResponse, error)
	UpdateIncome(ctx context.Context, Income *models.Income) error
	DeleteIncome(ctx context.Context, id int64) error
	GetStatisticsBy(ctx context.Context, id int64, month string, typeParam string, walletIDInt int64) ([]*models.CategoryStatistic, error)
	GetStatistics(ctx context.Context, id int64, month string, walletIDInt int64) (*models.WalletStatistics, error)
}

type postgresTransactionRepository struct {
	db *sql.DB
}

func NewPostgresTransactionRepository(db *sql.DB) TransactionRepository {
	return &postgresTransactionRepository{db: db}
}

func (r *postgresTransactionRepository) CreateIncome(ctx context.Context, income *models.Income) error {
	query := "INSERT INTO incomes (userid, amount, description, date, walletid, categoryid) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, income.UserID, income.Amount, income.Description, income.Date, income.WalletID, income.CategoryID)
	err := row.Scan(&income.ID)
	if err != nil {
		return fmt.Errorf("failed to create income: %v", err)
	}
	return nil
}

func (r *postgresTransactionRepository) CreateExpense(ctx context.Context, expense *models.Expense) error {
	query := "INSERT INTO expenses (userid, amount, description, date, walletid, categoryid) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, expense.UserID, expense.Amount, expense.Description, expense.Date, expense.WalletID, expense.CategoryID)
	err := row.Scan(&expense.ID)
	if err != nil {
		return fmt.Errorf("failed to create expense: %v", err)
	}
	return nil
}

func (r *postgresTransactionRepository) CreateTransfer(ctx context.Context, transfer *models.Transfer) error {
	query := "INSERT INTO transfers (userid, amount, description, date, sourcewalletid, destinationwalletid) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, transfer.UserID, transfer.Amount, transfer.Description, transfer.Date, transfer.SourceWalletID, transfer.DestinationWalletID)
	err := row.Scan(&transfer.ID)
	if err != nil {
		return fmt.Errorf("failed to create transfer: %v", err)
	}
	return nil
}

func (r *postgresTransactionRepository) GetIncomeByID(ctx context.Context, id int64) (*models.Income, error) {
	query := "SELECT * FROM incomes WHERE id = $1"
	row := r.db.QueryRowContext(ctx, query, id)
	income := &models.Income{}
	err := row.Scan(&income.ID, &income.UserID, &income.Amount, &income.Description, &income.Date, &income.WalletID, &income.CreatedAt, &income.CategoryID)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, fmt.Errorf("no income found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get income: %v", err)
	}
	return income, nil
}

func (r *postgresTransactionRepository) GetIncomesByUserID(ctx context.Context, id int64) ([]*models.IncomeResponse, error) {
	query := `
SELECT e.id, e.userid, e.amount, e.description, e.date, e.walletid, e.createdat, e.categoryid, 
       c.name AS categoryName, c.iconcode AS categoryIcon, c.colorcode AS categoryColor, w.currency as walletCurrency
FROM incomes e
JOIN categories c ON e.categoryid = c.id
JOIN wallets w ON e.walletid = w.id
WHERE e.userid = $1
ORDER BY e.createdat
`
	rows, err := r.db.QueryContext(ctx, query, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var incomes []*models.IncomeResponse
	for rows.Next() {
		var c models.IncomeResponse
		err := rows.Scan(&c.ID, &c.UserID, &c.Amount, &c.Description, &c.Date, &c.WalletID, &c.CreatedAt, &c.CategoryID, &c.CategoryName, &c.CategoryIcon, &c.CategoryColor, &c.WalletCurrency)
		if err != nil {
			return nil, err
		}
		incomes = append(incomes, &c)
	}

	return incomes, nil
}

func (r *postgresTransactionRepository) GetExpensesByUserID(ctx context.Context, id int64) ([]*models.ExpenseResponse, error) {

	query := `
SELECT e.id, e.userid, e.amount, e.description, e.date, e.walletid, e.createdat, e.categoryid, 
       c.name AS categoryName, c.iconcode AS categoryIcon, c.colorcode AS categoryColor, w.currency as walletCurrency
FROM expenses e
JOIN categories c ON e.categoryid = c.id
JOIN wallets w ON e.walletid = w.id
WHERE e.userid = $1
ORDER BY e.createdat
`
	rows, err := r.db.QueryContext(ctx, query, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var expenses []*models.ExpenseResponse
	for rows.Next() {
		var c models.ExpenseResponse
		err := rows.Scan(&c.ID, &c.UserID, &c.Amount, &c.Description, &c.Date, &c.WalletID, &c.CreatedAt, &c.CategoryID, &c.CategoryName, &c.CategoryIcon, &c.CategoryColor, &c.WalletCurrency)
		if err != nil {
			return nil, err
		}
		expenses = append(expenses, &c)
	}

	return expenses, nil
}

func (r *postgresTransactionRepository) GetTransfersByUserID(ctx context.Context, id int64) ([]*models.TransferResponse, error) {
	query := `
SELECT t.id, t.userid, t.amount, t.description, t.date, t.sourcewalletid, t.destinationwalletid, t.createdat, w.currency AS walletCurrency
FROM transfers t
JOIN wallets w ON t.sourcewalletid = w.id
WHERE t.userid = $1
ORDER BY t.createdat
`
	rows, err := r.db.QueryContext(ctx, query, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var transfers []*models.TransferResponse
	for rows.Next() {
		var c models.TransferResponse
		err := rows.Scan(&c.ID, &c.UserID, &c.Amount, &c.Description, &c.Date, &c.SourceWalletID, &c.DestinationWalletID, &c.CreatedAt, &c.WalletCurrency)
		if err != nil {
			return nil, err
		}
		transfers = append(transfers, &c)
	}

	return transfers, nil
}

func (r *postgresTransactionRepository) UpdateIncome(ctx context.Context, income *models.Income) error {
	query := "UPDATE incomes SET amount = $1, description = $2, date = $3, walletid = $4, categoryid = $5 WHERE id = $6"
	_, err := r.db.ExecContext(ctx, query, income.Amount, income.Description, income.Date, income.WalletID, income.CategoryID, income.ID)
	if err != nil {
		return fmt.Errorf("failed to update income: %v", err)
	}
	return nil
}

func (r *postgresTransactionRepository) DeleteIncome(ctx context.Context, id int64) error {
	query := "DELETE FROM incomes WHERE id = $1"
	_, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete income: %v", err)
	}
	return nil
}

func (r *postgresTransactionRepository) GetStatisticsBy(ctx context.Context, id int64, month string, typeParam string, walletIDInt int64) ([]*models.CategoryStatistic, error) {

	var query string

	if typeParam == "Income" {
		query = `
        SELECT i.categoryid, SUM(i.amount) as amount, c.colorCode, c.name
        FROM incomes i
        JOIN categories c ON i.categoryid = c.id
        WHERE i.userid = $1 AND i.walletid = $2 AND TO_CHAR(i.date, 'YYYY-MM') = $3
        GROUP BY i.categoryid, c.colorCode, c.name
        `
	} else if typeParam == "Expenses" {
		query = `
        SELECT e.categoryid, SUM(e.amount) as amount, c.colorCode, c.name
        FROM expenses e
        JOIN categories c ON e.categoryid = c.id
        WHERE e.userid = $1 AND e.walletid = $2 AND TO_CHAR(e.date, 'YYYY-MM') = $3
        GROUP BY e.categoryid, c.colorCode, c.name
        `
	}
	rows, err := r.db.QueryContext(ctx, query, id, walletIDInt, month)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var statistics []*models.CategoryStatistic
	for rows.Next() {
		var stat models.CategoryStatistic
		var categoryId int64
		err := rows.Scan(&categoryId, &stat.Amount, &stat.ColorCode, &stat.Category)
		if err != nil {
			return nil, err
		}
		statistics = append(statistics, &stat)
	}

	return statistics, nil
}

func (r *postgresTransactionRepository) GetStatistics(ctx context.Context, userID int64, month string, walletID int64) (*models.WalletStatistics, error) {
	var totalIncome, totalExpenses int64

	// Query for total income
	incomeQuery := `
        SELECT COALESCE(SUM(amount), 0) 
        FROM incomes 
        WHERE userid = $1 AND walletid = $2 AND TO_CHAR(date, 'YYYY-MM') = $3
    `
	err := r.db.QueryRowContext(ctx, incomeQuery, userID, walletID, month).Scan(&totalIncome)
	if err != nil {
		fmt.Println("Error querying total income:", err)
		return nil, err
	}

	// Query for total expenses
	expenseQuery := `
        SELECT COALESCE(SUM(amount), 0) 
        FROM expenses 
        WHERE userid = $1 AND walletid = $2 AND TO_CHAR(date, 'YYYY-MM') = $3
    `
	err = r.db.QueryRowContext(ctx, expenseQuery, userID, walletID, month).Scan(&totalExpenses)
	if err != nil {
		fmt.Println("Error querying total expenses:", err)
		return nil, err
	}

	// Aggregate the results into WalletStatistics
	walletStats := &models.WalletStatistics{
		WalletID:      walletID,
		TotalIncome:   totalIncome,
		TotalExpenses: totalExpenses,
	}

	return walletStats, nil
}
