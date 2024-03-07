package services

import (
	"budget_app/models"
	"budget_app/repository"
	"budget_app/utility"
	"context"
)

type CategoryService struct {
	UserRepository     repository.UserRepository
	CategoryRepository repository.CategoryRepository
}

func (s *CategoryService) CreateCategory(ctx context.Context, req utility.CreateCategoryRequest, userID int64) (int64, error) {

	// Map the request to your internal models.Category struct
	newCategory := models.Category{
		Name:   req.Name,
		Icon:   req.Icon,
		Color:  req.Color,
		UserID: userID,
	}

	// Call the repository function to create the new category in the database
	err := s.CategoryRepository.CreateCategory(ctx, &newCategory)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Return the new category ID and nil error if creation was successful
	return newCategory.ID, nil

}

func (s *CategoryService) UpdateCategory(ctx context.Context, req utility.UpdateCategoryRequest, userID int64) (int64, error) {

	// Map the request to your internal models.Category struct
	category := models.Category{
		Name:   req.Name,
		Icon:   req.Icon,
		Color:  req.Color,
		UserID: userID,
		ID:     req.ID,
	}

	// Call the repository function to create the new category in the database
	err := s.CategoryRepository.UpdateCategory(ctx, &category)
	if err != nil {
		// Handle any error that occurred during the category creation
		return -1, err
	}

	// Return the new category ID and nil error if creation was successful
	return category.ID, nil

}

func (s *CategoryService) DeleteCategory(ctx context.Context, categoryID int, userID int64) (bool, error) {

	category, err := s.CategoryRepository.GetCategoryByID(ctx, int64(categoryID))
	if err != nil {
		return false, err
	}
	if category.UserID != userID {
		return false, err
	}

	err = s.CategoryRepository.DeleteCategory(ctx, int64(categoryID))
	if err != nil {
		return false, err
	}

	return true, nil
}

func (s *CategoryService) GetCategoryByID(ctx context.Context, categoryID int, userID int64) (*models.Category, error) {

	category, err := s.CategoryRepository.GetCategoryByID(ctx, int64(categoryID))
	if err != nil {
		return nil, err
	}
	if category.UserID != userID {
		return nil, err
	}

	return category, nil
}

func (s *CategoryService) GetCategoriesByUserID(ctx context.Context, userID int64) ([]*models.Category, error) {

	categories, err := s.CategoryRepository.GetCategoriesByUserID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return categories, nil
}
