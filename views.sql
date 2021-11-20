-- Создаем представление с информацией о необходимых сотрудниках
CREATE VIEW NEEDED_STAFF AS
SELECT s.service_name
FROM service s
         LEFT JOIN employee e ON s.medic_specialty_id = e.medic_specialty_id
WHERE e.medic_specialty_id IS NULL;
-- Проверяем
SELECT *
FROM NEEDED_STAFF;

-- Создаем представление с прайс-листом
CREATE VIEW PRICE_LIST AS
SELECT s.service_name, s.fix_price, s.min_time
FROM service s;
-- Проверяем
SELECT *
FROM PRICE_LIST;

-- Создаем представление со списком врачей
CREATE VIEW DOC_LIST AS
SELECT e.fio, ms.name, e.experience
FROM employee e
         INNER JOIN medic_specialty ms on ms.id = e.medic_specialty_id;
-- Проверяем
SELECT *
FROM DOC_LIST;