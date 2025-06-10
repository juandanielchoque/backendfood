import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import { validateData, restaurantSchema } from "@/lib/validation"
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
    const city = searchParams.get("city")
    const cuisine = searchParams.get("cuisine")
    const priceRange = searchParams.get("price_range")
    const page = Number.parseInt(searchParams.get("page") || "1")
    const limit = Number.parseInt(searchParams.get("limit") || "10")
    const sortBy = searchParams.get("sort_by") || "rating"
    const sortOrder = searchParams.get("sort_order") || "desc"
    const offset = (page - 1) * limit

    let query = "SELECT * FROM restaurants WHERE is_active = TRUE"
    const params: any[] = []

    // Filtros
    if (city) {
      query += " AND city LIKE ?"
      params.push(`%${city}%`)
    }

    if (cuisine) {
      query += " AND cuisine_type = ?"
      params.push(cuisine)
    }

    if (priceRange) {
      query += " AND price_range = ?"
      params.push(priceRange)
    }

    // Ordenamiento
    const validSortFields = ["name", "rating", "review_count", "created_at"]
    const sortField = validSortFields.includes(sortBy) ? sortBy : "rating"
    const order = sortOrder.toLowerCase() === "asc" ? "ASC" : "DESC"

    query += ` ORDER BY ${sortField} ${order} LIMIT ${limit} OFFSET ${offset}`

    // Contar total para paginación
    let countQuery = "SELECT COUNT(*) as total FROM restaurants WHERE is_active = TRUE"
    const countParams: any[] = []

    if (city) {
      countQuery += " AND city LIKE ?"
      countParams.push(`%${city}%`)
    }

    if (cuisine) {
      countQuery += " AND cuisine_type = ?"
      countParams.push(cuisine)
    }

    if (priceRange) {
      countQuery += " AND price_range = ?"
      countParams.push(priceRange)
    }

    const [restaurants, countResult] = await Promise.all([
      executeQuery(query, params),
      executeQuery(countQuery, countParams),
    ])

    const total = (countResult as any[])[0].total
    const totalPages = Math.ceil(total / limit)

    return NextResponse.json(
      {
        success: true,
        data: restaurants,
        pagination: {
          page,
          limit,
          total,
          totalPages,
        },
      },
      { headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error obteniendo restaurantes:", error)
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
    const validation = validateData(restaurantSchema, body)
    if (!validation.success) {
      return NextResponse.json(
        { success: false, error: "Datos inválidos", details: validation.errors },
        { status: 400, headers: corsHeaders() },
      )
    }

    const { name, description, address, city, phone, email, website, cuisine_type, price_range } = validation.data

    // Crear slug único
    const slug = name
      .toLowerCase()
      .replace(/[^a-z0-9\s]/g, "")
      .replace(/\s+/g, "-")
      .substring(0, 120)

    const result = await executeQuery(
      `INSERT INTO restaurants (name, slug, description, address, city, phone, email, website, cuisine_type, price_range) 
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, slug, description, address, city, phone, email, website, cuisine_type, price_range],
    )

    return NextResponse.json(
      {
        success: true,
        message: "Restaurante creado exitosamente",
        data: { restaurant_id: (result as any).insertId },
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

    console.error("Error creating restaurant:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
