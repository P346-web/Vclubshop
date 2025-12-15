-- VClub Shop Database Schema
-- Run this SQL to set up the production database

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) DEFAULT 'user',
  balance DECIMAL(10, 2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS listings (
  id SERIAL PRIMARY KEY,
  seller_id INTEGER REFERENCES users(id),
  title VARCHAR(255) NOT NULL,
  card_type VARCHAR(50),
  card_brand VARCHAR(50),
  country VARCHAR(100),
  price DECIMAL(10, 2) NOT NULL,
  details TEXT,
  card_number VARCHAR(50),
  exp_month VARCHAR(2),
  exp_year VARCHAR(4),
  cvv VARCHAR(10),
  bin VARCHAR(10),
  bank VARCHAR(100),
  zip VARCHAR(20),
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS transactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  listing_id INTEGER REFERENCES listings(id),
  type VARCHAR(20) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  refund_status VARCHAR(20),
  refund_reason TEXT,
  refund_requested_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin_settings (
  id SERIAL PRIMARY KEY,
  wallet_address VARCHAR(255),
  qr_code_url VARCHAR(500),
  site_name VARCHAR(100) DEFAULT 'VClub',
  btc_rate DECIMAL(20, 8) DEFAULT 0,
  bonus_percentage DECIMAL(5, 2) DEFAULT 0,
  min_bonus_amount DECIMAL(10, 2) DEFAULT 0,
  exchange_fee DECIMAL(5, 2) DEFAULT 0,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS refund_requests (
  id SERIAL PRIMARY KEY,
  transaction_id INTEGER REFERENCES transactions(id),
  user_id INTEGER REFERENCES users(id),
  reason TEXT,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO admin_settings (id, wallet_address, site_name, btc_rate, bonus_percentage, min_bonus_amount, exchange_fee)
VALUES (1, '', 'VClub', 0, 0, 0, 0)
ON CONFLICT (id) DO NOTHING;