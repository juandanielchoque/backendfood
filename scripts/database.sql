-- Base de datos FoodScrap Simple y Funcional
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
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabla de restaurantes
CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    cuisine_type VARCHAR(50),
    price_range ENUM('$', '$$', '$$$', '$$$$') DEFAULT '$$',
    rating DECIMAL(3,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Tabla de platos
CREATE TABLE dishes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(10, 2),
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- Tabla de reseñas
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    dish_id INT,
    restaurant_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    content TEXT NOT NULL,
    post_type ENUM('review', 'comparison', 'recommendation', 'general') DEFAULT 'general',
    likes_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);

-- Insertar datos de ejemplo
INSERT INTO users (username, email, password_hash, full_name, bio, location) VALUES
('juan_foodie', 'juan@example.com', '$2b$10$example_hash_1', 'Juan Pérez', 'Amante de la buena comida', 'Madrid'),
('maria_chef', 'maria@example.com', '$2b$10$example_hash_2', 'María González', 'Chef profesional', 'Barcelona'),
('carlos_taste', 'carlos@example.com', '$2b$10$example_hash_3', 'Carlos Rodríguez', 'Crítico gastronómico', 'Valencia');

INSERT INTO restaurants (name, description, address, city, phone, cuisine_type, price_range, rating) VALUES
('La Paella Dorada', 'Auténtica paella valenciana', 'Calle Mayor 123', 'Valencia', '+34 96 123 4567', 'Española', '$$', 4.5),
('Sushi Zen', 'Sushi fresco y cocina japonesa', 'Avenida Diagonal 456', 'Barcelona', '+34 93 234 5678', 'Japonesa', '$$$', 4.7),
('Trattoria Bella', 'Pasta casera italiana', 'Gran Vía 789', 'Madrid', '+34 91 345 6789', 'Italiana', '$$', 4.3),
('Burger Palace', 'Hamburguesas gourmet', 'Calle Serrano 321', 'Madrid', '+34 91 456 7890', 'Americana', '$', 4.1);

INSERT INTO dishes (restaurant_id, name, description, category, price, is_vegetarian, is_vegan, rating) VALUES
(1, 'Paella Valenciana', 'Paella tradicional con pollo y verduras', 'Arroces', 18.50, FALSE, FALSE, 4.6),
(1, 'Paella de Verduras', 'Paella vegetariana', 'Arroces', 16.00, TRUE, TRUE, 4.2),
(2, 'Sashimi Variado', 'Selección de pescado fresco', 'Sashimi', 24.00, FALSE, FALSE, 4.8),
(2, 'Ramen Tonkotsu', 'Ramen con caldo de cerdo', 'Sopas', 14.50, FALSE, FALSE, 4.5),
(3, 'Spaghetti Carbonara', 'Pasta con huevo y panceta', 'Pasta', 12.80, FALSE, FALSE, 4.4),
(3, 'Pizza Margherita', 'Pizza clásica con tomate y mozzarella', 'Pizza', 11.50, TRUE, FALSE, 4.3),
(4, 'Burger Clásica', 'Hamburguesa con carne y verduras', 'Hamburguesas', 9.90, FALSE, FALSE, 4.0),
(4, 'Burger Vegana', 'Hamburguesa 100% vegetal', 'Hamburguesas', 10.50, TRUE, TRUE, 4.1);

INSERT INTO reviews (user_id, dish_id, restaurant_id, rating, title, content) VALUES
(1, 1, 1, 5, 'Excelente paella', 'La mejor paella que he probado en Valencia'),
(2, 3, 2, 5, 'Sashimi fresco', 'Pescado muy fresco y bien presentado'),
(3, 5, 3, 4, 'Buena carbonara', 'Muy rica, aunque un poco salada');

INSERT INTO posts (user_id, dish_id, restaurant_id, content, post_type, likes_count) VALUES
(1, 1, 1, '¡Acabo de probar la mejor paella de Valencia! Totalmente recomendada', 'review', 15),
(2, NULL, NULL, '¿Cuál es vuestro restaurante japonés favorito en Barcelona?', 'general', 8),
(3, 5, 3, 'Comparando carbonaras: esta está en mi top 3', 'comparison', 12);

-- Verificar instalación
SELECT 'Base de datos creada exitosamente' as status;
SELECT COUNT(*) as usuarios FROM users;
SELECT COUNT(*) as restaurantes FROM restaurants;
SELECT COUNT(*) as platos FROM dishes;
