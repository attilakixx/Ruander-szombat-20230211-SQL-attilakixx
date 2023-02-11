-- Készítettem dog_adoption néven egy adatbázist
-- 3 tábla van benne: - dog
--                    - owner
--                    - basic_vaccination
-- A táblák kapcsolata: `dog.transponder` kapcsolódik a `basic_vaccination.transponder` - hez
--                      'dog.owner_id' kapcsolódik 'owner.owner_id' - hez
 -- feladatok
-- 1  Listázd ki azokat a kutyákat, amelyek még örökbe fogadhatóak. A nevük legyen "free dog".

SELECT *
FROM dog
WHERE dog.status = 2;

-- 2. Számold össze, hány fekete kutyának van gazdája.

SELECT count(id) AS "Gazdis fekete kutyák"
FROM dog
WHERE color like "black"
  AND dog.status =1;

-- 3. Listázd ki, azokat a barna és közepes testű kutyákat, amiknek hiányzik valamelyik oltása.

SELECT *
FROM dog
INNER JOIN basic_vaccination ON basic_vaccination.transponder = dog.transponder
WHERE basic_vaccination.distemper =2
  OR `hepatitis(CVH)` = 2
  OR leptospirosis = 2
  OR parvovirosis = 2
  OR rabies =2;

-- 4. Számold ki, hogy átlagosan a fiatalabb, vagy az idősebb kutyákat adoptálják.
-- 5. Listázd ki azokat a kutyákat, akik a 2022-es évben születtek és van veszettségi (rabies) és szopornyica (distemper) elleni oltásuk.
-- 6.Listázd ki a gazdikat legyen a neve "teljes név" és a hozzájuk tartozó kutyák nevét (adoptált és foglaltak is).
-- 7.Listázd ki a 2022 előtt született kis testű, fehér kutyákat.
-- 8.Melyik gazdátlan nőstény kutyának van a legkevesebb oltása?
-- 9.Hány százaléka gazdis vagy foglalt a barna és közepes testű kutyáknak?
-- 10.Tedd csökkenő sorrendbe a gazdátlan, hím kutyákat, akik 2017 és 2019 között születtek.
-- 11.Egy olyan kutyát szeretnék, amelyik nem idősebb 2 évesnél, nőstény és kistermetű, legyen legalább 3 oltása.
-- 12.Melyik évben született kutyáknak van a legtöbb oltásuk?
-- 13.Doris Herald kutyájának hány oltása van?
-- 14.Listázd ki, hogy a keverék kutyákon kívül, milyen kutyákat tudnak még örökbe fogadni.
-- 15.Melyik a legidősebb kutya, amit lefoglaltak?