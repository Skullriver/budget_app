package repository

import (
	"budget_app/models"
	"context"
	"database/sql"
	"errors"
	"fmt"
)

var ErrNoUser = errors.New("no user found")

type UserRepository interface {
	CreateUser(ctx context.Context, user *models.User) error
	GetUserByID(ctx context.Context, id int64) (*models.User, error)
	GetUserByEmail(ctx context.Context, email string) (*models.User, error)
	UpdateUser(ctx context.Context, user *models.User) error
	DeleteUser(ctx context.Context, id int64) error
	CopyPredefinedCategoriesToUser(ctx context.Context, id int64)
}

type postgresUserRepository struct {
	db *sql.DB
}

func NewPostgresUserRepository(db *sql.DB) UserRepository {
	return &postgresUserRepository{db: db}
}

func (r *postgresUserRepository) CreateUser(ctx context.Context, user *models.User) error {
	query := "INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, user.Username, user.Email, user.Password)
	err := row.Scan(&user.ID)
	if err != nil {
		return fmt.Errorf("failed to create user: %v", err)
	}
	return nil
}

func (r *postgresUserRepository) GetUserByID(ctx context.Context, id int64) (*models.User, error) {
	query := "SELECT id, username, email, password FROM users WHERE id = $1"
	row := r.db.QueryRowContext(ctx, query, id)
	user := &models.User{}
	err := row.Scan(&user.ID, &user.Username, &user.Email, &user.Password)
	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("no user found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %v", err)
	}
	return user, nil
}

func (r *postgresUserRepository) GetUserByEmail(ctx context.Context, email string) (*models.User, error) {
	query := "SELECT id, username, email, password FROM users WHERE email = $1"
	row := r.db.QueryRowContext(ctx, query, email)
	user := &models.User{}
	err := row.Scan(&user.ID, &user.Username, &user.Email, &user.Password)
	if err == sql.ErrNoRows {
		return nil, ErrNoUser
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %v", err)
	}
	return user, nil
}

func (r *postgresUserRepository) UpdateUser(ctx context.Context, user *models.User) error {
	query := "UPDATE users SET username = $1, email = $2, password = $3 WHERE id = $4"
	_, err := r.db.ExecContext(ctx, query, user.Username, user.Email, user.Password, user.ID)
	if err != nil {
		return fmt.Errorf("failed to update user: %v", err)
	}
	return nil
}

func (r *postgresUserRepository) DeleteUser(ctx context.Context, id int64) error {
	query := "DELETE FROM users WHERE id = $1"
	_, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete user: %v", err)
	}
	return nil
}

func (r *postgresUserRepository) CopyPredefinedCategoriesToUser(ctx context.Context, userID int64) {

	predefinedCategories := []models.Category{
		{Name: "Groceries", Icon: "cart", Color: "#4CAF50"},
		{Name: "Utilities", Icon: "bolt.fill", Color: "#2196F3"},
		{Name: "Transport", Icon: "car.fill", Color: "#FF9800"},
		{Name: "Restaurants", Icon: "fork.knife", Color: "#F44336"},
		{Name: "Entertainment", Icon: "film", Color: "#9C27B0"},
		{Name: "Health & Wellness", Icon: "cross.case.fill", Color: "#E91E63"},
		{Name: "Education", Icon: "books.vertical.fill", Color: "#1976D2"},
		{Name: "Savings & Investments", Icon: "banknote.fill", Color: "#FFEB3B"},
		{Name: "Housing", Icon: "house.fill", Color: "#795548"},
		{Name: "Salary", Icon: "creditcard.fill", Color: "#CDDC39"},
	}

	// Prepare the insert statement for better performance
	stmt, err := r.db.PrepareContext(ctx, `INSERT INTO categories (name, iconcode, colorcode, userid) VALUES ($1, $2, $3, $4)`)
	if err != nil {
		return
	}
	defer stmt.Close()

	// Insert these predefined categories for the specified user
	for _, category := range predefinedCategories {
		_, err := stmt.ExecContext(ctx, category.Name, category.Icon, category.Color, userID)
		if err != nil {
			// Handle the error, consider transaction rollback if necessary
			return
		}
	}

	return

}
