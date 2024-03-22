package handlers

import (
	"budget_app/repository"
	"budget_app/services"
	"budget_app/utility"
	"context"
	"database/sql"
	"encoding/json"
	"github.com/gorilla/mux"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

type WalletHandler struct {
	api  *services.WalletService
	auth *services.AuthService
}

func NewWalletHandler(db *sql.DB, secretToken string) *WalletHandler {
	authService := &services.AuthService{
		UserRepository: repository.NewPostgresUserRepository(db),
		TokenSecret:    secretToken,
	}
	api := &services.WalletService{
		UserRepository:   repository.NewPostgresUserRepository(db),
		WalletRepository: repository.NewPostgresWalletRepository(db),
	}
	return &WalletHandler{api: api, auth: authService}
}

func (h *WalletHandler) CreateWalletHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Create a new context with a timeout of 5 seconds
	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	// Get token from Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		// Return an error response if no Authorization header is found
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse token from Authorization header
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	userID, err := h.auth.VerifyToken(ctx, tokenString)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	var req utility.CreateWalletRequest
	err = json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Call the
	walletID, err := h.api.CreateWallet(ctx, req, userID)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// Print the response body
	resp := utility.CreateWalletResponse{WalletID: walletID}
	err = json.NewEncoder(w).Encode(resp)
	if err != nil {
		return
	}

}

func (h *WalletHandler) UpdateWalletHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "PUT")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Create a new context with a timeout of 5 seconds
	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	// Get token from Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		// Return an error response if no Authorization header is found
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse token from Authorization header
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	userID, err := h.auth.VerifyToken(ctx, tokenString)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	var req utility.UpdateWalletRequest
	err = json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Call the
	walletID, err := h.api.UpdateWallet(ctx, req, userID)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// Print the response body
	resp := utility.UpdateWalletResponse{WalletID: walletID}
	err = json.NewEncoder(w).Encode(resp)
	if err != nil {
		return
	}
}

func (h *WalletHandler) DeleteWalletHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "DELETE")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Create a new context with a timeout of 5 seconds
	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	// Get token from Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		// Return an error response if no Authorization header is found
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse token from Authorization header
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	userID, err := h.auth.VerifyToken(ctx, tokenString)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Parse the Wallet ID from the URL path
	vars := mux.Vars(r)
	walletID, err := strconv.Atoi(vars["id"])
	if err != nil {
		http.Error(w, "Invalid wallet ID", http.StatusBadRequest)
		return
	}

	// Call the service
	status, err := h.api.DeleteWallet(ctx, walletID, userID)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// Print the response body
	resp := utility.DeleteWalletResponse{Status: status}
	err = json.NewEncoder(w).Encode(resp)
	if err != nil {
		return
	}
}

func (h *WalletHandler) GetWalletHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Create a new context with a timeout of 5 seconds
	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	// Get token from Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		// Return an error response if no Authorization header is found
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse token from Authorization header
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	userID, err := h.auth.VerifyToken(ctx, tokenString)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Parse the Wallet ID from the URL path
	vars := mux.Vars(r)
	walletID, err := strconv.Atoi(vars["id"])
	if err != nil {
		http.Error(w, "Invalid Wallet ID", http.StatusBadRequest)
		return
	}

	// Call the
	wallet, err := h.api.GetWalletByID(ctx, walletID, userID)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// Print the response body
	err = json.NewEncoder(w).Encode(wallet)
	if err != nil {
		return
	}
}

func (h *WalletHandler) GetAllWalletsHandler(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	// Create a new context with a timeout of 5 seconds
	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	// Get token from Authorization header
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		// Return an error response if no Authorization header is found
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// Parse token from Authorization header
	tokenString := strings.Replace(authHeader, "Bearer ", "", 1)
	userID, err := h.auth.VerifyToken(ctx, tokenString)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Call the
	wallets, err := h.api.GetWalletsByUserID(ctx, userID)

	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	// Print the response body
	err = json.NewEncoder(w).Encode(wallets)
	if err != nil {
		return
	}
}
