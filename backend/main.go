package main

import (
	"budget_app/handlers"
	"context"
	"database/sql"
	"fmt"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

func init() {
	loadTheEnv()
}

func loadTheEnv() {
	err := godotenv.Load(".env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		w.Header().Set("Content-Security-Policy", "default-src 'self'")
		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}

func setupRoutes(db *sql.DB) *mux.Router {

	r := mux.NewRouter()
	r.Use(corsMiddleware)

	authHandler := handlers.NewAuthHandler(db, "my-secret-token")
	categoryHandler := handlers.NewCategoryHandler(db, "my-secret-token")
	walletHandler := handlers.NewWalletHandler(db, "my-secret-token")

	r.HandleFunc("/user/register", authHandler.RegisterHandler).Methods("POST", "OPTIONS")
	r.HandleFunc("/user/login", authHandler.LoginHandler).Methods("POST", "OPTIONS")
	r.HandleFunc("/user/get", authHandler.GetUserHandler).Methods("GET", "OPTIONS")

	r.HandleFunc("/categories/create", categoryHandler.CreateCategoryHandler).Methods("POST", "OPTIONS")
	r.HandleFunc("/categories/update", categoryHandler.UpdateCategoryHandler).Methods("PUT", "OPTIONS")
	r.HandleFunc("/categories/delete/{id}", categoryHandler.DeleteCategoryHandler).Methods("DELETE", "OPTIONS")
	r.HandleFunc("/categories/get/{id}", categoryHandler.GetCategoryHandler).Methods("GET", "OPTIONS")
	r.HandleFunc("/categories/all", categoryHandler.GetAllCategoriesHandler).Methods("GET", "OPTIONS")

	r.HandleFunc("/wallets/create", walletHandler.CreateWalletHandler).Methods("POST", "OPTIONS")
	r.HandleFunc("/wallets/update", walletHandler.UpdateWalletHandler).Methods("PUT", "OPTIONS")
	r.HandleFunc("/wallets/delete/{id}", walletHandler.DeleteWalletHandler).Methods("DELETE", "OPTIONS")
	r.HandleFunc("/wallets/get/{id}", walletHandler.GetWalletHandler).Methods("GET", "OPTIONS")
	r.HandleFunc("/wallets/all", walletHandler.GetAllWalletsHandler).Methods("GET", "OPTIONS")
	return r
}

func main() {

	postgresHost := os.Getenv("POSTGRES_HOST")
	postgresUser := os.Getenv("DB_USER")
	postgresPass := os.Getenv("DB_PASS")
	postgresName := os.Getenv("DB_NAME")

	db, err := sql.Open("postgres", fmt.Sprintf("host=%s port=5433 user=%s password=%s dbname=%s sslmode=disable", postgresHost, postgresUser, postgresPass, postgresName))
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Connected to the database!")

	r := setupRoutes(db)

	timeString := os.Getenv("CONTEXT_TIME")
	timeValue, err := strconv.Atoi(timeString)

	if err != nil {
		// Handle error
		panic(err)
	}

	contextTime := time.Duration(timeValue) * time.Second

	_, cancel := context.WithTimeout(context.Background(), contextTime)
	defer cancel()

	fmt.Println("starting the server on port 8080...")

	log.Fatal(http.ListenAndServe(":8080", r))
}
