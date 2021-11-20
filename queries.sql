-- Получить всех врачей и услуги, которые они предоставляют
SELECT e.id,
       e.fio,
       service_name
FROM service s
         INNER JOIN employee e ON s.medic_specialty_id = e.medic_specialty_id;

-- Получить всех сотрудников с сортировкой по зарплате
SELECT e.fio,
       p.salary
FROM employee e
         INNER JOIN position p ON p.id = e.position_id
ORDER BY p.salary DESC;

-- Получить список всех услуг в поликлинике
SELECT s.service_name,
       e.fio
FROM service s
         LEFT JOIN employee e ON s.medic_specialty_id = e.medic_specialty_id;

-- Получить все должности клиники
SELECT p.name,
       p.salary,
       e.fio
FROM position p
         RIGHT JOIN employee e ON p.id = e.position_id;

-- Получить сумму зарплату всех врачей
SELECT SUM(p.salary)
FROM position p
         INNER JOIN employee e ON p.id = e.position_id
WHERE e.medic_specialty_id IS NOT NULL
GROUP BY CASE WHEN e.medic_specialty_id IS NULL THEN 'NULL' ELSE 'NOT NULL' END;

-- Получить список всех специальностей и всех услуг
SELECT ms.name
FROM medic_specialty ms
UNION ALL
SELECT s.service_name
FROM service s;

-- Получить всех врачей, на которых назначено больше одной записи
SELECT e.fio
FROM employee e
WHERE e.id IN ((SELECT a.employee_id
                FROM appointment a
                GROUP BY a.employee_id
                HAVING COUNT(a.employee_id) > 1));

-- Получить мед.карту Бойцовой Любомилы Игоревны
SELECT c.fio,
       em.fio,
       s.service_name
FROM medical_history m
         INNER JOIN client c ON c.id = m.client_id
         INNER JOIN appointment e ON e.id = m.appointment_id
         INNER JOIN employee em ON em.id = e.employee_id
         INNER JOIN service s ON s.id = e.service_id
WHERE m.client_id = (
    SELECT id
    FROM client
    WHERE fio = 'Бойцова Любомила Игоревна');

-- Получить список всех клиентов, у которых был хотя бы один прием
SELECT c.fio
FROM client c
         INNER JOIN appointment a ON c.id = a.client_id
GROUP BY c.fio;

-- Получить список всех сотрудников с должностями
SELECT e.fio,
       p.name,
       p.salary,
       ms.name,
       e.experience
FROM employee e
         INNER JOIN position p ON p.id = e.position_id
         LEFT JOIN medic_specialty ms ON ms.id = e.medic_specialty_id
ORDER BY e.fio;

-- Получить сумму ежемесячных выплат по зарплатам
SELECT SUM(p.salary)
FROM employee e
         INNER JOIN position p ON p.id = e.position_id;

-- Получить средний стаж всех сотруднков
SELECT AVG(e.experience)
FROM employee e;

-- Получить представленные в клинике специальности
SELECT ms.name
FROM medic_specialty ms
         INNER JOIN employee e ON ms.id = e.medic_specialty_id;

-- Получить среднюю стоимость услуг по каждому клиенту
SELECT c.fio,
       AVG(s.fix_price::numeric)
FROM medical_history mh
         INNER JOIN appointment a ON a.id = mh.appointment_id
         INNER JOIN service s ON s.id = a.service_id
         INNER JOIN client c on c.id = mh.client_id
GROUP BY mh.client_id, c.fio;


-- Список услуг, для которых необходимо нанять специалистов
SELECT s.service_name
FROM service s
         LEFT JOIN employee e ON s.medic_specialty_id = e.medic_specialty_id
WHERE e.medic_specialty_id IS NULL;