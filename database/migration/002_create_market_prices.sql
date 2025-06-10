CREATE TABLE market_prices (
    id INTEGER PRIMARY KEY,
    neighborhood_id INTEGER NOT NULL,
    source TEXT NOT NULL,
    year_month DATE NOT NULL, -- sempre usar dia 01 do mês
    price_per_m2 REAL NOT NULL,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(id)
);
