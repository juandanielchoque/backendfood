import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import { validateData, dishSchema } from "@/lib/validation"
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
    const restaurantId = searchParams.get("restaurant_id")
    const category = searchParams.get("category")
    const search = searchParams.get("search")
    const vegetarian = searchParams.get("vegetarian")
    const vegan = searchParams.get("vegan")
    const glutenFree = searchParams.get("gluten_free")
    const page = Number.parseInt(searchParams.get("page") || "1")
    const limit = Number.parseInt(searchParams.get("limit") || "10")
    const sortBy = searchParams.get("sort_by") || "rating"
    const sortOrder = searchParams.get("sort_order") || "desc"
    const offset = (page - 1) * limit

    let query = `
      SELECT d.*, r.name as restaurant_name, r.city as restaurant_city, r.cuisine_type
      FROM dishes d
      JOIN restaurants r ON d.restaurant_id = r.id
      WHERE d.is_active = TRUE AND r.is_active = TRUE
    `
    const params: any[] = []

    // Filtros
    if (restaurantId) {
      query += " AND d.restaurant_id = ?"
      params.push(Number.parseInt(restaurantId))
    }

    if (category) {
      query += " AND d.category = ?"
      params.push(category)
    }

    if (search) {
      query += " AND (d.name LIKE ? OR d.description LIKE ?)"
      params.push(`%${search}%`, `%${search}%`)
    }

    if (vegetarian === "true") {
      query += " AND d.is_vegetarian = TRUE"
    }

    if (vegan === "true") {
      query += " AND d.is_vegan = TRUE"
    }

    if (glutenFree === "true") {
      query += " AND d.is_gluten_free = TRUE"
    }

    // Ordenamiento
    const validSortFields = ["name", "base_price", "rating", "review_count", "created_at"]
    const sortField = validSortFields.includes(sortBy) ? sortBy : "rating"
    const order = sortOrder.toLowerCase() === "asc" ? "ASC" : "DESC"

    query += ` ORDER BY d.${sortField} ${order} LIMIT ${limit} OFFSET ${offset}`

    const dishes = await executeQuery(query, params)

    return NextResponse.json(
      {
        success: true,
        data: dishes,
      },
      { headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error obteniendo platos:", error)
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
    const validation = validateData(dishSchema, body)
    if (!validation.success) {
      return NextResponse.json(
        { success: false, error: "Datos inválidos", details: validation.errors },
        { status: 400, headers: corsHeaders() },
      )
    }

    const {
      restaurant_id,
      name,
      description,
      category,
      base_price,
      ingredients,
      allergens,
      preparation_time,
      spice_level,
      is_vegetarian,
      is_vegan,
      is_gluten_free,
      calories,
    } = validation.data

    // Crear slug único
    const slug = name
      .toLowerCase()
      .replace(/[^a-z0-9\s]/g, "")
      .replace(/\s+/g, "-")
      .substring(0, 120)

    const result = await executeQuery(
      `INSERT INTO dishes (
        restaurant_id, name, slug, description, category, base_price, 
        ingredients, allergens, preparation_time, spice_level,
        is_vegetarian, is_vegan, is_gluten_free, calories
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        restaurant_id,
        name,
        slug,
        description,
        category,
        base_price,
        ingredients,
        JSON.stringify(allergens || []),
        preparation_time,
        spice_level,
        is_vegetarian,
        is_vegan,
        is_gluten_free,
        calories,
      ],
    )

    return NextResponse.json(
      {
        success: true,
        message: "Plato creado exitosamente",
        data: { dish_id: (result as any).insertId },
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

    console.error("Error creating dish:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
