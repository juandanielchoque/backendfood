import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import { verifyPassword, generateToken } from "@/lib/auth"
import { validateData, userLoginSchema } from "@/lib/validation"

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
    const validation = validateData(userLoginSchema, body)
    if (!validation.success) {
      return NextResponse.json(
        { success: false, error: "Datos inválidos", details: validation.errors },
        { status: 400, headers: corsHeaders() },
      )
    }

    const { email, password } = validation.data

    // Buscar usuario
    const users = (await executeQuery(
      "SELECT id, username, email, password_hash, full_name, is_verified, is_premium FROM users WHERE email = ? AND is_active = TRUE",
      [email],
    )) as any[]

    if (users.length === 0) {
      return NextResponse.json(
        { success: false, error: "Credenciales inválidas" },
        { status: 401, headers: corsHeaders() },
      )
    }

    const user = users[0]

    // Verificar contraseña
    const isValidPassword = await verifyPassword(password, user.password_hash)
    if (!isValidPassword) {
      return NextResponse.json(
        { success: false, error: "Credenciales inválidas" },
        { status: 401, headers: corsHeaders() },
      )
    }

    // Actualizar último login
    await executeQuery("UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?", [user.id])

    // Generar token
    const token = generateToken({
      userId: user.id,
      email: user.email,
      username: user.username,
    })

    // Remover password_hash de la respuesta
    const { password_hash, ...userWithoutPassword } = user

    return NextResponse.json(
      {
        success: true,
        message: "Login exitoso",
        data: {
          token,
          user: userWithoutPassword,
        },
      },
      { headers: corsHeaders() },
    )
  } catch (error: any) {
    console.error("Error logging in:", error)
    return NextResponse.json(
      { success: false, error: "Error interno del servidor" },
      { status: 500, headers: corsHeaders() },
    )
  }
}
