-- 0. Hozz létre egy adatbázist "healthylifestyle" néven és importáld be a users_data, diet_types, users_diet csv fileokat.
-- users_data:						diet_types:						users_diet:
	-- id - INT						id - INT						user_id - INT
    	-- first_name - TEXT					name - TEXT						diet_id - INT
    	-- last_name - TEXT
    	-- email - TEXT
    	-- gender - TEXT
    	-- height_cm - INT
    	-- weight_kg - INT
    
	CREATE SCHEMA `healthylifestyle` DEFAULT CHARACTER SET utf8 COLLATE utf8_hungarian_ci ;
    
    
-- 1. Állítsd be a Primary Key-t a users_data és diet_types táblák "id" oszlopára úgy, hogy automatikusan növekedjen egy új rekord hozzáadásával.


-- 2. Hány olyan ember szerepel az adatbázisban, akiknek nem tudjuk a nemét?
	SELECT COUNT(`id`) AS "felhasználók, akiknek nem tudjuk a nemét" FROM users_data
	WHERE `gender` LIKE "";


-- 3. Kik azok az emberek, akiknek nem tudjuk kiszámolni a BMI (Body Mass Index) értékét? (BMI = [kg] / [m]2)
	SELECT * FROM users_data
	WHERE `height_cm` = 0 OR `weight_kg` = 0;
    
    
-- 4. Az adatbázisban szereplő "Marietta Elverstone" neme rosszul van beállítva. Állítsd át "Female"-re.
	UPDATE users_data
    SET `gender` = "Female"
    WHERE `first_name` LIKE "Marietta" AND `last_name` LIKE "Elverstone";
    
    
-- 5. Az adatbázisban szereplő emberek hány százaléka nő?
	SELECT (COUNT(CASE WHEN `gender` LIKE "Female" THEN 1 END) / COUNT(`id`) * 100) AS "nők %-os aránya" FROM users_data;
		-- VAGY
	SELECT ((COUNT(if(`gender` LIKE "Female", 1, NULL))) / COUNT(`id`) * 100) AS "nők %-os aránya" FROM users_data;
		-- VAGY
	SELECT ((SELECT COUNT(`id`) FROM users_data WHERE `gender` LIKE "Female") / COUNT(`id`) * 100) AS "nők %-os aránya" FROM users_data ;
    
    
-- 6. Hány férfi és hány nő szerepel az adatbázisban? A két oszlop egymás mellett jelenjen meg "nők száma" és "férfiak száma" néven.
	SELECT COUNT(if(`gender` LIKE "Female", 1, NULL)) AS "nők száma", COUNT(if(`gender` LIKE "Male", 1, NULL)) AS "férfiak száma" FROM users_data;
    		-- VAGY
	SELECT (SELECT COUNT(`id`) FROM users_data WHERE `gender` LIKE "Female") AS "nők száma", (SELECT COUNT(`id`) FROM users_data WHERE `gender` LIKE "Male") AS "férfiak száma";
    
    
-- 7. Hány ember követ "Normál" étrendet? Az oszlop neve "normál étrendet követő emberek száma" legyen.
	SELECT COUNT(`users_data`.`id`) AS "normál étrendet követő emberek száma" FROM users_data
    JOIN users_diet ON users_data.id = users_diet.user_id
    JOIN diet_types ON users_diet.diet_id = diet_types.id
    WHERE `diet_types`.`name` LIKE "Normal";


-- 8. Kik azok a férfiak, akik "Normál" étrendet követnek és a súlyuk legalább 95 kg? Csak a teljes nevük, magasságuk és súlyuk jelenjen meg, rendezd őket magasságuk szerint csökkenő sorrendbe.
	SELECT CONCAT_WS(" ", `users_data`.`first_name`, `users_data`.`last_name`) AS "full name", `users_data`.`height_cm`, `users_data`.`weight_kg` FROM users_data
    JOIN users_diet ON users_data.id = users_diet.user_id
    JOIN diet_types ON users_diet.diet_id = diet_types.id
    WHERE `users_data`.`gender` LIKE "Male" AND `diet_types`.`name` LIKE "Normal" AND `users_data`.`weight_kg` >= 95
    ORDER BY `users_data`.`height_cm` DESC;


