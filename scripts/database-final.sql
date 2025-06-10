-- Base de datos FoodScrap - Versión Final Corregida
DROP DATABASE IF EXISTS foodscrap;
CREATE DATABASE foodscrap CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE foodscrap;

-- Tabla de usuarios
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    bio TEXT,
    profile_image VARCHAR(500),
    location VARCHAR(100),
    phone VARCHAR(20),
    followers_count INT DEFAULT 0,
    following_count INT DEFAULT 0,
    posts_count INT DEFAULT 0,
    reviews_count INT DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    is_premium BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabla de restaurantes
CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) UNIQUE NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'España',
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(255),
    cuisine_type VARCHAR(50),
    price_range ENUM('$', '$$', '$$$', '$$$$') DEFAULT '$$',
    rating DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    image_url VARCHAR(500),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    opening_hours JSON,
    features JSON,
    accepts_reservations BOOLEAN DEFAULT TRUE,
    delivery_available BOOLEAN DEFAULT FALSE,
    takeout_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabla de platos
CREATE TABLE dishes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    base_price DECIMAL(10, 2),
    currency VARCHAR(3) DEFAULT 'EUR',
    image_url VARCHAR(500),
    ingredients TEXT,
    allergens JSON,
    preparation_time INT,
    spice_level ENUM('none', 'mild', 'medium', 'hot', 'very_hot') DEFAULT 'none',
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    is_gluten_free BOOLEAN DEFAULT FALSE,
    is_signature_dish BOOLEAN DEFAULT FALSE,
    calories INT,
    rating DECIMAL(3,2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- Tabla de reseñas
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    dish_id INT,
    restaurant_id INT NOT NULL,
    overall_rating INT NOT NULL CHECK (overall_rating >= 1 AND overall_rating <= 5),
    title VARCHAR(200),
    content TEXT,
    pros TEXT,
    cons TEXT,
    images JSON,
    taste_rating INT CHECK (taste_rating >= 1 AND taste_rating <= 5),
    presentation_rating INT CHECK (presentation_rating >= 1 AND presentation_rating <= 5),
    value_rating INT CHECK (value_rating >= 1 AND value_rating <= 5),
    service_rating INT CHECK (service_rating >= 1 AND service_rating <= 5),
    visit_date DATE,
    visit_type ENUM('dine_in', 'takeout', 'delivery') DEFAULT 'dine_in',
    would_recommend BOOLEAN DEFAULT TRUE,
    would_return BOOLEAN DEFAULT TRUE,
    helpful_votes INT DEFAULT 0,
    status ENUM('active', 'flagged', 'hidden', 'deleted') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- Tabla de posts
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    dish_id INT,
    restaurant_id INT,
    title VARCHAR(200),
    content TEXT NOT NULL,
    images JSON,
    tags JSON,
    post_type ENUM('review', 'comparison', 'recommendation', 'question', 'tip', 'general') DEFAULT 'general',
    visibility ENUM('public', 'followers', 'private') DEFAULT 'public',
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    shares_count INT DEFAULT 0,
    views_count INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    status ENUM('draft', 'published', 'archived', 'deleted') DEFAULT 'published',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE SET NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE SET NULL
);

-- Tabla de likes
CREATE TABLE likes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    post_id INT,
    review_id INT,
    comment_id INT,
    like_type ENUM('like', 'love', 'laugh', 'wow', 'sad', 'angry') DEFAULT 'like',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_post (user_id, post_id),
    UNIQUE KEY unique_user_review (user_id, review_id)
);

-- Tabla de comentarios
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    post_id INT,
    review_id INT,
    parent_comment_id INT,
    content TEXT NOT NULL,
    images JSON,
    likes_count INT DEFAULT 0,
    replies_count INT DEFAULT 0,
    is_edited BOOLEAN DEFAULT FALSE,
    edited_at TIMESTAMP NULL,
    status ENUM('active', 'flagged', 'hidden', 'deleted') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- Tabla de seguimientos
CREATE TABLE follows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    status ENUM('active', 'blocked', 'muted') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (follower_id, following_id)
);

