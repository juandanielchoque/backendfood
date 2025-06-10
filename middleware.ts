import { type NextRequest, NextResponse } from "next/server"
import jwt from "jsonwebtoken"

export function middleware(request: NextRequest) {
  // Configurar CORS para todas las rutas API
  if (request.nextUrl.pathname.startsWith("/api/")) {
    // Crear respuesta con headers CORS
    const response = NextResponse.next()

    // Configurar headers CORS
    response.headers.set("Access-Control-Allow-Origin", "*")
    response.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
    response.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization")
    response.headers.set("Access-Control-Max-Age", "86400")

    // Manejar preflight requests (OPTIONS)
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 200, headers: response.headers })
    }

    // Rutas que requieren autenticación
    const protectedPaths = ["/api/posts", "/api/reviews", "/api/users/*/follow", "/api/posts/*/like"]

    const isProtectedPath = protectedPaths.some((path) => {
      const regex = new RegExp(path.replace("*", "[^/]+"))
      return regex.test(request.nextUrl.pathname)
    })

    if (isProtectedPath && request.method !== "GET") {
      const token = request.headers.get("authorization")?.replace("Bearer ", "")

      if (!token) {
        const errorResponse = NextResponse.json({ error: "Token de autenticación requerido" }, { status: 401 })
        // Agregar headers CORS a la respuesta de error
        errorResponse.headers.set("Access-Control-Allow-Origin", "*")
        errorResponse.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        errorResponse.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization")
        return errorResponse
      }

      try {
        jwt.verify(token, process.env.JWT_SECRET || "fallback_secret")
      } catch (error) {
        const errorResponse = NextResponse.json({ error: "Token inválido" }, { status: 401 })
        // Agregar headers CORS a la respuesta de error
        errorResponse.headers.set("Access-Control-Allow-Origin", "*")
        errorResponse.headers.set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        errorResponse.headers.set("Access-Control-Allow-Headers", "Content-Type, Authorization")
        return errorResponse
      }
    }

    return response
  }

  return NextResponse.next()
}

export const config = {
  matcher: "/api/:path*",
}
