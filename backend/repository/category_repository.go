package repository

import (
	"budget_app/models"
	"context"
	"database/sql"
	"errors"
	"fmt"
)

var ErrNoCategory = errors.New("no category found")

type CategoryRepository interface {
	CreateCategory(ctx context.Context, category *models.Category) error
	GetCategoryByID(ctx context.Context, id int64) (*models.Category, error)
	GetCategoriesByUserID(ctx context.Context, id int64) ([]*models.Category, error)
	UpdateCategory(ctx context.Context, category *models.Category) error
	DeleteCategory(ctx context.Context, id int64) error
}

type postgresCategoryRepository struct {
	db *sql.DB
}

func NewPostgresCategoryRepository(db *sql.DB) CategoryRepository {
	return &postgresCategoryRepository{db: db}
}

func (r *postgresCategoryRepository) CreateCategory(ctx context.Context, category *models.Category) error {
	query := "INSERT INTO categories (userid, name, iconcode, colorcode) VALUES ($1, $2, $3, $4) RETURNING id"
	row := r.db.QueryRowContext(ctx, query, category.UserID, category.Name, category.Icon, category.Color)
	err := row.Scan(&category.ID)
	if err != nil {
		return fmt.Errorf("failed to create category: %v", err)
	}
	return nil
}

func (r *postgresCategoryRepository) GetCategoryByID(ctx context.Context, id int64) (*models.Category, error) {
	query := "SELECT id, userid, name, iconcode, colorcode FROM categories WHERE id = $1"
	row := r.db.QueryRowContext(ctx, query, id)
	category := &models.Category{}
	err := row.Scan(&category.ID, &category.UserID, &category.Name, &category.Icon, &category.Color)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, fmt.Errorf("no category found")
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get category: %v", err)
	}
	return category, nil
}

func (r *postgresCategoryRepository) GetCategoriesByUserID(ctx context.Context, id int64) ([]*models.Category, error) {
	query := "SELECT id, userid, name, iconcode, colorcode FROM categories WHERE userid = $1 ORDER BY id"
	rows, err := r.db.QueryContext(ctx, query, id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var categories []*models.Category
	for rows.Next() {
		var c models.Category
		err := rows.Scan(&c.ID, &c.UserID, &c.Name, &c.Icon, &c.Color)
		if err != nil {
			return nil, err
		}
		categories = append(categories, &c)
	}

	return categories, nil
}

func (r *postgresCategoryRepository) UpdateCategory(ctx context.Context, category *models.Category) error {
	query := "UPDATE categories SET name = $1, iconcode = $2, colorcode = $3 WHERE id = $4"
	_, err := r.db.ExecContext(ctx, query, category.Name, category.Icon, category.Color)
	if err != nil {
		return fmt.Errorf("failed to update category: %v", err)
	}
	return nil
}

func (r *postgresCategoryRepository) DeleteCategory(ctx context.Context, id int64) error {
	query := "DELETE FROM categories WHERE id = $1"
	_, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete category: %v", err)
	}
	return nil
}
