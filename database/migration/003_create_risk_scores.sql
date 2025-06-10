CREATE TABLE risk_scores (
    id SERIAL PRIMARY KEY,
    neighborhood_id INTEGER NOT NULL,
    reference_date TEXT NOT NULL,
    homicide_rate_per_100k REAL NOT NULL,
    notes TEXT,
    FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods(id)
);
