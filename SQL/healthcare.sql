
-- Create schema
CREATE SCHEMA healthcare;
SET search_path = healthcare, public;
-- ============================================
-- Lookup tables
-- ===========================================
-- User roles
CREATE TABLE healthcare.users_types(
    role_id serial PRIMARY KEY,
    role_type TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.users_types (role_type) 
VALUES ('doctor'),('patient'),('pharmacy'),('lab');
-- Gender types
CREATE TABLE healthcare.gender_types (
    gender_id SERIAL PRIMARY KEY,
    gender TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.gender_types (gender) VALUES
('male'), ('female'), ('other');
-- Appointment status
CREATE TABLE healthcare.appointment_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.appointment_status_types (status) VALUES
('scheduled'), ('checked_in'), ('cancelled'), ('rescheduled'), ('completed');
-- Prescription status
CREATE TABLE healthcare.prescription_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.prescription_status_types (status) VALUES
('draft'), ('issued'), ('cancelled');
-- Lab type lookup
CREATE TABLE healthcare.lab_type_lookup (
    lab_type_id SERIAL PRIMARY KEY,
    lab_type TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.lab_type_lookup (lab_type) VALUES
('radiology'),('pathology'),('microbiology'),
('cardiology_diagnostics'),('neurology_diagnostics'),('general_diagnostics');
-- Lab status types
CREATE TABLE healthcare.lab_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.lab_status_types (status) VALUES
('ordered'), ('in_progress'), ('completed'), ('cancelled');
-- Order status types
CREATE TABLE healthcare.order_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.order_status_types (status) VALUES
('placed'), ('processing'), ('dispatched'), ('delivered'), ('cancelled');
-- Payment status types
CREATE TABLE healthcare.payment_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.payment_status_types (status) VALUES
('pending'), ('paid'), ('failed'), ('refunded');
-- Visit types (OPD/IPD)
CREATE TABLE healthcare.visit_types (
    visit_type_id SERIAL PRIMARY KEY,
    visit_type TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.visit_types (visit_type) VALUES ('OPD'), ('IPD');
-- IPD status types
CREATE TABLE healthcare.ipd_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.ipd_status_types (status)
VALUES
    ('admitted'),
    ('under_treatment'),
    ('observation'),
    ('transferred'),
    ('discharged'),
    ('cancelled');
--=============currency codes
create table healthcare.currency_codes (
	currency_code_id serial primary key,
	currency_code varchar(3) not null default 'INR',
	currency_name VARCHAR(50) NOT NULL
);
INSERT INTO healthcare.currency_codes 
(currency_code, currency_name)
VALUES
('INR', 'Indian Rupee'),
('USD', 'US Dollar'),
('EUR', 'Euro'),
('GBP', 'British Pound Sterling'),
('JPY', 'Japanese Yen'),
('AUD', 'Australian Dollar'),
('CAD', 'Canadian Dollar'),
('CHF', 'Swiss Franc'),
('CNY', 'Chinese Yuan'),
('AED', 'UAE Dirham');
--insurance claim status type
CREATE TABLE healthcare.insurance_claim_status_types (
    status_id SERIAL PRIMARY KEY,
    status TEXT UNIQUE NOT NULL
);
INSERT INTO healthcare.insurance_claim_status_types (status) VALUES
('draft'), ('submitted'), ('in_review'), ('approved'), ('rejected'), ('settled'), ('cancelled');
--==============payment methods
CREATE TABLE healthcare.payment_methods (
  	payment_method_id SERIAL PRIMARY KEY,
    method TEXT NOT NULL UNIQUE
);

INSERT INTO healthcare.payment_methods (method) VALUES
('Cash'),('Credit Card'),('Debit Card'),('UPI');


-- ============================================
-- Core entities
-- ============================================
-- Users table
CREATE TABLE healthcare.users (
    user_id BIGSERIAL PRIMARY KEY,
    role_id INT REFERENCES healthcare.users_types(role_id) ON DELETE RESTRICT,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    email TEXT UNIQUE,
	country_code varchar(3) not null default '+91',
    phone varchar(15) UNIQUE,
	is_active boolean DEFAULT 'true',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    active_since TIMESTAMPTZ default now()
);
-- Patients
CREATE TABLE healthcare.patients (
    patient_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES healthcare.users(user_id) ON DELETE RESTRICT,
    first_name TEXT NOT NULL,
    last_name TEXT,
    dob DATE,
    gender_id INT REFERENCES healthcare.gender_types(gender_id) ON DELETE RESTRICT,
    address JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
-- Doctors
CREATE TABLE healthcare.departments (
    department_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.doctors (
    doctor_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES healthcare.users(user_id) ON DELETE RESTRICT,
    department_id INT REFERENCES healthcare.departments(department_id) ON DELETE RESTRICT,
    first_name TEXT NOT NULL,
    last_name TEXT,
    specialization TEXT,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    consultation_fee NUMERIC(10,2) DEFAULT 0,
    available_slots JSONB DEFAULT '[]'::jsonb,
    booked_slots JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
-- ============================================
-- Appointments (with visit_type )
-- ============================================
CREATE TABLE healthcare.appointments (
    appointment_id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES healthcare.patients(patient_id) ON DELETE RESTRICT,
    doctor_id BIGINT REFERENCES healthcare.doctors(doctor_id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMPTZ NOT NULL,
    reason TEXT,
    status_id INT REFERENCES healthcare.appointment_status_types(status_id) ON DELETE RESTRICT,
    visit_type_id INT REFERENCES healthcare.visit_types(visit_type_id) ON DELETE RESTRICT DEFAULT 1, -- default OPD
    parent_appointment_id BIGINT REFERENCES healthcare.appointments(appointment_id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
--===============doctor invoice &payments
CREATE TABLE healthcare.doctor_consultancy_invoices (
    invoice_id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT REFERENCES healthcare.appointments(appointment_id) ON DELETE RESTRICT,
    discount NUMERIC(5,2) DEFAULT 0,       -- discount in %
    credit_applied NUMERIC(12,2) DEFAULT 0,
	total_amount NUMERIC(14,2) DEFAULT 0,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    issued_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.doctor_consultancy_payments (
    payment_id BIGSERIAL PRIMARY KEY,
    invoice_id BIGINT REFERENCES healthcare.doctor_consultancy_invoices(invoice_id) ON DELETE RESTRICT,
    currency_id INT REFERENCES healthcare.currency_codes(currency_code_id) ON DELETE RESTRICT DEFAULT 1,
    paid_amount NUMERIC(14,2) NOT NULL,
    payment_method_id INT REFERENCES healthcare.payment_methods(payment_method_id) ON DELETE RESTRICT,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    transaction_ref TEXT,
    paid_at TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- IPD Admissions Table & insurances
-- ============================================
CREATE TABLE healthcare.ipd_admissions (
    admission_id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT unique REFERENCES healthcare.appointments(appointment_id) ON DELETE RESTRICT,
    admission_time TIMESTAMPTZ NOT NULL DEFAULT now(),
    discharge_time TIMESTAMPTZ,
    ipd_status_id INT REFERENCES healthcare.ipd_status_types(status_id) ON DELETE RESTRICT DEFAULT 1, -- admitted
    room_details JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.insurance_providers (
    provider_id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
	email TEXT UNIQUE,
	country_code varchar(3) not null default '+91',
    phone varchar(15) UNIQUE,
    address JSONB,                -- phone / email / address as JSON
    website TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.patient_insurance_policies (
    policy_id BIGSERIAL PRIMARY KEY,
    provider_id BIGINT REFERENCES healthcare.insurance_providers(provider_id) ON DELETE RESTRICT,
    coverage_details JSONB,       -- limits, covered services, notes
    valid_from DATE,
    valid_to DATE,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.insurance_claims (
    claim_id BIGSERIAL PRIMARY KEY,
    admission_id BIGINT REFERENCES healthcare.ipd_admissions(admission_id) ON DELETE RESTRICT, -- the IPD admission being claimed
    policy_id BIGINT REFERENCES healthcare.patient_insurance_policies(policy_id) ON DELETE RESTRICT,
    claim_status_id INT REFERENCES healthcare.insurance_claim_status_types(status_id) ON DELETE RESTRICT,
    claimed_amount NUMERIC(14,2) DEFAULT 0,
    approved_amount NUMERIC(14,2),
    submitted_at TIMESTAMPTZ,
    approved_at TIMESTAMPTZ
);
CREATE TABLE healthcare.ipd_invoices (
    ipd_invoice_id BIGSERIAL PRIMARY KEY,
    admission_id BIGINT REFERENCES healthcare.ipd_admissions(admission_id) ON DELETE RESTRICT,
    currency_id INT REFERENCES healthcare.currency_codes(currency_code_id) ON DELETE RESTRICT DEFAULT 1,
    room_charges NUMERIC(12,2) DEFAULT 0,
    procedure_charges NUMERIC(12,2) DEFAULT 0,
    credit_applied NUMERIC(12,2) DEFAULT 0,
	--discount NUMERIC(12,2) DEFAULT 0,       -- discount in %
    insurance_covered_amount NUMERIC(12,2) DEFAULT 0,
	total_amount NUMERIC(14,2) DEFAULT 0,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    issued_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
); 
CREATE TABLE healthcare.ipd_invoice_payments (
    payment_id BIGSERIAL PRIMARY KEY,
    ipd_invoice_id BIGINT REFERENCES healthcare.ipd_invoices(ipd_invoice_id) ON DELETE RESTRICT,
    paid_amount NUMERIC(14,2) NOT NULL,
    payment_method_id INT REFERENCES healthcare.payment_methods(payment_method_id) ON DELETE RESTRICT,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    transaction_ref TEXT,
    paid_at TIMESTAMPTZ ,
    created_at TIMESTAMPTZ DEFAULT now(),
    notes TEXT
);
-- ============================================
-- Prescriptions & Medicines
-- ============================================
CREATE TABLE healthcare.prescriptions (
    prescription_id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT REFERENCES healthcare.appointments(appointment_id) ON DELETE RESTRICT,
    notes TEXT,
    status_id INT REFERENCES healthcare.prescription_status_types(status_id) ON DELETE RESTRICT,
    issued_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.medicines (
    medicine_id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    composition TEXT,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    unit_price NUMERIC(10,2) NOT NULL DEFAULT 0,
    active_till TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.prescription_items (
    prescription_item_id BIGSERIAL PRIMARY KEY,
    prescription_id BIGINT REFERENCES healthcare.prescriptions(prescription_id) ON DELETE RESTRICT,
    medicine_id BIGINT REFERENCES healthcare.medicines(medicine_id) ON DELETE RESTRICT,
    strength TEXT,
    dosage_instructions TEXT,
    duration_days INT,
    qty TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
-- ============================================
-- Pharmacies
-- ============================================
CREATE TABLE healthcare.pharmacies (
    pharmacy_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES healthcare.users(user_id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    address JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.pharmacy_orders (
    pharmacy_order_id BIGSERIAL PRIMARY KEY,
    pharmacy_id BIGINT REFERENCES healthcare.pharmacies(pharmacy_id) ON DELETE RESTRICT,
    patient_id BIGINT REFERENCES healthcare.patients(patient_id) ON DELETE RESTRICT,
    prescription_id BIGINT REFERENCES healthcare.prescriptions(prescription_id) ON DELETE RESTRICT,
    order_status_id INT REFERENCES healthcare.order_status_types(status_id) ON DELETE RESTRICT,
	currency  int references healthcare.currency_codes(currency_code_id) default 1,
    total_amount NUMERIC(12,2) DEFAULT 0,
    placed_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.pharmacy_order_items (
    pharmacy_order_item_id BIGSERIAL PRIMARY KEY,
    pharmacy_order_id BIGINT REFERENCES healthcare.pharmacy_orders(pharmacy_order_id) ON DELETE RESTRICT,
    medicine_id BIGINT REFERENCES healthcare.medicines(medicine_id) ON DELETE RESTRICT,
    qty INT DEFAULT 1,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    unit_price NUMERIC(10,2) DEFAULT 0,
    line_total NUMERIC(12,2)
);
CREATE TABLE healthcare.pharmacy_order_invoices (
    pharmacy_invoice_id BIGSERIAL PRIMARY KEY,
    pharmacy_order_id BIGINT REFERENCES healthcare.pharmacy_orders(pharmacy_order_id) ON DELETE RESTRICT,
    -- pharmacy_id BIGINT REFERENCES healthcare.pharmacies(pharmacy_id) ON DELETE RESTRICT,
    currency_id INT REFERENCES healthcare.currency_codes(currency_code_id) ON DELETE RESTRICT DEFAULT 1,
    subtotal NUMERIC(14,2) DEFAULT 0,
    shipping_charge NUMERIC(14,2) DEFAULT 0,
	discount NUMERIC(5,2) DEFAULT 0,       -- discount in %
    credit_applied NUMERIC(14,2) DEFAULT 0,
	total_amount NUMERIC(14,2) DEFAULT 0,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    issued_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.pharmacy_invoice_payments (
    payment_id BIGSERIAL PRIMARY KEY,
    pharmacy_invoice_id BIGINT REFERENCES healthcare.pharmacy_order_invoices(pharmacy_invoice_id) ON DELETE RESTRICT,
    paid_amount NUMERIC(14,2) NOT NULL,
    payment_method_id INT REFERENCES healthcare.payment_methods(payment_method_id) ON DELETE RESTRICT,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    transaction_ref TEXT,
    paid_at TIMESTAMPTZ ,
    created_at TIMESTAMPTZ DEFAULT now(),
    notes TEXT
);
-- ============================================
-- Labs 
-- ============================================
CREATE TABLE healthcare.labs (
    lab_id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE REFERENCES healthcare.users(user_id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    address JSONB,
    lab_type_id INT REFERENCES healthcare.lab_type_lookup(lab_type_id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.lab_tests (
    lab_test_id BIGSERIAL PRIMARY KEY,
	lab_id BIGINT REFERENCES healthcare.labs(lab_id) ON DELETE RESTRICT,
    name TEXT NOT NULL,
    description TEXT,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    price NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.lab_orders (
    lab_order_id BIGSERIAL PRIMARY KEY,
    lab_id INT REFERENCES healthcare.labs(lab_id) ON DELETE RESTRICT,
    appointment_id BIGINT REFERENCES healthcare.appointments(appointment_id) ON DELETE RESTRICT,
    status_id INT REFERENCES healthcare.lab_status_types(status_id) ON DELETE RESTRICT,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    total_amount NUMERIC(12,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.lab_order_items (
    lab_order_item_id BIGSERIAL PRIMARY KEY,
    lab_order_id BIGINT REFERENCES healthcare.lab_orders(lab_order_id) ON DELETE RESTRICT,
    lab_test_id BIGINT REFERENCES healthcare.lab_tests(lab_test_id) ON DELETE RESTRICT
);
CREATE TABLE healthcare.lab_results (
    lab_result_id BIGSERIAL PRIMARY KEY,
    lab_order_item_id BIGINT REFERENCES healthcare.lab_order_items(lab_order_item_id) ON DELETE RESTRICT,
    result_file BYTEA,
    reported_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.lab_order_invoices (
    lab_invoice_id BIGSERIAL PRIMARY KEY,
    lab_order_id BIGINT REFERENCES healthcare.lab_orders(lab_order_id) ON DELETE RESTRICT,
	currency_id INT REFERENCES healthcare.currency_codes(currency_code_id) ON DELETE RESTRICT DEFAULT 1,
    -- lab_id BIGINT REFERENCES healthcare.labs(lab_id) ON DELETE RESTRICT,
    patient_id BIGINT REFERENCES healthcare.patients(patient_id) ON DELETE RESTRICT,
    subtotal NUMERIC(14,2) DEFAULT 0,
    credit_applied NUMERIC(14,2) DEFAULT 0,
	discount NUMERIC(5,2) DEFAULT 0,       -- discount in %
	total_amount NUMERIC(14,2) DEFAULT 0,
   payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    issued_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
); 
CREATE TABLE healthcare.lab_invoice_payments (
    payment_id BIGSERIAL PRIMARY KEY,
    lab_invoice_id BIGINT REFERENCES healthcare.lab_order_invoices(lab_invoice_id) ON DELETE RESTRICT,
    --currency_id INT REFERENCES healthcare.currency_codes(currency_code_id) ON DELETE RESTRICT DEFAULT 1,
    paid_amount NUMERIC(14,2) NOT NULL,
    payment_method_id INT REFERENCES healthcare.payment_methods(payment_method_id) ON DELETE RESTRICT,
    payment_status_id INT REFERENCES healthcare.payment_status_types(status_id) ON DELETE RESTRICT,
    transaction_ref TEXT,
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    notes TEXT
);
-- ============================================
-- Reminders, Messages, Reward Credits
-- ============================================
CREATE TABLE healthcare.medicine_remainders (
    remainder_id BIGSERIAL PRIMARY KEY,
    patient_id BIGINT REFERENCES healthcare.patients(patient_id) ON DELETE RESTRICT,
    prescription_item_id BIGINT REFERENCES healthcare.prescription_items(prescription_item_id) ON DELETE RESTRICT,
    remainder_time TIMESTAMPTZ NOT NULL,
	message_content text,
    status TEXT DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.messages (
    message_id BIGSERIAL PRIMARY KEY,
    appointment_id BIGINT REFERENCES healthcare.appointments(appointment_id) ON DELETE RESTRICT,
    sender_id BIGINT REFERENCES healthcare.users (user_id) ON DELETE RESTRICT,
    content TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);
CREATE TABLE healthcare.reward_credits (
    patient_id BIGINT PRIMARY KEY REFERENCES healthcare.patients(patient_id) ON DELETE RESTRICT,
	currency int references healthcare.currency_codes(currency_code_id) default 1,
    balance NUMERIC(12,2) DEFAULT 0,
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- Central Audit Log
-- ============================================
CREATE TABLE healthcare.central_audit_log (
    log_id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,   
    changed_by TEXT,
    change_type TEXT,
    change_data JSONB,
    created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE healthcare.central_audit_log
Drop COLUMN changed_by ;

ALTER TABLE healthcare.central_audit_log
ADD COLUMN changed_by_user_id BIGINT REFERENCES healthcare.users(user_id);



--==========================triggers============


--===========================triggrrs===================

-- 1) changelog trigger
-- backend must execute:
--   SET LOCAL app.current_user_id = <user_id>; (before INSERT/UPDATE/DELETE



CREATE OR REPLACE FUNCTION healthcare.audit_log_trigger()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_action TEXT;
    v_data JSONB;
    v_user_id BIGINT;
BEGIN
    -- Fetch user_id from application session (if set)
    BEGIN
        v_user_id := current_setting('app.current_user_id')::BIGINT;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := null;
    END;

    -- Determine action
    IF TG_OP = 'INSERT' THEN
        v_action := 'INSERT';
        v_data := to_jsonb(NEW);

    ELSIF TG_OP = 'UPDATE' THEN
        v_action := 'UPDATE';
        v_data := jsonb_build_object('old', to_jsonb(OLD), 'new', to_jsonb(NEW));

    ELSIF TG_OP = 'DELETE' THEN
        v_action := 'DELETE';
        v_data := to_jsonb(OLD);
    END IF;

    -- Insert log record
    INSERT INTO healthcare.central_audit_log (
        table_name,
        changed_by_user_id,
        change_type,
        change_data,
        created_at
    ) VALUES (
        TG_TABLE_NAME,
        v_user_id,
        v_action,
        v_data,
        now()
    );

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$;
--trigger to tables
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN 
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'healthcare'
          AND table_type = 'BASE TABLE'
          AND table_name <> 'central_audit_log'
    LOOP
        EXECUTE format(
            'CREATE TRIGGER trg_audit_%I
             AFTER INSERT OR UPDATE OR DELETE ON healthcare.%I
             FOR EACH ROW EXECUTE FUNCTION healthcare.audit_log_trigger();',
            r.table_name,
            r.table_name
        );
    END LOOP;
END $$;

-- check availability before insert and update of appointments
CREATE OR REPLACE FUNCTION healthcare.check_active_and_manage_doctor_json_slots()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    p_active BOOLEAN;
    d_active BOOLEAN;
    slot_exists BOOLEAN;
    -- helper jsonb variables
    new_available jsonb;
    new_booked jsonb;
BEGIN
    /* ---------------------------
       Validate patient active (via users)
       --------------------------- */
    SELECT u.is_active
    INTO p_active
    FROM healthcare.patients p
    JOIN healthcare.users u ON p.user_id = u.user_id
    WHERE p.patient_id = NEW.patient_id;

    IF NOT FOUND OR p_active IS DISTINCT FROM TRUE THEN
        RAISE EXCEPTION 'Patient % is not active or does not exist', NEW.patient_id;
    END IF;

    /* ---------------------------
       Validate doctor active (via users)
       --------------------------- */
    SELECT u.is_active
    INTO d_active
    FROM healthcare.doctors doc
    JOIN healthcare.users u ON doc.user_id = u.user_id
    WHERE doc.doctor_id = NEW.doctor_id;

    IF NOT FOUND OR d_active IS DISTINCT FROM TRUE THEN
        RAISE EXCEPTION 'Doctor % is not active or does not exist', NEW.doctor_id;
    END IF;


    /* ====================================================
       CASE: INSERT — book the requested slot on the doctor
       ==================================================== */
    IF TG_OP = 'INSERT' THEN

        /* Check that the requested scheduled_at exists in doctor's available_slots */
        SELECT EXISTS (
            SELECT 1
            FROM healthcare.doctors d,
                 jsonb_array_elements_text(d.available_slots) AS slot_text
            WHERE d.doctor_id = NEW.doctor_id
              AND slot_text::timestamptz = NEW.scheduled_at
        ) INTO slot_exists;

        IF NOT slot_exists THEN
            RAISE EXCEPTION 'Doctor % does not have available slot at %', NEW.doctor_id, NEW.scheduled_at;
        END IF;

        /* Remove the slot from available_slots and append to booked_slots */
        UPDATE healthcare.doctors
        SET
            available_slots = COALESCE((
                SELECT jsonb_agg(elem)
                FROM (
                    SELECT jsonb_array_elements(available_slots) AS elem
                    WHERE elem::timestamptz <> NEW.scheduled_at
                ) t
            ), '[]'::jsonb),
            booked_slots = COALESCE(booked_slots, '[]'::jsonb) || to_jsonb(NEW.scheduled_at),
            updated_at = now()
        WHERE doctor_id = NEW.doctor_id;

        RETURN NEW;
    END IF;


    /* ====================================================
       CASE: UPDATE — handle reschedule / doctor change
       ==================================================== */
    IF TG_OP = 'UPDATE' THEN
        -- If neither doctor nor scheduled_at changed, nothing to do (only validate active)
        IF NEW.doctor_id = OLD.doctor_id
           AND NEW.scheduled_at = OLD.scheduled_at THEN
            RETURN NEW;
        END IF;

        /* 1) Free the OLD slot from the old doctor's booked_slots and add back to available_slots */
        IF OLD.doctor_id IS NOT NULL AND OLD.scheduled_at IS NOT NULL THEN
            -- Remove from booked_slots and ensure available_slots contains old slot
            UPDATE healthcare.doctors
            SET
                booked_slots = COALESCE((
                    SELECT jsonb_agg(elem) FROM (
                        SELECT jsonb_array_elements(booked_slots) AS elem
                        WHERE elem::timestamptz <> OLD.scheduled_at
                    ) t
                ), '[]'::jsonb),
                available_slots = (
                    COALESCE((
                        SELECT jsonb_agg(elem) FROM (
                            SELECT jsonb_array_elements(available_slots) AS elem
                            WHERE elem::timestamptz <> OLD.scheduled_at
                        ) t
                    ), '[]'::jsonb) || to_jsonb(OLD.scheduled_at)
                ),
                updated_at = now()
            WHERE doctor_id = OLD.doctor_id;
        END IF;

        /* 2) Check new slot exists in target doctor's available_slots (after freeing old slot above if same doctor) */
        SELECT EXISTS (
            SELECT 1
            FROM healthcare.doctors d,
                 jsonb_array_elements_text(d.available_slots) AS slot_text
            WHERE d.doctor_id = NEW.doctor_id
              AND slot_text::timestamptz = NEW.scheduled_at
        ) INTO slot_exists;

        IF NOT slot_exists THEN
            RAISE EXCEPTION 'Doctor % does not have available slot at % (cannot reschedule)', NEW.doctor_id, NEW.scheduled_at;
        END IF;

        /* 3) Remove new slot from available_slots of NEW.doctor_id and add to booked_slots */
        UPDATE healthcare.doctors
        SET
            available_slots = COALESCE((
                SELECT jsonb_agg(elem)
                FROM (
                    SELECT jsonb_array_elements(available_slots) AS elem
                    WHERE elem::timestamptz <> NEW.scheduled_at
                ) t
            ), '[]'::jsonb),
            booked_slots = COALESCE(booked_slots, '[]'::jsonb) || to_jsonb(NEW.scheduled_at),
            updated_at = now()
        WHERE doctor_id = NEW.doctor_id;

        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$;
 
-- trigger to appointments
CREATE TRIGGER trg_check_active_and_manage_doctor_json_slots
BEFORE INSERT OR UPDATE ON healthcare.appointments
FOR EACH ROW
EXECUTE FUNCTION healthcare.check_active_and_manage_doctor_json_slots();

--==================cancel future appointments

CREATE OR REPLACE FUNCTION healthcare.cancel_future_appointments_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    cancelled_id INT;
    appt RECORD;
BEGIN
    -- Get 'cancelled' status_id
    SELECT status_id INTO cancelled_id
    FROM healthcare.appointment_status_types
    WHERE status = 'cancelled';

    -------------------------------------------------------
    --  CASE 1: Patient user is deactivated
    -------------------------------------------------------
    IF TG_TABLE_NAME = 'users'
       AND OLD.is_active = TRUE AND NEW.is_active = FALSE
       AND EXISTS (SELECT 1 FROM healthcare.patients p WHERE p.user_id = NEW.user_id)
    THEN
        FOR appt IN
            SELECT * FROM healthcare.appointments
            WHERE patient_id = (SELECT patient_id FROM healthcare.patients WHERE user_id = NEW.user_id)
              AND scheduled_at > now()
        LOOP
            -- Cancel the appointment
            UPDATE healthcare.appointments
            SET status_id = cancelled_id,
                updated_at = now()
            WHERE appointment_id = appt.appointment_id;

            -- Restore doctor slot (ONLY FOR PATIENT DEACTIVATION)
            UPDATE healthcare.doctors
            SET 
                available_slots = COALESCE(available_slots,'[]'::jsonb) || to_jsonb(appt.scheduled_at),

                booked_slots = (
                    SELECT COALESCE(jsonb_agg(value),'[]'::jsonb)
                    FROM jsonb_array_elements(booked_slots) AS a(value)
                    WHERE value <> to_jsonb(appt.scheduled_at)
                ),
                updated_at = now()
            WHERE doctor_id = appt.doctor_id;
        END LOOP;

    -------------------------------------------------------
    --  CASE 2: Doctor user is deactivated
    --  Only cancel appointments. No slot fixing.
    -------------------------------------------------------
    ELSIF TG_TABLE_NAME = 'users'
       AND OLD.is_active = TRUE AND NEW.is_active = FALSE
       AND EXISTS (SELECT 1 FROM healthcare.doctors d WHERE d.user_id = NEW.user_id)
    THEN
        UPDATE healthcare.appointments
        SET status_id = cancelled_id,
            updated_at = now()
        WHERE doctor_id = (SELECT doctor_id FROM healthcare.doctors WHERE user_id = NEW.user_id)
          AND scheduled_at > now();
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_cancel_future_appointments_user
AFTER UPDATE OF is_active ON healthcare.users
FOR EACH ROW
WHEN (OLD.is_active = TRUE AND NEW.is_active = FALSE)
EXECUTE FUNCTION healthcare.cancel_future_appointments_func();


--invoice after appointment completion

CREATE OR REPLACE FUNCTION healthcare.generate_invoice_on_complete_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    completed_id INT;
    exists_invoice BOOLEAN;
BEGIN
    -- Get status id for "completed"
    SELECT status_id INTO completed_id
    FROM healthcare.appointment_status_types
    WHERE status = 'completed';

    -- Only trigger when status actually changes to completed
    IF NEW.status_id = completed_id AND OLD.status_id IS DISTINCT FROM completed_id THEN
        
        -- Prevent duplicate invoice generation
        SELECT EXISTS(
            SELECT 1 FROM healthcare.doctor_consultancy_invoices
            WHERE appointment_id = NEW.appointment_id
        ) INTO exists_invoice;

        IF NOT exists_invoice THEN
            INSERT INTO healthcare.doctor_consultancy_invoices
            (appointment_id, doctor_id, patient_id, amount, status, created_at)
            VALUES (
                NEW.appointment_id,
                NEW.doctor_id,
                NEW.patient_id,
                NEW.consultancy_fee,      -- assuming your appointment contains consultancy_fee
                'unpaid',
                now()
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_generate_invoice_on_complete
AFTER UPDATE OF status_id ON healthcare.appointments
FOR EACH ROW
EXECUTE FUNCTION healthcare.generate_invoice_on_complete_func();





--trigger to create ipd_admisssion only when appointment visit_type is ipd
CREATE OR REPLACE FUNCTION healthcare.validate_ipd_admission()
RETURNS TRIGGER AS $$
DECLARE
    ipd_type_id INT;
    appt_type_id INT;
BEGIN
    -- get IPD visit_type id
    SELECT visit_type_id INTO ipd_type_id
    FROM healthcare.visit_types
    WHERE visit_type = 'IPD';

    -- get appointment's visit_type
    SELECT visit_type_id INTO appt_type_id
    FROM healthcare.appointments
    WHERE appointment_id = NEW.appointment_id;

    IF appt_type_id IS NULL THEN
        RAISE EXCEPTION 'Invalid appointment_id %', NEW.appointment_id;
    END IF;

    IF appt_type_id <> ipd_type_id THEN
        RAISE EXCEPTION 
            'Cannot create IPD admission: appointment % is not IPD type',
            NEW.appointment_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validate_ipd_admission
BEFORE INSERT ON healthcare.ipd_admissions
FOR EACH ROW
EXECUTE FUNCTION healthcare.validate_ipd_admission();



--================ip0d invoice
CREATE OR REPLACE FUNCTION healthcare.create_ipd_invoice_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    invoice_pending_id INT;
    total NUMERIC(12,2);
BEGIN
    SELECT status_id INTO invoice_pending_id
    FROM healthcare.invoice_status_types
    WHERE status = 'pending';

    IF NEW.status_id = (SELECT status_id FROM healthcare.ipd_status_types WHERE status = 'discharged') THEN
        
        -- Example: calculate bill = no_of_days * daily_rate
        SELECT 
            (DATE(NEW.discharge_date) - DATE(NEW.admission_date)) * NEW.daily_rate
        INTO total;

        INSERT INTO healthcare.ipd_invoices
            (admission_id, total_amount, invoice_status_id, created_at)
        VALUES
            (NEW.admission_id, COALESCE(total,0), invoice_pending_id, now());
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_create_ipd_invoice
AFTER UPDATE ON healthcare.ipd_admissions
FOR EACH ROW
WHEN (OLD.ipd_status_id IS DISTINCT FROM NEW.ipd_status_id)
EXECUTE FUNCTION healthcare.create_ipd_invoice_func();


--============pharmacy orders if pharmacy is active


CREATE OR REPLACE FUNCTION healthcare.check_active_pharmacy_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    active BOOLEAN;
BEGIN
    SELECT u.is_active INTO active
    FROM healthcare.pharmacies p
    JOIN healthcare.users u ON u.user_id = p.user_id
    WHERE p.pharmacy_id = NEW.pharmacy_id;

    IF active IS NOT TRUE THEN
        RAISE EXCEPTION 'Pharmacy % is not active', NEW.pharmacy_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_active_pharmacy
BEFORE INSERT ON healthcare.pharmacy_orders
FOR EACH ROW
EXECUTE FUNCTION healthcare.check_active_pharmacy_func();

--===============pharmacy invoice generation
CREATE OR REPLACE FUNCTION healthcare.create_pharmacy_invoice_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    invoice_pending_id INT;
    total NUMERIC(12,2);
    delivered_id INT;
BEGIN
    -- Get required statuses
    SELECT status_id INTO invoice_pending_id
    FROM healthcare.invoice_status_types
    WHERE status = 'pending';
    SELECT status_id INTO delivered_id
    FROM healthcare.pharmacy_order_status_types
    WHERE status = 'delivered';
    -- Only when status becomes delivered
    IF NEW.order_status_id = delivered_id THEN     
        -- Compute total
        SELECT SUM(quantity * price_per_unit)
        INTO total
        FROM healthcare.pharmacy_order_items
        WHERE order_id = NEW.order_id;

        INSERT INTO healthcare.pharmacy_invoices
            (order_id, total_amount, invoice_status_id, created_at)
        VALUES
            (NEW.order_id, COALESCE(total,0), invoice_pending_id, now());
    END IF;

    RETURN NEW;
END;
$$;
CREATE TRIGGER trg_create_pharmacy_invoice
AFTER UPDATE ON healthcare.pharmacy_orders
FOR EACH ROW
WHEN (OLD.order_status_id IS DISTINCT FROM NEW.order_status_id)
EXECUTE FUNCTION healthcare.create_pharmacy_invoice_func();




--===========lab orders if lab is active
CREATE OR REPLACE FUNCTION healthcare.check_active_lab_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    active BOOLEAN;
BEGIN
    SELECT u.is_active INTO active
    FROM healthcare.labs l
    JOIN healthcare.users u ON u.user_id = l.user_id
    WHERE l.lab_id = NEW.lab_id;

    IF active IS NOT TRUE THEN
        RAISE EXCEPTION 'Lab % is not active', NEW.lab_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_active_lab
BEFORE INSERT ON healthcare.lab_orders
FOR EACH ROW
EXECUTE FUNCTION healthcare.check_active_lab_func();

--lab_invoice
CREATE OR REPLACE FUNCTION healthcare.create_lab_invoice_func()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    invoice_pending_id INT;
    total NUMERIC(12,2);
BEGIN
    SELECT status_id INTO invoice_pending_id
    FROM healthcare.invoice_status_types
    WHERE status = 'pending';

    IF NEW.status_id = (SELECT status_id FROM healthcare.lab_order_status_types WHERE status = 'completed') THEN
        
        SELECT SUM(test_price)
        INTO total
        FROM healthcare.lab_order_items
        WHERE order_id = NEW.order_id;

        INSERT INTO healthcare.lab_invoices
            (order_id, total_amount, invoice_status_id, created_at)
        VALUES
            (NEW.order_id, COALESCE(total,0), invoice_pending_id, now());
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_create_lab_invoice
AFTER UPDATE ON healthcare.lab_orders
FOR EACH ROW
WHEN (OLD.status_id IS DISTINCT FROM NEW.status_id)
EXECUTE FUNCTION healthcare.create_lab_invoice_func();



--================payment triggers
CREATE OR REPLACE FUNCTION healthcare.trg_create_payment_generic()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    pending_id INT;
    invoice_table TEXT := TG_TABLE_NAME;  -- table where trigger fired
BEGIN
    SELECT status_id INTO pending_id
    FROM healthcare.payment_status_types
    WHERE status = 'pending';

    -- Doctor Consultancy Invoice → doctor_consultancy_payments
    IF invoice_table = 'doctor_consultancy_invoices' THEN
        INSERT INTO healthcare.doctor_consultancy_payments
            (invoice_id, currency_id, paid_amount, payment_method_id,
             payment_status_id, transaction_ref, paid_at, notes, created_at)
        VALUES
            (NEW.invoice_id, COALESCE(NEW.currency_id, 1), 0,
             NULL, pending_id, NULL, NULL,
             'auto-created pending payment', now());
        RETURN NEW;
    END IF;


    -- Pharmacy Order Invoice → pharmacy_invoice_payments
    IF invoice_table = 'pharmacy_order_invoices' THEN
        INSERT INTO healthcare.pharmacy_invoice_payments
            (pharmacy_invoice_id, paid_amount, payment_method_id,
             payment_status_id, transaction_ref, paid_at, created_at, notes)
        VALUES
            (NEW.pharmacy_invoice_id, 0, NULL,
             pending_id, NULL, NULL, now(),
             'auto-created pending payment');
        RETURN NEW;
    END IF;


    -- Lab Order Invoice → lab_invoice_payments
    IF invoice_table = 'lab_order_invoices' THEN
        INSERT INTO healthcare.lab_invoice_payments
            (lab_invoice_id, paid_amount, payment_method_id,
             payment_status_id, transaction_ref, paid_at, created_at, notes)
        VALUES
            (NEW.lab_invoice_id, 0, NULL,
             pending_id, NULL, NULL, now(),
             'auto-created pending payment');
        RETURN NEW;
    END IF;


    -- IPD Invoice → ipd_invoice_payments
    IF invoice_table = 'ipd_invoices' THEN
        INSERT INTO healthcare.ipd_invoice_payments
            (ipd_invoice_id, paid_amount, payment_method_id,
             payment_status_id, transaction_ref, paid_at, created_at, notes)
        VALUES
            (NEW.ipd_invoice_id, 0, NULL,
             pending_id, NULL, NULL, now(),
             'auto-created pending payment');
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$;
-- Doctor
DROP TRIGGER IF EXISTS trg_payment_doctor_invoice ON healthcare.doctor_consultancy_invoices;
CREATE TRIGGER trg_payment_doctor_invoice
AFTER INSERT ON healthcare.doctor_consultancy_invoices
FOR EACH ROW
EXECUTE FUNCTION healthcare.trg_create_payment_generic();


-- Pharmacy
DROP TRIGGER IF EXISTS trg_payment_pharmacy_invoice ON healthcare.pharmacy_order_invoices;
CREATE TRIGGER trg_payment_pharmacy_invoice
AFTER INSERT ON healthcare.pharmacy_order_invoices
FOR EACH ROW
EXECUTE FUNCTION healthcare.trg_create_payment_generic();


-- Lab
DROP TRIGGER IF EXISTS trg_payment_lab_invoice ON healthcare.lab_order_invoices;
CREATE TRIGGER trg_payment_lab_invoice
AFTER INSERT ON healthcare.lab_order_invoices
FOR EACH ROW
EXECUTE FUNCTION healthcare.trg_create_payment_generic();


-- IPD
DROP TRIGGER IF EXISTS trg_payment_ipd_invoice ON healthcare.ipd_invoices;
CREATE TRIGGER trg_payment_ipd_invoice
AFTER INSERT ON healthcare.ipd_invoices
FOR EACH ROW
EXECUTE FUNCTION healthcare.trg_create_payment_generic();







------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------
------------------------------------------------



--=============================================
-- Indexes
-- -------- Indexes to improve performance (especially for 'last 30 days' / joins)
 
-- Users ( Basic part)
CREATE INDEX idx_users_usernaem ON healthcare.users(username);
 
 
-- Appointments
CREATE INDEX IF NOT EXISTS idx_appointments_scheduled_at ON healthcare.appointments (scheduled_at);
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON healthcare.appointments (patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON healthcare.appointments (doctor_id);

-- Payments - doctor
CREATE INDEX IF NOT EXISTS idx_doc_payments_paid_at ON healthcare.doctor_consultancy_payments (paid_at);
CREATE INDEX IF NOT EXISTS idx_doc_payments_status ON healthcare.doctor_consultancy_payments (payment_status_id);
CREATE INDEX IF NOT EXISTS idx_doc_payments_invoice_id ON healthcare.doctor_consultancy_payments (invoice_id);

-- IPD payments
CREATE INDEX IF NOT EXISTS idx_ipd_payments_paid_at ON healthcare.ipd_invoice_payments (paid_at);
CREATE INDEX IF NOT EXISTS idx_ipd_payments_status ON healthcare.ipd_invoice_payments (payment_status_id);

-- Pharmacy payments
CREATE INDEX IF NOT EXISTS idx_pharmacy_payments_paid_at ON healthcare.pharmacy_invoice_payments (paid_at);
CREATE INDEX IF NOT EXISTS idx_pharmacy_payments_status ON healthcare.pharmacy_invoice_payments (payment_status_id);

-- Lab payments
CREATE INDEX IF NOT EXISTS idx_lab_payments_paid_at ON healthcare.lab_invoice_payments (paid_at);
CREATE INDEX IF NOT EXISTS idx_lab_payments_status ON healthcare.lab_invoice_payments (payment_status_id);

-- Pharmacy orders (for last-30-days orders)
CREATE INDEX IF NOT EXISTS idx_pharmacy_orders_placed_at ON healthcare.pharmacy_orders (placed_at);
CREATE INDEX IF NOT EXISTS idx_pharmacy_orders_pharmacy_id ON healthcare.pharmacy_orders (pharmacy_id);

-- Prescriptions
CREATE INDEX IF NOT EXISTS idx_prescriptions_issued_at ON healthcare.prescriptions (issued_at);
CREATE INDEX IF NOT EXISTS idx_prescriptions_appointment_id ON healthcare.prescriptions (appointment_id);

-- Patients
CREATE INDEX IF NOT EXISTS idx_patients_created_at ON healthcare.patients (created_at);

-- Doctor -> department fast lookup
CREATE INDEX IF NOT EXISTS idx_doctors_department_id ON healthcare.doctors (department_id);

-- Payment status types text -> id (for fast lookup by text)
CREATE INDEX IF NOT EXISTS idx_payment_status_types_status ON healthcare.payment_status_types (status);




 
-- View to Retrive doctor history in appointments.
CREATE OR REPLACE VIEW healthcare.v_doctor_appointment_history AS
SELECT 
    d.doctor_id,
    d.first_name,
    d.last_name,
    a.appointment_id,
    a.scheduled_at,
    a.reason,
    ast.status AS appointment_status,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name
FROM healthcare.doctors d
JOIN healthcare.appointments a ON a.doctor_id = d.doctor_id
JOIN healthcare.appointment_status_types ast ON ast.status_id = a.status_id
JOIN healthcare.patients p ON p.patient_id = a.patient_id
ORDER BY d.doctor_id, a.scheduled_at DESC;
 
 
-- View to retrive patient history
CREATE OR REPLACE VIEW healthcare.v_patient_appointment_history AS
SELECT 
    p.patient_id, 
    p.first_name, 
    p.last_name,
    a.appointment_id,
    a.scheduled_at,
    a.reason,
    ast.status AS appointment_status,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name
FROM healthcare.patients p
JOIN healthcare.appointments a ON a.patient_id = p.patient_id
JOIN healthcare.appointment_status_types ast ON ast.status_id = a.status_id
JOIN healthcare.doctors d ON d.doctor_id = a.doctor_id
ORDER BY p.patient_id, a.scheduled_at DESC;
 

 
-- View to retrive the departments that got most number of patients
CREATE OR REPLACE VIEW healthcare.v_department_most_patients AS
SELECT 
    d.department_id,
    d.name AS department_name,
    COUNT(a.appointment_id) AS total_patients
FROM healthcare.departments d
JOIN healthcare.doctors doc ON doc.department_id = d.department_id
JOIN healthcare.appointments a ON a.doctor_id = doc.doctor_id
GROUP BY d.department_id, d.name
ORDER BY total_patients DESC;


--  Pharmacies that got most orders (last 30 days)
CREATE OR REPLACE VIEW healthcare.vw_top_pharmacies_by_orders_last_30_days AS
SELECT
  ph.pharmacy_id,
  ph.name,
  COUNT(po.pharmacy_order_id) AS orders_count_last_30_days
FROM healthcare.pharmacy_orders po
JOIN healthcare.pharmacies ph ON po.pharmacy_id = ph.pharmacy_id
WHERE po.placed_at >= NOW() - INTERVAL '30 days'
GROUP BY ph.pharmacy_id, ph.name
ORDER BY orders_count_last_30_days DESC;


--  Revenue Last 30 Days
CREATE OR REPLACE VIEW healthcare.vw_total_revenue_by_currency_last_30_days AS
WITH union_payments AS (

    -- Doctor Payments
    SELECT 
        p.currency_id,
        p.paid_amount
    FROM healthcare.doctor_consultancy_payments p
    JOIN healthcare.payment_status_types pst 
        ON p.payment_status_id = pst.status_id
    WHERE pst.status = 'paid'
      AND p.paid_at >= NOW() - INTERVAL '30 days'

    UNION ALL

    -- IPD Payments
    SELECT 
        ipdi.currency_id,
        p.paid_amount
    FROM healthcare.ipd_invoice_payments p
	JOIN healthcare.ipd_invoices ipdi
		ON p.ipd_invoice_id=ipdi.ipd_invoice_id
    JOIN healthcare.payment_status_types pst 
        ON p.payment_status_id = pst.status_id
    WHERE pst.status = 'paid'
      AND p.paid_at >= NOW() - INTERVAL '30 days'

    UNION ALL

    -- Pharmacy Payments
    SELECT 
        poi.currency_id,
        p.paid_amount
    FROM healthcare.pharmacy_invoice_payments p
	JOIN healthcare.pharmacy_order_invoices poi
		ON p.pharmacy_invoice_id=poi.pharmacy_invoice_id
    JOIN healthcare.payment_status_types pst 
        ON p.payment_status_id = pst.status_id
    WHERE pst.status = 'paid'
      AND p.paid_at >= NOW() - INTERVAL '30 days'

    UNION ALL

    -- Lab Payments
    SELECT 
        loi.currency_id,
        p.paid_amount
    FROM healthcare.lab_invoice_payments p
	JOIN healthcare.lab_order_invoices loi
		ON p.lab_invoice_id=loi.lab_invoice_id
    JOIN healthcare.payment_status_types pst 
        ON p.payment_status_id = pst.status_id
    WHERE pst.status = 'paid'
      AND p.paid_at >= NOW() - INTERVAL '30 days'
)

SELECT 
    cur.currency_code,
    cur.currency_name,
    SUM(u.paid_amount) AS total_revenue_last_30_days
FROM union_payments u
JOIN healthcare.currency_codes cur 
     ON u.currency_id = cur.currency_code_id
GROUP BY cur.currency_code, cur.currency_name
ORDER BY cur.currency_code;





 
-- View to retrive top 5 doctors for the different types of currencies.
CREATE OR REPLACE VIEW healthcare.vw_top_doctors_by_currency_last_30_days AS
WITH revenue AS (
    SELECT 
        d.doctor_id,
        d.first_name,
        d.last_name,
        cur.currency_code,
        cur.currency_name,
        SUM(p.paid_amount) AS total_earnings
    FROM healthcare.doctor_consultancy_payments p
    JOIN healthcare.doctor_consultancy_invoices inv 
        ON p.invoice_id = inv.invoice_id
    JOIN healthcare.appointments a 
        ON inv.appointment_id = a.appointment_id
    JOIN healthcare.doctors d 
        ON a.doctor_id = d.doctor_id
    JOIN healthcare.currency_codes cur
        ON p.currency_id = cur.currency_code_id
    JOIN healthcare.payment_status_types pst 
        ON p.payment_status_id = pst.status_id
    WHERE pst.status = 'paid'
      AND p.paid_at >= NOW() - INTERVAL '30 days'
    GROUP BY d.doctor_id, d.first_name, d.last_name, cur.currency_code, cur.currency_name
),
ranked AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY currency_code 
            ORDER BY total_earnings DESC
        ) AS rnk
    FROM revenue
)
SELECT 
    doctor_id,
    first_name,
    last_name,
    currency_code,
    currency_name,
    total_earnings
FROM ranked
WHERE rnk <= 5
ORDER BY currency_code, total_earnings DESC;



 
-- View to retrive the prescriptions
CREATE OR REPLACE VIEW healthcare.v_prescriptions_last_30_days AS
SELECT 
    COUNT(pres.prescription_id) AS total_prescriptions_last_30_days
FROM healthcare.prescriptions pres
WHERE pres.issued_at >= NOW() - INTERVAL '30 days';
 
 
-- View to retrive the no.of new patients enterend our system
CREATE OR REPLACE VIEW healthcare.v_new_patients_last_30_days AS
SELECT 
    COUNT(patient_id) AS new_patients_last_30_days
FROM healthcare.patients
WHERE created_at >= NOW() - INTERVAL '30 days';

--- Creating a Pivotal View for monthly appointments by status types
CREATE OR REPLACE VIEW healthcare.monthly_appointments_status_pivot AS
SELECT
    date_trunc('month', a.scheduled_at)::date AS month,
    COUNT(*) AS total_appointments,
    
    COUNT(*) FILTER (WHERE ast.status = 'scheduled')   AS scheduled_count,
    COUNT(*) FILTER (WHERE ast.status = 'checked_in')  AS checked_in_count,
    COUNT(*) FILTER (WHERE ast.status = 'cancelled')   AS cancelled_count,
    COUNT(*) FILTER (WHERE ast.status = 'rescheduled') AS rescheduled_count,
    COUNT(*) FILTER (WHERE ast.status = 'completed')   AS completed_count

FROM healthcare.appointments a
JOIN healthcare.appointment_status_types ast 
    ON a.status_id = ast.status_id
GROUP BY 1
ORDER BY 1;

select * from healthcare.monthly_appointments_status_pivot;
 
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------
 ---------------



-- ===============================
-- test data
-- ===============================









-- ============================================
-- ============================================
-- ============================================
-- ============================================
-- ============================================
-- ============================================




















































