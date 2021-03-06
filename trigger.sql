-- Создадим триггер для создания записи в мед.карте во время создания приема
CREATE OR REPLACE FUNCTION insert_medical_history() RETURNS TRIGGER
    LANGUAGE plpgsql AS
$$
BEGIN
    INSERT INTO medical_history(client_id, appointment_id) VALUES (NEW.client_id, NEW.id);
    RETURN NEW;
END;
$$;

-- Вешаем триггер на таблицу приемов
CREATE TRIGGER update_medical_history
    AFTER INSERT
    ON appointment
    FOR EACH ROW
EXECUTE PROCEDURE insert_medical_history();

-- Проверяем
INSERT INTO appointment(client_id, employee_id, service_id, time, office, note)
VALUES (1, 1, 1, now() + interval '1 hour', 'cabtr', null)