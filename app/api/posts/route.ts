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
    const postType = searchParams.get("post_type")
    const page = Number.parseInt(searchParams.get("page") || "1")
    const limit = Number.parseInt(searchParams.get("limit") || "10")
    const offset = (page - 1) * limit

    let query = `
      SELECT 
        p.*,
        u.username,
        u.full_name,
        d.name as dish_name,
        r.name as restaurant_name
      FROM posts p
      JOIN users u ON p.user_id = u.id
      LEFT JOIN dishes d ON p.dish_id = d.id
      LEFT JOIN restaurants r ON p.restaurant_id = r.id
      WHERE 1=1
    `
    const params: any[] = []

    if (postType) {
      query += " AND p.post_type = ?"
      params.push(postType)
    }

    query += " ORDER BY p.created_at DESC LIMIT ? OFFSET ?"
    params.push(limit, offset)

    const posts = await executeQuery(query, params)

    return NextResponse.json(
      {
        success: true,
        data: posts,
      },
      { headers: corsHeaders() },
    )
  } catch (error) {
    console.error("Error obteniendo posts:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
