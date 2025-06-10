import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import { hashPassword } from "@/lib/auth"
import { validateData, userRegistrationSchema } from "@/lib/validation"

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

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // Validar datos
    const validation = validateData(userRegistrationSchema, body)
    if (!validation.success) {
      return NextResponse.json(
        { success: false, error: "Datos inválidos", details: validation.errors },
        { status: 400, headers: corsHeaders() },
      )
    }

    const { username, email, password, full_name, bio, location, phone } = validation.data

    // Verificar si el usuario ya existe
    const existingUser = await executeQuery("SELECT id FROM users WHERE email = ? OR username = ?", [email, username])

    if (Array.isArray(existingUser) && existingUser.length > 0) {
      return NextResponse.json(
        { success: false, error: "El usuario ya existe" },
        { status: 409, headers: corsHeaders() },
      )
    }

    // Hashear la contraseña
    const password_hash = await hashPassword(password)

    // Insertar nuevo usuario
    const result = await executeQuery(
      `INSERT INTO users (username, email, password_hash, full_name, bio, location, phone) 
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [username, email, password_hash, full_name, bio || null, location || null, phone || null],
    )

    return NextResponse.json(
      {
        success: true,
        message: "Usuario creado exitosamente",
        data: { user_id: (result as any).insertId },
      },
      { status: 201, headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error registering user:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
