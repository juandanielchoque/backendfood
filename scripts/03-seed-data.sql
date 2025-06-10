-- Datos de ejemplo para FoodScrap
USE foodscrap;

-- Insertar usuarios de ejemplo
INSERT INTO users (username, email, password_hash, full_name, bio, location) VALUES
('foodie_juan', 'juan@example.com', '$2b$10$example_hash_1', 'Juan Pérez', 'Amante de la buena comida y explorador gastronómico', 'Madrid, España'),
('chef_maria', 'maria@example.com', '$2b$10$example_hash_2', 'María González', 'Chef profesional y crítica gastronómica', 'Barcelona, España'),
('taste_carlos', 'carlos@example.com', '$2b$10$example_hash_3', 'Carlos Rodríguez', 'Siempre en busca del mejor sabor', 'Valencia, España');

-- Insertar restaurantes de ejemplo
INSERT INTO restaurants (name, description, address, phone, cuisine_type, price_range, rating) VALUES
('La Paella Dorada', 'Auténtica paella valenciana y cocina mediterránea', 'Calle Mayor 123, Valencia', '+34 96 123 4567', 'Española', '$$', 4.5),
('Sushi Zen', 'Sushi fresco y cocina japonesa tradicional', 'Avenida Diagonal 456, Barcelona', '+34 93 234 5678', 'Japonesa', '$$$', 4.7),
('Trattoria Bella', 'Pasta casera y auténtica cocina italiana', 'Gran Vía 789, Madrid', '+34 91 345 6789', 'Italiana', '$$', 4.3),
('Burger Palace', 'Las mejores hamburguesas gourmet de la ciudad', 'Calle Serrano 321, Madrid', '+34 91 456 7890', 'Americana', '$', 4.1);

-- Insertar platos de ejemplo
INSERT INTO dishes (restaurant_id, name, description, category, base_price, is_vegetarian, is_vegan) VALUES
(1, 'Paella Valenciana', 'Paella tradicional con pollo, conejo y verduras', 'Arroces', 18.50, FALSE, FALSE),
(1, 'Paella de Verduras', 'Paella vegetariana con verduras de temporada', 'Arroces', 16.00, TRUE, TRUE),
(2, 'Sashimi Variado', 'Selección de pescado fresco cortado finamente', 'Sashimi', 24.00, FALSE, FALSE),
(2, 'Ramen Tonkotsu', 'Ramen con caldo de hueso de cerdo', 'Sopas', 14.50, FALSE, FALSE),
(3, 'Spaghetti Carbonara', 'Pasta con huevo, panceta y queso parmesano', 'Pasta', 12.80, FALSE, FALSE),
(3, 'Pizza Margherita', 'Pizza clásica con tomate, mozzarella y albahaca', 'Pizza', 11.50, TRUE, FALSE),
(4, 'Burger Clásica', 'Hamburguesa con carne, lechuga, tomate y cebolla', 'Hamburguesas', 9.90, FALSE, FALSE),
(4, 'Burger Vegana', 'Hamburguesa 100% vegetal con quinoa', 'Hamburguesas', 10.50, TRUE, TRUE);

-- Insertar reseñas de ejemplo
INSERT INTO reviews (user_id, dish_id, restaurant_id, rating, title, content, taste_rating, presentation_rating, value_rating, service_rating) VALUES
(1, 1, 1, 5, 'Excelente paella', 'La mejor paella que he probado en Valencia. Auténtico sabor tradicional.', 5, 4, 5, 4),
(2, 3, 2, 4, 'Sashimi fresco', 'Pescado muy fresco, aunque el precio es un poco elevado.', 5, 5, 3, 4),
(3, 5, 3, 4, 'Carbonara deliciosa', 'Muy buena pasta, cremosa y con buen sabor. Porción generosa.', 4, 4, 4, 4);

-- Insertar posts de ejemplo
INSERT INTO posts (user_id, dish_id, restaurant_id, content, post_type) VALUES
(1, 1, 1, '¡Acabo de probar la mejor paella de Valencia! 🥘 Totalmente recomendada', 'review'),
(2, NULL, NULL, '¿Cuál es vuestro restaurante japonés favorito en Barcelona? Busco recomendaciones 🍣', 'general'),
(3, 5, 3, 'Comparando carbonaras: Trattoria Bella vs otros restaurantes italianos', 'comparison');
