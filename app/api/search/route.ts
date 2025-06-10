import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"

// Función helper para agregar headers CORS
function corsHeaders() {
  return {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  }
}

export async function OPTIONS() {
  return new NextResponse(null, { status: 200, headers: corsHeaders() })
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const query = searchParams.get("q")
    const type = searchParams.get("type") || "all" // all, restaurants, dishes, users

    if (!query || query.trim().length < 2) {
      return NextResponse.json(
        {
          success: false,
          error: "La búsqueda debe tener al menos 2 caracteres",
        },
        { status: 400, headers: corsHeaders() },
      )
    }

    const searchTerm = `%${query.trim()}%`
    const results: any = {}

    if (type === "all" || type === "restaurants") {
      const restaurants = await executeQuery(
        `SELECT id, name, description, city, cuisine_type, rating, review_count, image_url
         FROM restaurants 
         WHERE (name LIKE ? OR description LIKE ? OR city LIKE ?) AND is_active = TRUE 
         ORDER BY rating DESC 
         LIMIT 5`,
        [searchTerm, searchTerm, searchTerm],
      )
      results.restaurants = restaurants
    }

    if (type === "all" || type === "dishes") {
      const dishes = await executeQuery(
        `SELECT d.id, d.name, d.description, d.base_price, d.rating, d.category,
                r.name as restaurant_name, r.city as restaurant_city
         FROM dishes d 
         JOIN restaurants r ON d.restaurant_id = r.id 
         WHERE (d.name LIKE ? OR d.description LIKE ? OR d.category LIKE ?) 
               AND d.is_active = TRUE AND r.is_active = TRUE
         ORDER BY d.rating DESC 
         LIMIT 5`,
        [searchTerm, searchTerm, searchTerm],
      )
      results.dishes = dishes
    }

    if (type === "all" || type === "users") {
      const users = await executeQuery(
        `SELECT id, username, full_name, bio, location, is_verified, followers_count
         FROM users 
         WHERE (username LIKE ? OR full_name LIKE ? OR bio LIKE ?) AND is_active = TRUE 
         ORDER BY followers_count DESC 
         LIMIT 5`,
        [searchTerm, searchTerm, searchTerm],
      )
      results.users = users
    }

    return NextResponse.json(
      {
        success: true,
        data: {
          query: query.trim(),
          results,
        },
      },
      { headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error en búsqueda:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
