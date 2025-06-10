import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import { validateData, reviewSchema } from "@/lib/validation"
import { requireAuth } from "@/lib/auth"

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
    const dishId = searchParams.get("dish_id")
    const restaurantId = searchParams.get("restaurant_id")
    const userId = searchParams.get("user_id")
    const page = Number.parseInt(searchParams.get("page") || "1")
    const limit = Number.parseInt(searchParams.get("limit") || "10")
    const offset = (page - 1) * limit

    let query = `
      SELECT 
        r.*,
        u.username,
        u.full_name,
        u.is_verified,
        d.name as dish_name,
        rest.name as restaurant_name
      FROM reviews r
      JOIN users u ON r.user_id = u.id
      LEFT JOIN dishes d ON r.dish_id = d.id
      JOIN restaurants rest ON r.restaurant_id = rest.id
      WHERE r.status = 'active'
    `
    const params: any[] = []

    if (dishId) {
      query += " AND r.dish_id = ?"
      params.push(Number.parseInt(dishId))
    }

    if (restaurantId) {
      query += " AND r.restaurant_id = ?"
      params.push(Number.parseInt(restaurantId))
    }

    if (userId) {
      query += " AND r.user_id = ?"
      params.push(Number.parseInt(userId))
    }

    query += ` ORDER BY r.created_at DESC LIMIT ${limit} OFFSET ${offset}`

    const reviews = await executeQuery(query, params)

    return NextResponse.json(
      {
        success: true,
        data: reviews,
      },
      { headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error obteniendo reseñas:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    // Verificar autenticación
    const user = requireAuth(request)

    const body = await request.json()

    // Validar datos
    const validation = validateData(reviewSchema, body)
    if (!validation.success) {
      return NextResponse.json(
        { success: false, error: "Datos inválidos", details: validation.errors },
        { status: 400, headers: corsHeaders() },
      )
    }

    const {
      dish_id,
      restaurant_id,
      overall_rating,
      title,
      content,
      pros,
      cons,
      taste_rating,
      presentation_rating,
      value_rating,
      service_rating,
      visit_type,
      would_recommend,
      would_return,
    } = validation.data

    const result = await executeQuery(
      `INSERT INTO reviews (
        user_id, dish_id, restaurant_id, overall_rating, title, content, pros, cons,
        taste_rating, presentation_rating, value_rating, service_rating,
        visit_type, would_recommend, would_return
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        user.userId,
        dish_id,
        restaurant_id,
        overall_rating,
        title,
        content,
        pros,
        cons,
        taste_rating,
        presentation_rating,
        value_rating,
        service_rating,
        visit_type,
        would_recommend,
        would_return,
      ],
    )

    // Actualizar contador de reseñas del usuario
    await executeQuery("UPDATE users SET reviews_count = reviews_count + 1 WHERE id = ?", [user.userId])

    // Actualizar contador de reseñas del restaurante
    await executeQuery("UPDATE restaurants SET review_count = review_count + 1 WHERE id = ?", [restaurant_id])

    // Actualizar contador de reseñas del plato si existe
    if (dish_id) {
      await executeQuery("UPDATE dishes SET review_count = review_count + 1 WHERE id = ?", [dish_id])
    }

    return NextResponse.json(
      {
        success: true,
        message: "Reseña creada exitosamente",
        data: { review_id: (result as any).insertId },
      },
      { status: 201, headers: corsHeaders() },
    )
  } catch (error: any) {
    if (error.message === "Authentication required") {
      return NextResponse.json(
        { success: false, error: "Token de autenticación requerido" },
        { status: 401, headers: corsHeaders() },
      )
    }

    console.error("Error creating review:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
