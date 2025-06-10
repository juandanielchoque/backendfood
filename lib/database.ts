import mysql from "mysql2/promise"
import { createLogger, format, transports } from "winston"

// Logger para base de datos
const dbLogger = createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: format.combine(format.timestamp(), format.errors({ stack: true }), format.json()),
  transports: [
    new transports.File({ filename: "logs/database-error.log", level: "error" }),
    new transports.File({ filename: "logs/database.log" }),
  ],
})

if (process.env.NODE_ENV !== "production") {
  dbLogger.add(
    new transports.Console({
      format: format.simple(),
    }),
  )
}

// Configuración de la base de datos
const dbConfig = {
  host: process.env.DB_HOST || "localhost",
  port: Number.parseInt(process.env.DB_PORT || "3306"),
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "foodscrap",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
}

// Pool de conexiones
const pool = mysql.createPool(dbConfig)

// Función para ejecutar queries
export async function executeQuery(query: string, params: any[] = []): Promise<any> {
  const startTime = Date.now()

  try {
    if (!query || typeof query !== "string") {
      throw new Error("Query must be a non-empty string")
    }

    if (!Array.isArray(params)) {
      throw new Error("Params must be an array")
    }

    // Log de la query en desarrollo
    if (process.env.NODE_ENV === "development") {
      dbLogger.info("Executing query", {
        query: query.substring(0, 200) + (query.length > 200 ? "..." : ""),
        paramsCount: params.length,
      })
    }

    const [results] = await pool.execute(query, params)
    const executionTime = Date.now() - startTime

    dbLogger.info("Query executed successfully", {
      executionTime,
      affectedRows: (results as any).affectedRows || 0,
      resultCount: Array.isArray(results) ? results.length : 0,
    })

    return results
  } catch (error: any) {
    const executionTime = Date.now() - startTime

    dbLogger.error("Database query error", {
      error: error.message,
      code: error.code,
      errno: error.errno,
      query: query.substring(0, 500),
      executionTime,
    })

    const enhancedError = new Error(`Database Error: ${error.message}`)
    enhancedError.name = "DatabaseError"
    throw enhancedError
  }
}

// Función para transacciones
export async function executeTransaction(queries: Array<{ query: string; params?: any[] }>): Promise<any[]> {
  const connection = await pool.getConnection()
  const results: any[] = []

  try {
    await connection.beginTransaction()

    for (const { query, params = [] } of queries) {
      const [result] = await connection.execute(query, params)
      results.push(result)
    }

    await connection.commit()
    dbLogger.info("Transaction completed successfully", { queriesCount: queries.length })

    return results
  } catch (error: any) {
    await connection.rollback()
    dbLogger.error("Transaction failed, rolled back", {
      error: error.message,
      queriesCount: queries.length,
    })
    throw error
  } finally {
    connection.release()
  }
}

// Health check de la base de datos
export async function healthCheck(): Promise<{ status: string; latency: number }> {
  const startTime = Date.now()

  try {
    await executeQuery("SELECT 1 as health_check")
    const latency = Date.now() - startTime

    return {
      status: "healthy",
      latency,
    }
  } catch (error) {
    return {
      status: "unhealthy",
      latency: Date.now() - startTime,
    }
  }
}

export default pool
