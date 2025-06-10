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

    const followingId = Number.parseInt(params.id)
    const followerId = user.userId

    if (followerId === followingId) {
      return NextResponse.json({ error: "No puedes seguirte a ti mismo" }, { status: 400 })
    }

    // Verificar si ya sigue al usuario
    const existingFollow = (await executeQuery("SELECT id FROM follows WHERE follower_id = ? AND following_id = ?", [
      followerId,
      followingId,
    ])) as any[]

    if (existingFollow.length > 0) {
      return NextResponse.json({ error: "Ya sigues a este usuario" }, { status: 409 })
    }

    // Crear seguimiento
    await executeQuery("INSERT INTO follows (follower_id, following_id) VALUES (?, ?)", [followerId, followingId])

    return NextResponse.json({ message: "Usuario seguido exitosamente" })
  } catch (error) {
    console.error("Error following user:", error)
    return NextResponse.json({ error: "Error interno del servidor" }, { status: 500 })
  }
}

export async function DELETE(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const user = getUserFromToken(request)
    if (!user) {
      return NextResponse.json({ error: "Token de autenticación requerido" }, { status: 401 })
    }

    const followingId = Number.parseInt(params.id)
    const followerId = user.userId

    await executeQuery("DELETE FROM follows WHERE follower_id = ? AND following_id = ?", [followerId, followingId])

    return NextResponse.json({ message: "Usuario no seguido exitosamente" })
  } catch (error) {
    console.error("Error unfollowing user:", error)
    return NextResponse.json({ error: "Error interno del servidor" }, { status: 500 })
  }
}
