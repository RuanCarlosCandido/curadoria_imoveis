ALTER TABLE risk_scores ADD COLUMN shootings_score INTEGER CHECK (shootings_score BETWEEN 0 AND 100);
ALTER TABLE risk_scores ADD COLUMN flooding_score INTEGER CHECK (flooding_score BETWEEN 0 AND 100);
ALTER TABLE risk_scores ADD COLUMN infrastructure_score INTEGER CHECK (infrastructure_score BETWEEN 0 AND 100);
ALTER TABLE risk_scores ADD COLUMN final_score INTEGER CHECK (final_score BETWEEN 0 AND 100);
ALTER TABLE risk_scores ADD COLUMN risk_level TEXT CHECK (risk_level IN ('low', 'medium', 'high'));
