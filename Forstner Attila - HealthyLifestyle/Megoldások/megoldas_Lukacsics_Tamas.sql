-- 2. Hány olyan ember szerepel az adatbázisban, akiknek nem tudjuk a nemét?

SELECT count(id) AS "Emberek akinek a neme nincs kitöltve" FROM data
WHERE gender LIKE "" OR gender IS NULL;

-- 3. Kik azok az emberek, akiknek nem tudjuk kiszámolni a BMI (Body Mass Index) értékét? (BMI = [kg] / [m]2)

SELECT count(id) AS "Emberek kiszámíthatatlan BMI értékkel" FROM data
WHERE height IS NULL OR height=0 OR weight IS NULL OR weight=0;

-- 4. Az adatbázisban szereplő "Marietta Elverstone" neme rosszul van beállítva. Állítsd át "Female"-re.

UPDATE `healthylifestyle`.`data` SET `gender` = 'Female'
WHERE (`id` = (SELECT id FROM data WHERE first_name LIKE "Marietta" AND last_name LIKE "Elverstone"));

-- 5. Az adatbázisban szereplő emberek hány százaléka nő?

SELECT ((SELECT COUNT(id) FROM data WHERE gender LIKE "Female")/COUNT(id))*100 AS "Nők aránya %-ban" FROM data;

-- 6. Hány férfi és hány nő szerepel az adatbázisban? A két oszlop egymás mellett jelenjen meg "nők száma" és "férfiak száma" néven.

SELECT (SELECT COUNT(id) FROM data WHERE gender LIKE "Female") AS "Nők száma" , (SELECT COUNT(id) FROM data
WHERE gender LIKE "Male") AS "Férfiak száma" FROM data
LIMIT 1;
    
-- 7. Hány ember követ "Normál" étrendet? Az oszlop neve "normál étrendet követő emberek száma" legyen.

SELECT COUNT(data.id) AS "Normál étrendet követő emberek száma" FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
WHERE diet_types.name LIKE "Normal"; 

-- 8. Kik azok a férfiak, akik "Normál" étrendet követnek és a súlyuk legalább 95 kg? Csak a teljes nevük, magasságuk és súlyuk jelenjen meg, rendezd őket magasságuk szerint csökkenő sorrendbe.

SELECT CONCAT_WS(" ",First_name,Last_name) AS "Teljes név",weight,height FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
WHERE diet_types.name LIKE "Normal" AND weight>95
ORDER BY height DESC;

-- 9. Hányan követnek tejmentes vagy cukormentes étrendet? Az oszlop neve "tej vagy cukormentes étrendet követő emberek száma" legyen.

SELECT COUNT(data.id) AS "Tej vagy cukormentes étrendet követő emberek száma" FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
WHERE diet_types.name LIKE "No sugar" OR diet_types.name LIKE "No milk"; 

-- 10. Az adatbázisban szereplő emberek hány százaléka vegán vagy vegetáriánus?

SELECT ((SELECT COUNT(data.id) FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
WHERE diet_types.name LIKE "Vegan" OR diet_types.name LIKE "Vegetarian")/(COUNT(id)))*100  AS "Vegán vagy vegetáriánus emberek százalékban megadva" FROM data; 

-- 11. Melyik 3 embernek a legmagasabb a BMI értéke? A lekérdezésben az id-juk, nevük, nemük, magasságuk, súlyuk és BMI indexük jelenjen meg. (BMI = [kg] / [m]2)

SELECT id,CONCAT_WS(" ",First_name,Last_name) AS "Teljes név",gender,height,weight,(weight/sqrt(height/100)) AS "BMI" FROM data
ORDER BY 6 DESC
LIMIT 3;

-- 12. Hány ember követ egy-egy étrendet? (Normal - X, Vegetarian - Y, Vegan - Z...stb) Majd rendezd őket étrend id szerint növekvő sorrendbe. A lekérdezésben az étrend id-ja és neve mellett szerepeljen, hogy hányan követik az adott étrendet.

SELECT diet_types.id,diet_types.name,COUNT(data.id) AS "Diétát követők száma" FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
GROUP BY diet_types.name
ORDER BY diet_types.id
;

-- 13. Melyik étrendet követik a legtöbben? A lekérdezésben csak az étrend neve és a követői száma szerepeljen.

SELECT Counting.name,MAX(Counting.Users) "Diétát követők száma" FROM (
SELECT  diet_types.name,COUNT(data.id) AS "Users" FROM data
INNER JOIN diet ON data.id=diet.user_id
INNER JOIN diet_types ON diet.diet_id=diet_types.id
GROUP BY diet_types.name
ORDER BY 2 DESC
) Counting
;
-- Megkérdez miért hibás

-- 14. Kik azok az emberek, akik nem követnek semmilyen étrendet, de szerepelnek az adatbázisban?

SELECT CONCAT_WS(" ",First_name,Last_name) AS "Teljes név" FROM data WHERE id=ANY
(SELECT id FROM data
EXCEPT
SELECT user_id FROM diet);

-- 15. Melyik az az étrend, amelyet egy ember sem követ? A lekérdezésben az étrend id-ja és neve jelenjen meg.

SELECT id,name FROM diet_types WHERE id=ANY
(SELECT id FROM diet_types
EXCEPT
SELECT diet_id FROM diet);
