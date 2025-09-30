-- Investment Portfolio Analysis Database Schema
-- Data Analyst Portfolio Project

CREATE DATABASE IF NOT EXISTS portfolio_analysis;
USE portfolio_analysis;

-- Stocks table to store stock information
CREATE TABLE IF NOT EXISTS stocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    sector VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_symbol (symbol)
);

-- Historical stock prices table
CREATE TABLE IF NOT EXISTS stock_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    open_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    volume BIGINT,
    adj_close DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_symbol_date (symbol, date),
    INDEX idx_symbol_date (symbol, date),
    FOREIGN KEY (symbol) REFERENCES stocks(symbol) ON UPDATE CASCADE
);

-- Portfolios table
CREATE TABLE IF NOT EXISTS portfolios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Portfolio holdings table
CREATE TABLE IF NOT EXISTS portfolio_holdings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    portfolio_id INT NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    purchase_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (portfolio_id) REFERENCES portfolios(id) ON DELETE CASCADE,
    FOREIGN KEY (symbol) REFERENCES stocks(symbol) ON UPDATE CASCADE,
    INDEX idx_portfolio_symbol (portfolio_id, symbol)
);

-- Price alerts table for 10% weekly changes
CREATE TABLE IF NOT EXISTS price_alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL,
    alert_type ENUM('rise', 'fall') NOT NULL,
    percentage_change DECIMAL(5,2) NOT NULL,
    price_from DECIMAL(10,2) NOT NULL,
    price_to DECIMAL(10,2) NOT NULL,
    alert_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (symbol) REFERENCES stocks(symbol) ON UPDATE CASCADE,
    INDEX idx_symbol_alert_date (symbol, alert_date)
);

-- Insert sample stocks
INSERT IGNORE INTO stocks (symbol, name, sector) VALUES
('AAPL', 'Apple Inc.', 'Technology'),
('GOOGL', 'Alphabet Inc.', 'Technology'),
('MSFT', 'Microsoft Corporation', 'Technology'),
('TSLA', 'Tesla Inc.', 'Automotive'),
('AMZN', 'Amazon.com Inc.', 'Consumer Discretionary'),
('NVDA', 'NVIDIA Corporation', 'Technology'),
('META', 'Meta Platforms Inc.', 'Technology'),
('NFLX', 'Netflix Inc.', 'Communication Services');

-- Insert sample portfolios
INSERT IGNORE INTO portfolios (id, name, description) VALUES
(1, 'Tech Growth Portfolio', 'High-growth technology stocks'),
(2, 'Diversified Portfolio', 'Balanced portfolio across sectors'),
(3, 'Conservative Portfolio', 'Low-risk dividend stocks');

-- Insert sample portfolio holdings
INSERT IGNORE INTO portfolio_holdings (portfolio_id, symbol, quantity, purchase_price, purchase_date) VALUES
-- Tech Growth Portfolio
(1, 'AAPL', 50, 150.00, '2024-01-15'),
(1, 'GOOGL', 20, 140.00, '2024-01-20'),
(1, 'MSFT', 30, 300.00, '2024-02-01'),
(1, 'NVDA', 15, 400.00, '2024-02-10'),

-- Diversified Portfolio
(2, 'AAPL', 25, 160.00, '2024-03-01'),
(2, 'TSLA', 10, 200.00, '2024-03-05'),
(2, 'AMZN', 8, 120.00, '2024-03-10'),
(2, 'META', 12, 280.00, '2024-03-15'),

-- Conservative Portfolio
(3, 'MSFT', 40, 280.00, '2024-01-10'),
(3, 'AAPL', 30, 155.00, '2024-01-25'),
(3, 'GOOGL', 15, 135.00, '2024-02-05');