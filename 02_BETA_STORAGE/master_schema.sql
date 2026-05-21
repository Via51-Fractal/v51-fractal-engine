-- V51 GLOBAL QUALITY STANDARD SCHEMA
-- Location: Edificio LePommier | Client: F&J Administration

-- 1. Master Units Table
CREATE TABLE IF NOT EXISTS units (
    unit_id TEXT PRIMARY KEY,
    owner_name TEXT NOT NULL,
    participation_ratio DECIMAL(10,6) NOT NULL,
    notification_email TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Atomic Water Readings
CREATE TABLE IF NOT EXISTS water_readings (
    id SERIAL PRIMARY KEY,
    unit_id TEXT REFERENCES units(unit_id),
    billing_period DATE NOT NULL,
    previous_reading DECIMAL(15,3),
    current_reading DECIMAL(15,3) NOT NULL,
    consumption_m3 DECIMAL(15,3) GENERATED ALWAYS AS (current_reading - previous_reading) STORED,
    evidence_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT consistent_reading CHECK (current_reading >= previous_reading)
);

-- 3. Billing Statements (Financial Output)
CREATE TABLE IF NOT EXISTS settlements (
    id SERIAL PRIMARY KEY,
    unit_id TEXT REFERENCES units(unit_id),
    billing_period DATE NOT NULL,
    base_fee_amount DECIMAL(10,2),
    water_fee_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status TEXT DEFAULT 'PENDING',
    due_date DATE,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
