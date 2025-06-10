import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const type = searchParams.get("type") || "overview"

    const analytics: any = {}

    if (type === "overview" || type === "all") {
      // Estadísticas generales
      const [userCount] = (await executeQuery("SELECT COUNT(*) as count FROM users WHERE is_active = TRUE")) as any[]
      const [restaurantCount] = (await executeQuery(
        "SELECT COUNT(*) as count FROM restaurants WHERE is_active = TRUE",
      )) as any[]
      const [dishCount] = (await executeQuery("SELECT COUNT(*) as count FROM dishes WHERE is_active = TRUE")) as any[]
      const [reviewCount] = (await executeQuery("SELECT COUNT(*) as count FROM reviews")) as any[]
      const [postCount] = (await executeQuery("SELECT COUNT(*) as count FROM posts")) as any[]

      analytics.overview = {
        usuarios: userCount.count,
        restaurantes: restaurantCount.count,
        platos: dishCount.count,
        reseñas: reviewCount.count,
        posts: postCount.count,
      }
    }

    if (type === "popular" || type === "all") {
      // Restaurantes más populares
      const popularRestaurants = await executeQuery(`
        SELECT r.id, r.name, r.cuisine_type, r.rating, COUNT(rev.id) as review_count
        FROM restaurants r
        LEFT JOIN reviews rev ON r.id = rev.restaurant_id
        WHERE r.is_active = TRUE
        GROUP BY r.id, r.name, r.cuisine_type, r.rating
        ORDER BY review_count DESC, r.rating DESC
        LIMIT 10
      `)

      // Platos más populares
      const popularDishes = await executeQuery(`
        SELECT d.id, d.name, r.name as restaurant_name, COUNT(rev.id) as review_count, AVG(rev.rating) as avg_rating
        FROM dishes d
        JOIN restaurants r ON d.restaurant_id = r.id
        LEFT JOIN reviews rev ON d.id = rev.dish_id
        WHERE d.is_active = TRUE AND r.is_active = TRUE
        GROUP BY d.id, d.name, r.name
        ORDER BY review_count DESC, avg_rating DESC
        LIMIT 10
      `)

      analytics.popular = {
        restaurantes: popularRestaurants,
        platos: popularDishes,
      }
    }

    if (type === "trends" || type === "all") {
      // Tendencias por tipo de cocina
      const cuisineTrends = await executeQuery(`
        SELECT r.cuisine_type, COUNT(rev.id) as review_count, AVG(rev.rating) as avg_rating
        FROM restaurants r
        LEFT JOIN reviews rev ON r.id = rev.restaurant_id
        WHERE r.is_active = TRUE AND r.cuisine_type IS NOT NULL
        GROUP BY r.cuisine_type
        ORDER BY review_count DESC
        LIMIT 10
      `)

      analytics.trends = {
        tipos_cocina: cuisineTrends,
      }
    }

    return NextResponse.json({
      success: true,
      data: analytics,
    })
  } catch (error) {
    console.error("Error obteniendo analytics:", error)
    return NextResponse.json({ success: false, error: "Error interno del servidor" }, { status: 500 })
  }
}
