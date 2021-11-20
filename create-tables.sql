-- Создание таблицы клиентов
CREATE TABLE client
(
    id           SERIAL PRIMARY KEY,
    fio          TEXT NOT NULL,
    birth_date   DATE NOT NULL,
    home_address TEXT,
    phone_number CHAR(10)
);

COMMENT ON TABLE client IS 'Клиенты клиники';

COMMENT ON COLUMN client.id IS 'Уникальный идентификатор клиента';

COMMENT ON COLUMN client.fio IS 'ФИО клиента';

COMMENT ON COLUMN client.birth_date IS 'Дата рождения клиента';

COMMENT ON COLUMN client.home_address IS 'Место жительства клиента';

COMMENT ON COLUMN client.phone_number IS 'Мобильный телефон клиента';

-- Создание таблицы специальностей врачей
CREATE TABLE medic_specialty
(
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

COMMENT ON TABLE medic_specialty IS 'Специальности врачей в клинике';

COMMENT ON COLUMN medic_specialty.id IS 'Уникальный идентификатор специальности';

COMMENT ON COLUMN medic_specialty.name IS 'Название специальности';

-- Создание таблицы услуг
CREATE TABLE service
(
    id                 SERIAL PRIMARY KEY,
    medic_specialty_id INT   NOT NULL,
    service_name       TEXT,
    fix_price          MONEY NOT NULL,
    min_time           INT DEFAULT 0,

    FOREIGN KEY (medic_specialty_id)
        REFERENCES medic_specialty (id)
        ON DELETE CASCADE
);

COMMENT ON TABLE service IS 'Услуги, предоставляемые клиникой';

COMMENT ON COLUMN service.id IS 'Уникальный идентификатор услуги';

COMMENT ON COLUMN service.medic_specialty_id IS 'Идентификатор специальности, к которой относится услуга';

COMMENT ON COLUMN service.service_name IS 'Название услуги';

COMMENT ON COLUMN service.fix_price IS 'Базовая цена за услугу';

COMMENT ON COLUMN service.min_time IS 'Минимальное время процедуры';

-- Создание таблицы должностей
CREATE TABLE position
(
    id     SERIAL PRIMARY KEY,
    name   TEXT  NOT NULL,
    salary MONEY NOT NULL
);

COMMENT ON TABLE position IS 'Таблица должностей';

COMMENT ON COLUMN position.id IS 'Уникальный идентификатор должности';

COMMENT ON COLUMN position.name IS 'Название должности';

COMMENT ON COLUMN position.salary IS 'Оклад';

-- Создание таблицы сотрудников
CREATE TABLE employee
(
    id                 SERIAL PRIMARY KEY,
    fio                TEXT NOT NULL,
    medic_specialty_id INT,
    birth_date         DATE,
    experience         INT  NOT NULL,
    position_id        INT,

    FOREIGN KEY (medic_specialty_id)
        REFERENCES medic_specialty (id),
    FOREIGN KEY (position_id)
        REFERENCES position (id)
);

COMMENT ON TABLE employee IS 'Сотрудники клиники';

COMMENT ON COLUMN employee.id IS 'Уникальный идентификатор сотрудника';

COMMENT ON COLUMN employee.fio IS 'ФИО сотрудника';

COMMENT ON COLUMN employee.medic_specialty_id IS 'Специальность сотрудника (только у врачей)';

COMMENT ON COLUMN employee.birth_date IS 'Дата рождения сотрудника';

COMMENT ON COLUMN employee.experience IS 'Стаж сотрудника';

COMMENT ON COLUMN employee.position_id IS 'Должность сотрудника';

-- Создание таблицы записей
CREATE TABLE appointment
(
    id          SERIAL PRIMARY KEY,
    client_id   INT                       NOT NULL,
    employee_id INT                       NOT NULL,
    service_id  INT                       NOT NULL,
    time        timestamptz DEFAULT now() NOT NULL,
    office      VARCHAR(5)                NOT NULL,
    note        TEXT,

    FOREIGN KEY (client_id)
        REFERENCES client (id)
        ON DELETE RESTRICT,
    FOREIGN KEY (employee_id)
        REFERENCES employee (id)
        ON DELETE RESTRICT,
    FOREIGN KEY (service_id)
        REFERENCES service (id)
        ON DELETE RESTRICT
);

COMMENT ON TABLE appointment IS 'Записи на прием';

COMMENT ON COLUMN appointment.id IS 'Уникальный идентификатор приема';

COMMENT ON COLUMN appointment.client_id IS 'Идентификатор клиента';

COMMENT ON COLUMN appointment.employee_id IS 'Идентификатор врача';

COMMENT ON COLUMN appointment.service_id IS 'Идентификатор услуги';

COMMENT ON COLUMN appointment.time IS 'Время приема';

COMMENT ON COLUMN appointment.office IS 'Кабинет';

COMMENT ON COLUMN appointment.note IS 'Примечания к приему';

-- Создание таблицы мед.карт
CREATE TABLE medical_history
(
    id             SERIAL PRIMARY KEY,
    client_id      INT NOT NULL,
    appointment_id INT NOT NULL,
    prognosis      TEXT,

    FOREIGN KEY (client_id)
        REFERENCES client (id)
        ON DELETE CASCADE,
    FOREIGN KEY (appointment_id)
        REFERENCES appointment (id)
        ON DELETE RESTRICT
);

COMMENT ON TABLE medical_history IS 'Медицинская карта клиента';

COMMENT ON COLUMN medical_history.id IS 'Уникальный идентификатор медицинской карты';

COMMENT ON COLUMN medical_history.client_id IS 'Идентификатор клиента';

COMMENT ON COLUMN medical_history.appointment_id IS 'Идентификатор приема';

COMMENT ON COLUMN medical_history.prognosis IS 'Эпикриз';