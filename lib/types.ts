// Tipos para FoodScrap Backend

export interface User {
  id: number
  username: string
  email: string
  full_name: string
  bio?: string
  profile_image?: string
  location?: string
  phone?: string
  followers_count: number
  following_count: number
  posts_count: number
  reviews_count: number
  is_verified: boolean
  is_premium: boolean
  last_login?: string
  created_at: string
  updated_at: string
  is_active: boolean
}

export interface Restaurant {
  id: number
  name: string
  slug: string
  description?: string
  address: string
  city: string
  country: string
  phone?: string
  email?: string
  website?: string
  cuisine_type?: string
  price_range: "$" | "$$" | "$$$" | "$$$$"
  rating: number
  review_count: number
  image_url?: string
  latitude?: number
  longitude?: number
  opening_hours?: Record<string, string>
  features?: string[]
  accepts_reservations: boolean
  delivery_available: boolean
  takeout_available: boolean
  created_at: string
  updated_at: string
  is_active: boolean
}

export interface Dish {
  id: number
  restaurant_id: number
  name: string
  slug: string
  description?: string
  category?: string
  base_price?: number
  currency: string
  image_url?: string
  ingredients?: string
  allergens?: string[]
  preparation_time?: number
  spice_level: "none" | "mild" | "medium" | "hot" | "very_hot"
  is_vegetarian: boolean
  is_vegan: boolean
  is_gluten_free: boolean
  is_signature_dish: boolean
  calories?: number
  rating: number
  review_count: number
  created_at: string
  updated_at: string
  is_active: boolean
  restaurant?: Restaurant
}

export interface Review {
  id: number
  user_id: number
  dish_id?: number
  restaurant_id: number
  overall_rating: number
  title?: string
  content?: string
  pros?: string
  cons?: string
  images?: string[]
  taste_rating?: number
  presentation_rating?: number
  value_rating?: number
  service_rating?: number
  visit_date?: string
  visit_type: "dine_in" | "takeout" | "delivery"
  would_recommend: boolean
  would_return: boolean
  helpful_votes: number
  status: "active" | "flagged" | "hidden" | "deleted"
  created_at: string
  updated_at: string
  user?: User
  dish?: Dish
  restaurant?: Restaurant
}

export interface Post {
  id: number
  user_id: number
  dish_id?: number
  restaurant_id?: number
  title?: string
  content: string
  images?: string[]
  tags?: string[]
  post_type: "review" | "comparison" | "recommendation" | "question" | "tip" | "general"
  visibility: "public" | "followers" | "private"
  likes_count: number
  comments_count: number
  shares_count: number
  views_count: number
  is_featured: boolean
  status: "draft" | "published" | "archived" | "deleted"
  created_at: string
  updated_at: string
  user?: User
  dish?: Dish
  restaurant?: Restaurant
}

export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  message?: string
  error?: string
  pagination?: {
    page: number
    limit: number
    total: number
    totalPages: number
  }
}

export interface PaginationParams {
  page?: number
  limit?: number
  sortBy?: string
  sortOrder?: "asc" | "desc"
}

export interface AuthUser {
  id: number
  username: string
  email: string
  full_name: string
  is_verified: boolean
  is_premium: boolean
}

export interface LoginRequest {
  email: string
  password: string
}

export interface RegisterRequest {
  username: string
  email: string
  password: string
  full_name: string
  bio?: string
  location?: string
  phone?: string
}
