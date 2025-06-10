import { type NextRequest, NextResponse } from "next/server"
import { executeQuery } from "@/lib/database"
import jwt from "jsonwebtoken"

function getUserFromToken(request: NextRequest) {
  const token = request.headers.get("authorization")?.replace("Bearer ", "")
  if (!token) return null

  try {
    return jwt.verify(token, process.env.JWT_SECRET || "fallback_secret") as any
  } catch {
    return null
  }
}

export async function POST(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const user = getUserFromToken(request)
    if (!user) {
      return NextResponse.json({ error: "Token de autenticación requerido" }, { status: 401 })
    }

    const postId = Number.parseInt(params.id)
    const userId = user.userId

    // Verificar si ya le dio like
    const existingLike = (await executeQuery("SELECT id FROM likes WHERE user_id = ? AND post_id = ?", [
      userId,
      postId,
    ])) as any[]

    if (existingLike.length > 0) {
      return NextResponse.json({ error: "Ya le diste like a este post" }, { status: 409 })
    }

    // Crear like
    await executeQuery("INSERT INTO likes (user_id, post_id) VALUES (?, ?)", [userId, postId])

    // Actualizar contador de likes
    await executeQuery("UPDATE posts SET likes_count = likes_count + 1 WHERE id = ?", [postId])

    return NextResponse.json({ message: "Like agregado exitosamente" })
  } catch (error) {
    console.error("Error liking post:", error)
    return NextResponse.json({ error: "Error interno del servidor" }, { status: 500 })
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const user = getUserFromToken(request)
    if (!user) {
      return NextResponse.json({ error: "Token de autenticación requerido" }, { status: 401 })
    }

    const postId = Number.parseInt(params.id)
    const userId = user.userId

    // Eliminar like
    const result = (await executeQuery("DELETE FROM likes WHERE user_id = ? AND post_id = ?", [userId, postId])) as any

    if (result.affectedRows > 0) {
      // Actualizar contador de likes
      await executeQuery("UPDATE posts SET likes_count = likes_count - 1 WHERE id = ?", [postId])
    }

    return NextResponse.json({ message: "Like eliminado exitosamente" })
  } catch (error) {
    console.error("Error unliking post:", error)
    return NextResponse.json({ error: "Error interno del servidor" }, { status: 500 })
  }
}
