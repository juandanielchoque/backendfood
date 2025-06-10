import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const dishName = searchParams.get("dish_name")
    const sortBy = searchParams.get("sort_by") || "price"

    if (!dishName) {
      return NextResponse.json({ success: false, error: "Nombre del plato es requerido" }, { status: 400 })
    }

    const query = `
      SELECT 
        d.id,
        d.name as dish_name,
        d.base_price as price,
        d.description,
        d.rating as dish_rating,
        r.id as restaurant_id,
        r.name as restaurant_name,
        r.city as restaurant_city,
        r.address as restaurant_address,
        r.price_range,
        r.rating as restaurant_rating
      FROM dishes d
      JOIN restaurants r ON d.restaurant_id = r.id
      WHERE d.name LIKE ? AND d.is_active = TRUE AND r.is_active = TRUE
      ORDER BY ${sortBy === "rating" ? "d.rating DESC" : "d.base_price ASC"}
    `

    const dishes = await executeQuery(query, [`%${dishName}%`])

    return NextResponse.json({
      success: true,
      data: {
        dish_name: dishName,
        comparison: dishes,
      },
    })
  } catch (error) {
    console.error("Error comparando platos:", error)
    return NextResponse.json({ success: false, error: "Error interno del servidor" }, { status: 500 })
  }
}
