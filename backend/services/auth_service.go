package services

import (
	"budget_app/models"
	"budget_app/repository"
	"context"
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	UserRepository repository.UserRepository
	TokenSecret    string
}

func (s *AuthService) RegisterUser(ctx context.Context, email, password, username string) (string, error) {
	// Check if a user with the same email already exists
	user, err := s.UserRepository.GetUserByEmail(ctx, email)
	if err == nil {
		return "", errors.New("user already exists")
	}

	// If GetUserByEmail returned an error other than ErrNoUser, return the error
	if err != repository.ErrNoUser {
		return "", err
	}

	// Hash the password using bcrypt
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}

	// Create a new user with the given email, hashed password, and username
	user = &models.User{Email: email, Password: string(hashedPassword), Username: username}
	err = s.UserRepository.CreateUser(ctx, user)
	if err != nil {
		return "", err
	}

	s.UserRepository.CopyPredefinedCategoriesToUser(ctx, user.ID)

	// Generate JWT token with user ID as claim
	tokenString, err := s.generateToken(user.ID)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func (s *AuthService) LoginUser(ctx context.Context, email, password string) (string, error) {
	// Check if user with given email exists
	user, err := s.UserRepository.GetUserByEmail(ctx, email)
	if err != nil {
		return "", errors.New("invalid email or password")
	}

	// Check if the password is correct
	if !user.CheckPassword(password) {
		return "", errors.New("invalid email or password")
	}

	// Generate JWT token
	token, err := s.generateToken(user.ID)
	if err != nil {
		return "", err
	}

	return token, nil
}

func (s *AuthService) GetUserByToken(ctx context.Context, tokenString string) (*models.User, error) {

	// Parse the token
	token, err := s.parseToken(tokenString)
	if err != nil {
		return nil, err
	}

	// Extract the user ID from the token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return nil, errors.New("invalid token claims")
	}

	userID, ok := claims["userID"].(float64)
	if !ok {
		return nil, errors.New("invalid user ID in token")
	}

	// Verify that the user exists
	user, err := s.GetUserByID(ctx, int64(userID))
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, errors.New("invalid user ID in token")
	}

	return user, nil
}

func (s *AuthService) VerifyToken(ctx context.Context, tokenString string) (int64, error) {
	// Parse the token
	token, err := s.parseToken(tokenString)
	if err != nil {
		return 0, err
	}

	// Extract the user ID from the token
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return 0, errors.New("invalid token claims")
	}

	userID, ok := claims["userID"].(float64)
	if !ok {
		return 0, errors.New("invalid user ID in token")
	}

	// Verify that the user exists
	user, err := s.GetUserByID(ctx, int64(userID))
	if err != nil {
		return 0, err
	}
	if user == nil {
		return 0, errors.New("invalid user ID in token")
	}

	return user.ID, nil
}

func (s *AuthService) GetUserByID(ctx context.Context, userID int64) (*models.User, error) {
	// Retrieve the user from the database
	user, err := s.UserRepository.GetUserByID(ctx, userID)
	if err != nil {
		return nil, err
	}

	return user, nil
}

func (s *AuthService) UpdateUserPassword(ctx context.Context, userID int64, newPassword string) error {
	// TODO: implement updating user password in the database
	return errors.New("not implemented")
}

func (s *AuthService) generateToken(userID int64) (string, error) {
	// Create a new JWT token with a custom claim containing the user ID
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"userID": userID,
	})

	// Sign the token using the secret key
	tokenString, err := token.SignedString([]byte(s.TokenSecret))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func (s *AuthService) parseToken(tokenString string) (*jwt.Token, error) {
	// Parse the token
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		// Check the signing method
		if token.Method != jwt.SigningMethodHS256 {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		// Return the secret key
		return []byte(s.TokenSecret), nil
	})

	if err != nil {
		return nil, err
	}

	// Check if token is valid
	if !token.Valid {
		return nil, errors.New("invalid token")
	}

	return token, nil
}