-- Tabla de favoritos
CREATE TABLE favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    dish_id INT,
    restaurant_id INT,
    post_id INT,
    collection_name VARCHAR(100) DEFAULT 'Default',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
);

-- Insertar usuarios de ejemplo
INSERT INTO users (username, email, password_hash, full_name, bio, location, is_verified) VALUES
('juan_foodie', 'juan@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Juan Pérez García', 'Crítico gastronómico y amante de la cocina tradicional española.', 'Madrid, España', TRUE),
('maria_chef', 'maria@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'María González López', 'Chef ejecutiva con 15 años de experiencia.', 'Barcelona, España', TRUE),
('carlos_taste', 'carlos@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Carlos Rodríguez Martín', 'Blogger gastronómico y fotógrafo de comida.', 'Valencia, España', TRUE),
('ana_gourmet', 'ana@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Ana Martínez Silva', 'Sommelier y experta en maridajes.', 'Sevilla, España', FALSE);

-- Insertar restaurantes de ejemplo
INSERT INTO restaurants (name, slug, description, address, city, phone, cuisine_type, price_range, rating, review_count) VALUES
('La Paella Dorada', 'la-paella-dorada-valencia', 'Restaurante familiar especializado en paella valenciana auténtica desde 1952.', 'Calle Mayor 123', 'Valencia', '+34 96 123 4567', 'Española', '$$', 4.5, 127),
('Sushi Zen Barcelona', 'sushi-zen-barcelona', 'Auténtica experiencia japonesa en el corazón de Barcelona.', 'Avenida Diagonal 456', 'Barcelona', '+34 93 234 5678', 'Japonesa', '$$$', 4.7, 203),
('Trattoria Bella Vita', 'trattoria-bella-vita-madrid', 'Cocina italiana casera en Madrid. Pasta fresca hecha diariamente.', 'Gran Vía 789', 'Madrid', '+34 91 345 6789', 'Italiana', '$$', 4.3, 156),
('Burger Palace Gourmet', 'burger-palace-gourmet-madrid', 'Las mejores hamburguesas gourmet de Madrid.', 'Calle Serrano 321', 'Madrid', '+34 91 456 7890', 'Americana', '$', 4.1, 89);

-- Insertar platos de ejemplo
INSERT INTO dishes (restaurant_id, name, slug, description, category, base_price, is_vegetarian, is_vegan, is_signature_dish, calories, rating, review_count) VALUES
(1, 'Paella Valenciana Tradicional', 'paella-valenciana-tradicional', 'Auténtica paella valenciana con pollo, conejo y verduras.', 'Arroces', 18.50, FALSE, FALSE, TRUE, 420, 4.6, 45),
(1, 'Paella de Verduras Ecológica', 'paella-verduras-ecologica', 'Paella vegetariana con verduras de temporada ecológicas.', 'Arroces', 16.00, TRUE, TRUE, FALSE, 350, 4.2, 23),
(2, 'Sashimi Premium Selection', 'sashimi-premium-selection', 'Selección de sashimi premium con pescado fresco importado.', 'Sashimi', 28.00, FALSE, FALSE, TRUE, 180, 4.8, 67),
(2, 'Ramen Tonkotsu Auténtico', 'ramen-tonkotsu-autentico', 'Ramen tradicional con caldo de hueso de cerdo cocido 18 horas.', 'Sopas', 16.50, FALSE, FALSE, TRUE, 520, 4.5, 34),
(3, 'Spaghetti Carbonara Romana', 'spaghetti-carbonara-romana', 'Auténtica carbonara romana con guanciale y pecorino.', 'Pasta', 14.50, FALSE, FALSE, TRUE, 480, 4.4, 28),
(3, 'Pizza Margherita Napoletana', 'pizza-margherita-napoletana', 'Pizza napoletana con masa madre de 48h de fermentación.', 'Pizza', 13.00, TRUE, FALSE, TRUE, 320, 4.3, 41),
(4, 'Burger Angus Premium', 'burger-angus-premium', 'Hamburguesa de ternera Angus 200g con ingredientes premium.', 'Hamburguesas', 16.90, FALSE, FALSE, TRUE, 680, 4.0, 19),
(4, 'Burger Vegana Beyond', 'burger-vegana-beyond', 'Hamburguesa 100% vegetal Beyond Meat con aguacate.', 'Hamburguesas', 15.50, TRUE, TRUE, FALSE, 420, 4.1, 12);

-- Insertar reseñas de ejemplo
INSERT INTO reviews (user_id, dish_id, restaurant_id, overall_rating, title, content, taste_rating, presentation_rating, value_rating, service_rating, visit_type, would_recommend, would_return) VALUES
(1, 1, 1, 5, 'La mejor paella de Valencia', 'Increíble experiencia gastronómica. La paella estaba perfecta, con el punto exacto de arroz.', 5, 5, 4, 4, 'dine_in', TRUE, TRUE),
(2, 3, 2, 5, 'Sashimi de calidad excepcional', 'Como chef, puedo asegurar que la calidad del pescado es excepcional.', 5, 5, 3, 5, 'dine_in', TRUE, TRUE),
(3, 5, 3, 4, 'Auténtica carbonara romana', 'Excelente pasta con masa perfecta y ingredientes de calidad.', 5, 4, 4, 4, 'dine_in', TRUE, TRUE),
(4, 7, 4, 4, 'Hamburguesa gourmet de calidad', 'Muy buena hamburguesa con carne de calidad y ingredientes frescos.', 4, 4, 4, 3, 'dine_in', TRUE, TRUE);

-- Insertar posts de ejemplo
INSERT INTO posts (user_id, dish_id, restaurant_id, title, content, post_type, likes_count, comments_count) VALUES
(1, 1, 1, 'La mejor paella de mi vida! 🥘', 'Acabo de descubrir este tesoro escondido en Valencia. La Paella Dorada sirve la paella más auténtica que he probado en años.', 'review', 23, 5),
(2, NULL, NULL, '¿Cuál es vuestro restaurante japonés favorito en Barcelona? 🍣', 'Estoy preparando una guía de los mejores restaurantes japoneses de Barcelona y me encantaría conocer vuestras recomendaciones.', 'question', 15, 12),
(3, 5, 3, 'Comparativa: Las mejores carbonaras de Madrid', 'He estado probando carbonaras por toda la ciudad y tengo que decir que Trattoria Bella Vita está en el top 3.', 'comparison', 31, 8),
(4, NULL, NULL, 'Tips para maridar vinos con comida asiática 🍷', 'Muchos piensan que el vino no va bien con la comida asiática, pero nada más lejos de la realidad.', 'tip', 18, 6);

-- Crear índices para optimización
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_restaurants_name ON restaurants(name);
CREATE INDEX idx_restaurants_city ON restaurants(city);
CREATE INDEX idx_restaurants_cuisine ON restaurants(cuisine_type);
CREATE INDEX idx_restaurants_rating ON restaurants(rating);
CREATE INDEX idx_dishes_name ON dishes(name);
CREATE INDEX idx_dishes_restaurant ON dishes(restaurant_id);
CREATE INDEX idx_dishes_category ON dishes(category);
CREATE INDEX idx_dishes_price ON dishes(base_price);
CREATE INDEX idx_dishes_rating ON dishes(rating);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_dish ON reviews(dish_id);
CREATE INDEX idx_reviews_restaurant ON reviews(restaurant_id);
CREATE INDEX idx_reviews_rating ON reviews(overall_rating);
CREATE INDEX idx_posts_user ON posts(user_id);
CREATE INDEX idx_posts_created ON posts(created_at);
CREATE INDEX idx_likes_user ON likes(user_id);
CREATE INDEX idx_likes_post ON likes(post_id);

-- Verificación de instalación
SELECT 'Base de datos FoodScrap creada exitosamente' as status;
SELECT COUNT(*) as total_usuarios FROM users;
SELECT COUNT(*) as total_restaurantes FROM restaurants;
SELECT COUNT(*) as total_platos FROM dishes;
SELECT COUNT(*) as total_resenas FROM reviews;
SELECT COUNT(*) as total_posts FROM posts;
