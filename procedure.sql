-- Создаем хранимую процедуру для получения сотрудников с указанной или выше зарплатой
CREATE OR REPLACE FUNCTION find_employees_with_indicated_salary(employeeSalary NUMERIC)
    RETURNS SETOF INT
    LANGUAGE plpgsql AS
$$
DECLARE
    employee_id int;
BEGIN

    FOR employee_id IN SELECT e.id
                       FROM employee e
                                INNER JOIN position p ON p.id = e.position_id
                       WHERE p.salary::numeric >= employeeSalary
        LOOP
            RETURN NEXT employee_id;
        END LOOP;
END
$$;

-- Проверяем
SELECT e.fio
FROM employee e
WHERE e.id IN (SELECT * FROM find_employees_with_indicated_salary(80000::NUMERIC));