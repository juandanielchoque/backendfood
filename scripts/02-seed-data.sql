-- Datos de ejemplo mejorados para FoodScrap
USE foodscrap;

-- Insertar usuarios de ejemplo
INSERT INTO users (username, email, password_hash, full_name, bio, location, phone, gender, dietary_preferences, favorite_cuisines, is_verified) VALUES
('foodie_juan', 'juan@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Juan Pérez García', 'Crítico gastronómico y amante de la cocina tradicional española. Siempre en busca de nuevos sabores.', 'Madrid, España', '+34 600 123 456', 'male', '["omnivore"]', '["española", "italiana", "japonesa"]', TRUE),
('chef_maria', 'maria@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'María González López', 'Chef ejecutiva con 15 años de experiencia. Especialista en cocina mediterránea y fusión.', 'Barcelona, España', '+34 600 234 567', 'female', '["pescetarian"]', '["mediterránea", "asiática", "francesa"]', TRUE),
('taste_carlos', 'carlos@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Carlos Rodríguez Martín', 'Blogger gastronómico y fotógrafo de comida. Documentando la mejor gastronomía de España.', 'Valencia, España', '+34 600 345 678', 'male', '["vegetarian"]', '["vegetariana", "vegana", "asiática"]', TRUE),
('gourmet_ana', 'ana@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Ana Martínez Silva', 'Sommelier y experta en maridajes. Apasionada por la alta cocina y los vinos españoles.', 'Sevilla, España', '+34 600 456 789', 'female', '["omnivore"]', '["española", "francesa", "italiana"]', FALSE),
('street_food_lover', 'miguel@foodscrap.com', '$2b$10$rOvHPy8wJO.kGzJ8oVt./.123456789abcdef', 'Miguel Fernández', 'Explorador de street food y cocina casual. Siempre buscando la mejor relación calidad-precio.', 'Bilbao, España', '+34 600 567 890', 'male', '["omnivore"]', '["street_food", "asiática", "mexicana"]', FALSE);

-- Insertar restaurantes de ejemplo
INSERT INTO restaurants (name, slug, description, address, city, country, phone, email, website, cuisine_type, sub_cuisine_types, price_range, rating, review_count, image_url, gallery_images, latitude, longitude, opening_hours, features, capacity, social_media, payment_methods) VALUES
('La Paella Dorada', 'la-paella-dorada-valencia', 'Restaurante familiar especializado en paella valenciana auténtica desde 1952. Utilizamos ingredientes locales y recetas tradicionales transmitidas de generación en generación.', 'Calle Mayor 123', 'Valencia', 'España', '+34 96 123 4567', 'info@lapaelladorada.es', 'https://lapaelladorada.es', 'Española', '["valenciana", "mediterránea", "arroces"]', '$$', 4.5, 127, 'https://example.com/paella-dorada.jpg', '["https://example.com/gallery1.jpg", "https://example.com/gallery2.jpg"]', 39.4699, -0.3763, '{"monday": "12:00-16:00,20:00-24:00", "tuesday": "12:00-16:00,20:00-24:00", "wednesday": "12:00-16:00,20:00-24:00", "thursday": "12:00-16:00,20:00-24:00", "friday": "12:00-16:00,20:00-24:00", "saturday": "12:00-16:00,20:00-24:00", "sunday": "12:00-16:00"}', '["terraza", "aire_acondicionado", "wifi", "accesible"]', 80, '{"instagram": "@lapaelladorada", "facebook": "LapaellaDoradaValencia"}', '["efectivo", "tarjeta", "bizum"]'),

('Sushi Zen Barcelona', 'sushi-zen-barcelona', 'Auténtica experiencia japonesa en el corazón de Barcelona. Sushi fresco preparado por chefs japoneses con pescado importado diariamente de Tsukiji.', 'Avenida Diagonal 456', 'Barcelona', 'España', '+34 93 234 5678', 'reservas@sushizen.es', 'https://sushizen.es', 'Japonesa', '["sushi", "sashimi", "ramen", "tempura"]', '$$$', 4.7, 203, 'https://example.com/sushi-zen.jpg', '["https://example.com/sushi1.jpg", "https://example.com/sushi2.jpg"]', 41.3851, 2.1734, '{"monday": "19:00-24:00", "tuesday": "19:00-24:00", "wednesday": "19:00-24:00", "thursday": "19:00-24:00", "friday": "19:00-01:00", "saturday": "19:00-01:00", "sunday": "cerrado"}', '["barra_sushi", "sake_bar", "wifi", "reservas_online"]', 45, '{"instagram": "@sushizenbarcelona", "facebook": "SushiZenBCN"}', '["tarjeta", "bizum", "paypal"]'),

('Trattoria Bella Vita', 'trattoria-bella-vita-madrid', 'Cocina italiana casera en Madrid. Pasta fresca hecha diariamente y pizzas en horno de leña. Ambiente familiar y acogedor.', 'Gran Vía 789', 'Madrid', 'España', '+34 91 345 6789', 'ciao@bellavita.es', 'https://bellavita.es', 'Italiana', '["pasta", "pizza", "risotto", "antipasti"]', '$$', 4.3, 156, 'https://example.com/bella-vita.jpg', '["https://example.com/pasta1.jpg", "https://example.com/pizza1.jpg"]', 40.4168, -3.7038, '{"monday": "13:00-16:00,20:00-24:00", "tuesday": "13:00-16:00,20:00-24:00", "wednesday": "13:00-16:00,20:00-24:00", "thursday": "13:00-16:00,20:00-24:00", "friday": "13:00-16:00,20:00-01:00", "saturday": "13:00-16:00,20:00-01:00", "sunday": "13:00-16:00,20:00-24:00"}', '["terraza", "horno_leña", "wifi", "delivery"]', 60, '{"instagram": "@bellavitamadrid", "facebook": "TrattoriaBellaVitaMadrid"}', '["efectivo", "tarjeta", "bizum"]'),

('Burger Palace Gourmet', 'burger-palace-gourmet-madrid', 'Las mejores hamburguesas gourmet de Madrid. Carne premium, ingredientes locales y panes artesanales horneados diariamente.', 'Calle Serrano 321', 'Madrid', 'España', '+34 91 456 7890', 'info@burgerpalace.es', 'https://burgerpalace.es', 'Americana', '["hamburguesas", "bbq", "craft_beer"]', '$', 4.1, 89, 'https://example.com/burger-palace.jpg', '["https://example.com/burger1.jpg", "https://example.com/fries1.jpg"]', 40.4168, -3.7038, '{"monday": "12:00-24:00", "tuesday": "12:00-24:00", "wednesday": "12:00-24:00", "thursday": "12:00-24:00", "friday": "12:00-01:00", "saturday": "12:00-01:00", "sunday": "12:00-24:00"}', '["delivery", "takeout", "craft_beer", "wifi"]', 40, '{"instagram": "@burgerpalacemadrid", "facebook": "BurgerPalaceGourmet"}', '["efectivo", "tarjeta", "bizum", "glovo_pay"]);

-- Insertar platos de ejemplo
INSERT INTO dishes (restaurant_id, name, slug, description, category, subcategory, base_price, currency, image_url, ingredients, allergens, nutritional_info, preparation_time, spice_level, is_vegetarian, is_vegan, is_gluten_free, is_signature_dish, calories, protein_g, carbs_g, fat_g) VALUES
(1, 'Paella Valenciana Tradicional', 'paella-valenciana-tradicional', 'Auténtica paella valenciana con pollo, conejo, judías verdes, garrofón, tomate, pimiento rojo, azafrán y aceite de oliva virgen extra. Cocinada en paellera de hierro sobre fuego de leña.', 'Arroces', 'Paellas', 18.50, 'EUR', 'https://example.com/paella-valenciana.jpg', 'Arroz bomba, pollo, conejo, judías verdes, garrofón, tomate, pimiento rojo, azafrán, aceite de oliva virgen extra, sal, agua', '[]', '{"calorias": 420, "proteinas": 28, "carbohidratos": 45, "grasas": 12}', 25, 'none', FALSE, FALSE, TRUE, TRUE, 420, 28.5, 45.2, 12.3),

(1, 'Paella de Verduras Ecológica', 'paella-verduras-ecologica', 'Paella vegetariana con verduras de temporada ecológicas: alcachofas, judías verdes, pimiento rojo, tomate, garrofón y azafrán DOP de La Mancha.', 'Arroces', 'Paellas', 16.00, 'EUR', 'https://example.com/paella-verduras.jpg', 'Arroz bomba ecológico, alcachofas, judías verdes, pimiento rojo, tomate, garrofón, azafrán DOP, aceite de oliva virgen extra ecológico', '[]', '{"calorias": 350, "proteinas": 8, "carbohidratos": 52, "grasas": 10}', 20, 'none', TRUE, TRUE, TRUE, FALSE, 350, 8.2, 52.1, 10.5),

(2, 'Sashimi Premium Selection', 'sashimi-premium-selection', 'Selección de sashimi premium con atún rojo, salmón noruego, pez mantequilla, vieira y langostino rojo. Pescado fresco importado diariamente.', 'Sashimi', 'Premium', 28.00, 'EUR', 'https://example.com/sashimi-premium.jpg', 'Atún rojo, salmón noruego, pez mantequilla, vieira, langostino rojo, wasabi, jengibre encurtido, salsa de soja', '["pescado", "crustáceos"]', '{"calorias": 180, "proteinas": 35, "carbohidratos": 2, "grasas": 4}', 10, 'none', FALSE, FALSE, TRUE, TRUE, 180, 35.2, 2.1, 4.3),

(2, 'Ramen Tonkotsu Auténtico', 'ramen-tonkotsu-autentico', 'Ramen tradicional con caldo de hueso de cerdo cocido durante 18 horas, chashu, huevo marinado, negi, menma y nori. Fideos hechos en casa.', 'Sopas', 'Ramen', 16.50, 'EUR', 'https://example.com/ramen-tonkotsu.jpg', 'Fideos ramen caseros, caldo de hueso de cerdo, chashu, huevo marinado, cebolleta, menma, nori, aceite de ajo negro', '["gluten", "huevo", "soja"]', '{"calorias": 520, "proteinas": 25, "carbohidratos": 48, "grasas": 22}', 15, 'none', FALSE, FALSE, FALSE, TRUE, 520, 25.8, 48.3, 22.1),

(3, 'Spaghetti Carbonara Romana', 'spaghetti-carbonara-romana', 'Auténtica carbonara romana con guanciale, huevos, pecorino romano DOP y pimienta negra. Sin nata, como manda la tradición.', 'Pasta', 'Clásicos', 14.50, 'EUR', 'https://example.com/carbonara.jpg', 'Spaghetti, guanciale, huevos, pecorino romano DOP, pimienta negra', '["gluten", "huevo", "lácteos"]', '{"calorias": 480, "proteinas": 22, "carbohidratos": 55, "grasas": 18}', 12, 'none', FALSE, FALSE, FALSE, TRUE, 480, 22.4, 55.2, 18.7),

(3, 'Pizza Margherita Napoletana', 'pizza-margherita-napoletana', 'Pizza napoletana con masa madre de 48h de fermentación, tomate San Marzano DOP, mozzarella di bufala campana DOP, albahaca fresca y aceite de oliva virgen extra.', 'Pizza', 'Clásicas', 13.00, 'EUR', 'https://example.com/margherita.jpg', 'Masa madre, tomate San Marzano DOP, mozzarella di bufala campana DOP, albahaca fresca, aceite de oliva virgen extra', '["gluten", "lácteos"]', '{"calorias": 320, "proteinas": 15, "carbohidratos": 42, "grasas": 12}', 8, 'none', TRUE, FALSE, FALSE, TRUE, 320, 15.3, 42.1, 12.5),

(4, 'Burger Angus Premium', 'burger-angus-premium', 'Hamburguesa de ternera Angus 200g, queso cheddar curado, bacon ahumado, lechuga iceberg, tomate rosa, cebolla caramelizada y salsa BBQ casera en pan brioche.', 'Hamburguesas', 'Premium', 16.90, 'EUR', 'https://example.com/burger-angus.jpg', 'Carne Angus, pan brioche, queso cheddar, bacon, lechuga, tomate, cebolla, salsa BBQ casera', '["gluten", "lácteos", "huevo"]', '{"calorias": 680, "proteinas": 35, "carbohidratos": 45, "grasas": 38}', 15, 'none', FALSE, FALSE, FALSE, TRUE, 680, 35.2, 45.3, 38.1),

(4, 'Burger Vegana Beyond', 'burger-vegana-beyond', 'Hamburguesa 100% vegetal Beyond Meat, queso vegano, aguacate, rúcula, tomate, cebolla morada y mayonesa vegana en pan integral sin gluten.', 'Hamburguesas', 'Veganas', 15.50, 'EUR', 'https://example.com/burger-vegana.jpg', 'Beyond Meat, pan integral sin gluten, queso vegano, aguacate, rúcula, tomate, cebolla morada, mayonesa vegana', '[]', '{"calorias": 420, "proteinas": 22, "carbohidratos": 38, "grasas": 20}', 12, 'none', TRUE, TRUE, TRUE, FALSE, 420, 22.1, 38.2, 20.3);

-- Insertar reseñas de ejemplo
INSERT INTO reviews (user_id, dish_id, restaurant_id, overall_rating, title, content, pros, cons, taste_rating, presentation_rating, value_rating, service_rating, ambiance_rating, visit_date, visit_type, party_size, would_recommend, would_return) VALUES
(1, 1, 1, 5, 'La mejor paella de Valencia', 'Increíble experiencia gastronómica. La paella estaba perfecta, con el punto exacto de arroz y un sabor auténtico que te transporta a la Valencia tradicional. El azafrán se notaba de calidad y todos los ingredientes frescos.', 'Sabor auténtico, ingredientes frescos, cocción perfecta, ambiente familiar', 'Tiempo de espera un poco largo, pero vale la pena', 5, 5, 4, 4, 5, '2024-01-15', 'dine_in', 4, TRUE, TRUE),

(2, 3, 2, 5, 'Sashimi de calidad excepcional', 'Como chef, puedo asegurar que la calidad del pescado es excepcional. Fresco, bien cortado y presentado de manera impecable. El atún rojo se deshacía en la boca.', 'Pescado fresco, corte perfecto, presentación impecable', 'Precio elevado, pero justificado por la calidad', 5, 5, 3, 5, 4, '2024-01-20', 'dine_in', 2, TRUE, TRUE),

(3, 6, 3, 4, 'Auténtica pizza napoletana', 'Excelente pizza con masa perfecta y ingredientes de calidad. La mozzarella di bufala marca la diferencia. Ambiente acogedor y servicio atento.', 'Masa perfecta, ingredientes DOP, horno de leña', 'Un poco pequeña para el precio', 5, 4, 4, 4, 4, '2024-01-25', 'dine_in', 3, TRUE, TRUE),

(4, 7, 4, 4, 'Hamburguesa gourmet de calidad', 'Muy buena hamburguesa con carne de calidad y ingredientes frescos. El pan brioche estaba perfecto y las patatas caseras excelentes.', 'Carne de calidad, ingredientes frescos, patatas caseras', 'Un poco grasienta, ambiente ruidoso', 4, 4, 4, 3, 3, '2024-02-01', 'dine_in', 2, TRUE, TRUE);

-- Insertar posts de ejemplo
INSERT INTO posts (user_id, dish_id, restaurant_id, title, content, tags, post_type, likes_count, comments_count) VALUES
(1, 1, 1, '¡La mejor paella de mi vida! 🥘', 'Acabo de descubrir este tesoro escondido en Valencia. La Paella Dorada sirve la paella más auténtica que he probado en años. El arroz en su punto, el azafrán de calidad y ese sabor que solo se consigue con años de experiencia. ¡Totalmente recomendado! #PaellaValenciana #Valencia #ComidaTradicional', '["paella", "valencia", "tradicional", "recomendado"]', 'review', 23, 5),

(2, NULL, NULL, '¿Cuál es vuestro restaurante japonés favorito en Barcelona? 🍣', 'Estoy preparando una guía de los mejores restaurantes japoneses de Barcelona y me encantaría conocer vuestras recomendaciones. ¿Cuál ha sido vuestra mejor experiencia? ¿Algún lugar auténtico que no me pueda perder?', '["barcelona", "japones", "sushi", "recomendaciones"]', 'question', 15, 12),

(3, 5, 3, 'Comparativa: Las mejores carbonaras de Madrid', 'He estado probando carbonaras por toda la ciudad y tengo que decir que Trattoria Bella Vita está en el top 3. Auténtica receta romana, sin nata (como debe ser) y con un guanciale espectacular. ¿Cuál es vuestra carbonara favorita en Madrid?', '["carbonara", "madrid", "italiana", "comparativa"]', 'comparison', 31, 8),

(4, NULL, NULL, 'Tips para maridar vinos con comida asiática 🍷', 'Muchos piensan que el vino no va bien con la comida asiática, pero nada más lejos de la realidad. Un Riesling seco va perfecto con sushi, y un Pinot Noir ligero complementa maravillosamente el ramen. ¿Habéis probado algún maridaje interesante?', '["vino", "maridaje", "asiatica", "tips"]', 'tip', 18, 6);

-- Insertar comparaciones de precios
INSERT INTO dish_price_comparisons (dish_name, normalized_name, category) VALUES
('Paella Valenciana', 'paella_valenciana', 'Arroces'),
('Sashimi Variado', 'sashimi_variado', 'Japonesa'),
('Carbonara', 'carbonara', 'Pasta'),
('Hamburguesa Premium', 'hamburguesa_premium', 'Hamburguesas');

-- Insertar precios para comparación
INSERT INTO dish_prices (comparison_id, dish_id, restaurant_id, price, effective_date) VALUES
(1, 1, 1, 18.50, '2024-01-01'),
(2, 3, 2, 28.00, '2024-01-01'),
(3, 5, 3, 14.50, '2024-01-01'),
(4, 7, 4, 16.90, '2024-01-01');

-- Actualizar contadores
UPDATE users SET posts_count = 1, reviews_count = 1 WHERE id = 1;
UPDATE users SET posts_count = 1, reviews_count = 1 WHERE id = 2;
UPDATE users SET posts_count = 1, reviews_count = 1 WHERE id = 3;
UPDATE users SET posts_count = 1, reviews_count = 1 WHERE id = 4;

UPDATE restaurants SET review_count = 1 WHERE id IN (1, 2, 3, 4);
UPDATE dishes SET review_count = 1 WHERE id IN (1, 3, 5, 6, 7);