-- 9. Hányan követnek tejmentes vagy cukormentes étrendet? Az oszlop neve "tej vagy cukormentes étrendet követő emberek száma" legyen.
	SELECT COUNT(DISTINCT `users_data`.`id`) AS "Tej vagy cukormentes étrendet követő emberek száma" FROM users_data
    JOIN users_diet ON users_data.id = users_diet.user_id
    JOIN diet_types ON users_diet.diet_id = diet_types.id
    WHERE `diet_types`.`name` LIKE "No milk" OR `diet_types`.`name` LIKE "No sugar";
    
		-- Ezt hogyan tudnánk megoldani ÉS kapcsolattal? (Van benne egy ember, aki mind a kettőt követi.)


-- 10. Az adatbázisban szereplő emberek hány százaléka vegán vagy vegetáriánus?
	SELECT (COUNT(if(`diet_types`.`name` LIKE "veg%", 1, NULL)) / COUNT(DISTINCT `users_data`.`id`) * 100) AS "vegánok vagy vegetáriánusok %-os aránya" FROM users_data
    LEFT JOIN users_diet ON users_data.id = users_diet.user_id
    LEFT JOIN diet_types ON users_diet.diet_id = diet_types.id;


-- 11. Melyik 3 embernek a legmagasabb a BMI értéke? A lekérdezésben az id-juk, nevük, nemük, magasságuk, súlyuk és BMI indexük jelenjen meg. (BMI = [kg] / [m]2)
	SELECT `id`, CONCAT_WS(" ", `first_name`, `last_name`) AS "full name", `gender`, `height_cm`, `weight_kg`, (`weight_kg` / ((`height_cm` / 100)* (`height_cm` / 100))) AS "BMI" FROM users_data
    ORDER BY `BMI` DESC
    LIMIT 3;


-- 12. Hány ember követ egy-egy étrendet? (Normal - X, Vegetarian - Y, Vegan - Z...stb) Majd rendezd őket étrend id szerint növekvő sorrendbe. A lekérdezésben az étrend id-ja és neve mellett szerepeljen, hogy hányan követik az adott étrendet.
	SELECT `diet_types`.`id`, `diet_types`.`name`, COUNT(`users_diet`.`user_id`) AS "ennyi ember követi" FROM users_data
    JOIN users_diet ON users_data.id = users_diet.user_id
    JOIN diet_types ON users_diet.diet_id = diet_types.id
    GROUP BY `diet_types`.`name`
	ORDER BY `diet_types`.`id`;


-- 13. Melyik étrendet követik a legtöbben? A lekérdezésben csak az étrend neve és a követői száma szerepeljen.
	SELECT `diet_types`.`name`, COUNT(`users_diet`.`user_id`) AS "ennyi ember követi" FROM users_data
    JOIN users_diet ON users_data.id = users_diet.user_id
    JOIN diet_types ON users_diet.diet_id = diet_types.id
    GROUP BY `diet_types`.`name`
	ORDER BY 2 DESC
    LIMIT 1;


-- 14. Kik azok az emberek, akik nem követnek semmilyen étrendet, de szerepelnek az adatbázisban?
	SELECT * FROM users_data
    LEFT JOIN users_diet ON users_data.id = users_diet.user_id
    WHERE `users_diet`.`diet_id` IS NULL OR users_diet.diet_id LIKE "";


-- 15. Melyik az az étrend, amelyet egy ember sem követ? A lekérdezésben az étrend id-ja és neve jelenjen meg.
	SELECT `diet_types`.`id`, `diet_types`.`name` FROM users_data
	RIGHT JOIN users_diet ON users_data.id = users_diet.user_id
	RIGHT JOIN diet_types ON users_diet.diet_id = diet_types.id
	WHERE `users_diet`.`user_id` IS NULL OR `users_diet`.`user_id` LIKE "";
