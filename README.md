# FoodScrap Backend

Backend API para FoodScrap - Red social gastronómica.

## 🚀 Características

- **Autenticación JWT** - Sistema seguro de autenticación
- **Gestión de Restaurantes** - CRUD completo para restaurantes
- **Gestión de Platos** - Catálogo de platos con filtros avanzados
- **Sistema de Reseñas** - Reseñas detalladas con múltiples criterios
- **Red Social** - Posts, likes, comentarios y seguimientos
- **Búsqueda Avanzada** - Búsqueda en tiempo real
- **API RESTful** - Endpoints bien documentados
- **Validación de Datos** - Validación robusta con Zod
- **Logging** - Sistema de logs con Winston
- **Health Check** - Monitoreo de salud del sistema

## 📋 Requisitos Previos

- Node.js 18+ 
- MySQL 8.0+
- npm o yarn

## 🛠️ Instalación

1. **Clonar el repositorio**
\`\`\`bash
git clone <repository-url>
cd foodscrap-backend
\`\`\`

2. **Instalar dependencias**
\`\`\`bash
npm install
\`\`\`

3. **Configurar variables de entorno**
\`\`\`bash
cp .env.example .env
# Editar .env con tus credenciales
\`\`\`

4. **Crear base de datos**
- Ejecutar el script SQL en MySQL Workbench
- Configurar las credenciales en .env

5. **Iniciar el servidor**
\`\`\`bash
npm run dev
\`\`\`

## 🗄️ Base de Datos

### Configuración en MySQL Workbench

1. Abrir MySQL Workbench
2. Conectar a tu servidor MySQL
3. Ejecutar el script `foodscrap_database_schema.sql`
4. Verificar que todas las tablas se crearon correctamente

### Variables de Entorno

\`\`\`env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=foodscrap
JWT_SECRET=tu_jwt_secret_super_seguro
\`\`\`

## 📚 API Endpoints

### Autenticación
- `POST /api/auth/register` - Registro de usuario
- `POST /api/auth/login` - Login de usuario

### Restaurantes
- `GET /api/restaurants` - Listar restaurantes
- `POST /api/restaurants` - Crear restaurante

### Platos
- `GET /api/dishes` - Listar platos
- `POST /api/dishes` - Crear plato

### Reseñas
- `GET /api/reviews` - Listar reseñas
- `POST /api/reviews` - Crear reseña

### Búsqueda
- `GET /api/search?q=paella` - Búsqueda general

### Sistema
- `GET /api/health` - Health check

## 🔧 Uso de la API

### Registro de Usuario
\`\`\`bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "juan_foodie",
    "email": "juan@example.com",
    "password": "MiPassword123",
    "full_name": "Juan Pérez"
  }'
\`\`\`

### Login
\`\`\`bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "MiPassword123"
  }'
\`\`\`

### Crear Restaurante (requiere autenticación)
\`\`\`bash
curl -X POST http://localhost:3000/api/restaurants \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Mi Restaurante",
    "description": "Descripción del restaurante",
    "address": "Calle Principal 123",
    "city": "Madrid",
    "cuisine_type": "Española",
    "price_range": "$$"
  }'
\`\`\`

### Buscar Restaurantes
\`\`\`bash
curl "http://localhost:3000/api/restaurants?city=Madrid&cuisine=Española&page=1&limit=10"
\`\`\`

### Buscar Platos
\`\`\`bash
curl "http://localhost:3000/api/dishes?restaurant_id=1&vegetarian=true"
\`\`\`

### Búsqueda General
\`\`\`bash
curl "http://localhost:3000/api/search?q=paella&type=all"
\`\`\`

## 🏗️ Estructura del Proyecto

\`\`\`
foodscrap-backend/
├── app/
│   └── api/
│       ├── auth/
│       ├── restaurants/
│       ├── dishes/
│       ├── reviews/
│       ├── search/
│       └── health/
├── lib/
│   ├── database.ts
│   ├── auth.ts
│   ├── validation.ts
│   └── types.ts
├── logs/
├── .env.example
├── package.json
└── README.md
\`\`\`

## 🔒 Autenticación

El sistema utiliza JWT (JSON Web Tokens) para la autenticación:

1. El usuario se registra o hace login
2. Recibe un token JWT válido por 7 días
3. Incluye el token en el header `Authorization: Bearer <token>`
4. El backend valida el token en rutas protegidas

## 📊 Logging

El sistema incluye logging detallado:

- **Logs de base de datos** - `logs/database.log`
- **Logs de errores** - `logs/database-error.log`
- **Consola en desarrollo** - Logs visibles en terminal

## 🧪 Testing

\`\`\`bash
# Ejecutar tests
npm test

# Tests en modo watch
npm run test:watch
\`\`\`

## 🚀 Despliegue

### Desarrollo
\`\`\`bash
npm run dev
\`\`\`

### Producción
\`\`\`bash
npm run build
npm start
\`\`\`

## 📈 Monitoreo

### Health Check
\`\`\`bash
curl http://localhost:3000/api/health
\`\`\`

Respuesta:
\`\`\`json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "version": "1.0.0",
  "database": {
    "status": "healthy",
    "latency": 15
  },
  "uptime": 3600,
  "memory": {
    "rss": 50331648,
    "heapTotal": 20971520,
    "heapUsed": 15728640
  }
}
\`\`\`

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abrir un Pull Request

## 📄 Licencia

MIT License - ver archivo LICENSE para detalles.

## 🆘 Soporte

Para soporte técnico:
- Crear un issue en GitHub
- Contactar al equipo de desarrollo
- Revisar la documentación de la API

---

**FoodScrap Backend v1.0.0** - Desarrollado con ❤️ para la comunidad gastronómica
