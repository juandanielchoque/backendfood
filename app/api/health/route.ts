import { type NextRequest, NextResponse } from "next/server"
import { healthCheck } from "@/lib/database"

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
    const dbHealth = await healthCheck()

    const health = {
      status: "healthy",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
      database: dbHealth,
      uptime: process.uptime(),
      memory: process.memoryUsage(),
    }

    const statusCode = dbHealth.status === "healthy" ? 200 : 503

    return NextResponse.json(health, { status: statusCode, headers: corsHeaders() })
  } catch (error: any) {
    console.error("Health check failed:", error)
    return NextResponse.json(
      {
        status: "unhealthy",
        timestamp: new Date().toISOString(),
        error: error.message,
      },
      { status: 503, headers: corsHeaders() },
    )
  }
}
