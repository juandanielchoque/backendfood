import { z } from "zod"

// Esquemas de validación
export const userRegistrationSchema = z.object({
  username: z
    .string()
    .min(3, "Username must be at least 3 characters")
    .max(50, "Username must be less than 50 characters")
    .regex(/^[a-zA-Z0-9_]+$/, "Username can only contain letters, numbers, and underscores"),
  email: z.string().email("Invalid email format"),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/, "Password must contain at least one lowercase, uppercase, and number"),
  full_name: z.string().min(2, "Full name must be at least 2 characters").max(100, "Full name too long"),
  bio: z.string().max(500, "Bio must be less than 500 characters").optional(),
  location: z.string().max(100, "Location must be less than 100 characters").optional(),
  phone: z
    .string()
    .regex(/^\+?[\d\s\-()]+$/, "Invalid phone format")
    .optional(),
})

export const userLoginSchema = z.object({
  email: z.string().email("Invalid email format"),
  password: z.string().min(1, "Password is required"),
})

export const restaurantSchema = z.object({
  name: z.string().min(2, "Restaurant name must be at least 2 characters").max(100, "Name too long"),
  description: z.string().max(1000, "Description too long").optional(),
  address: z.string().min(5, "Address must be at least 5 characters").max(255, "Address too long"),
  city: z.string().min(2, "City must be at least 2 characters").max(100, "City name too long"),
  phone: z
    .string()
    .regex(/^\+?[\d\s\-()]+$/, "Invalid phone format")
    .optional(),
  email: z.string().email("Invalid email format").optional(),
  website: z.string().url("Invalid website URL").optional(),
  cuisine_type: z.string().max(50, "Cuisine type too long").optional(),
  price_range: z.enum(["$", "$$", "$$$", "$$$$"]).default("$$"),
})

export const dishSchema = z.object({
  restaurant_id: z.number().positive("Restaurant ID must be positive"),
  name: z.string().min(2, "Dish name must be at least 2 characters").max(100, "Name too long"),
  description: z.string().max(1000, "Description too long").optional(),
  category: z.string().max(50, "Category too long").optional(),
  base_price: z.number().positive("Price must be positive").optional(),
  ingredients: z.string().max(1000, "Ingredients list too long").optional(),
  allergens: z.array(z.string()).optional(),
  preparation_time: z.number().positive("Preparation time must be positive").optional(),
  spice_level: z.enum(["none", "mild", "medium", "hot", "very_hot"]).default("none"),
  is_vegetarian: z.boolean().default(false),
  is_vegan: z.boolean().default(false),
  is_gluten_free: z.boolean().default(false),
  calories: z.number().positive("Calories must be positive").optional(),
})

export const reviewSchema = z.object({
  dish_id: z.number().positive("Dish ID must be positive").optional(),
  restaurant_id: z.number().positive("Restaurant ID must be positive"),
  overall_rating: z.number().min(1, "Rating must be at least 1").max(5, "Rating cannot exceed 5"),
  title: z.string().max(200, "Title too long").optional(),
  content: z.string().max(2000, "Review content too long").optional(),
  pros: z.string().max(500, "Pros too long").optional(),
  cons: z.string().max(500, "Cons too long").optional(),
  taste_rating: z.number().min(1).max(5).optional(),
  presentation_rating: z.number().min(1).max(5).optional(),
  value_rating: z.number().min(1).max(5).optional(),
  service_rating: z.number().min(1).max(5).optional(),
  visit_type: z.enum(["dine_in", "takeout", "delivery"]).default("dine_in"),
  would_recommend: z.boolean().default(true),
  would_return: z.boolean().default(true),
})

export const postSchema = z.object({
  dish_id: z.number().positive().optional(),
  restaurant_id: z.number().positive().optional(),
  title: z.string().max(200, "Title too long").optional(),
  content: z.string().min(1, "Content is required").max(2000, "Content too long"),
  tags: z.array(z.string().max(50)).max(10, "Too many tags").optional(),
  post_type: z.enum(["review", "comparison", "recommendation", "question", "tip", "general"]).default("general"),
  visibility: z.enum(["public", "followers", "private"]).default("public"),
})

// Función helper para validar datos
export function validateData<T>(
  schema: z.ZodSchema<T>,
  data: unknown,
): { success: true; data: T } | { success: false; errors: string[] } {
  try {
    const validatedData = schema.parse(data)
    return { success: true, data: validatedData }
  } catch (error) {
    if (error instanceof z.ZodError) {
      const errors = error.errors.map((err) => `${err.path.join(".")}: ${err.message}`)
      return { success: false, errors }
    }
    return { success: false, errors: ["Validation failed"] }
  }
}
