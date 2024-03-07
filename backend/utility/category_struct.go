package utility

type CreateCategoryRequest struct {
	Name  string `json:"name"`
	Icon  string `json:"icon"`
	Color string `json:"color"`
}
type CreateCategoryResponse struct {
	CategoryID int64 `json:"categoryID"`
}

type UpdateCategoryRequest struct {
	ID    int64  `json:"id"`
	Name  string `json:"name,omitempty"`
	Icon  string `json:"icon,omitempty"`
	Color string `json:"color,omitempty"`
}

type UpdateCategoryResponse struct {
	CategoryID int64 `json:"categoryID"`
}

type DeleteCategoryResponse struct {
	Status bool `json:"status"`
}

type GetCategoryResponse struct {
	ID     int64  `json:"id"`
	UserID int64  `json:"user_id"`
	Name   string `json:"name"`
	Icon   string `json:"icon"`
	Color  string `json:"color"`
}
