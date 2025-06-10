DROP MATERIALIZED VIEW IF EXISTS neighborhood_risk_summary;

CREATE MATERIALIZED VIEW neighborhood_risk_summary AS
SELECT 
    n.id AS neighborhood_id,
    n.name AS neighborhood_name,
    n.city,
    n.state,

    r.reference_date AS violence_data_ref,
    r.homicide_rate_per_100k,

    ROUND(
      r.homicide_rate_per_100k / (
        SELECT MAX(homicide_rate_per_100k)
        FROM risk_scores
        WHERE homicide_rate_per_100k IS NOT NULL
      ) * 100
    ) AS violence_score,

    CASE 
      WHEN r.homicide_rate_per_100k IS NULL THEN NULL
      WHEN (r.homicide_rate_per_100k / (
        SELECT MAX(homicide_rate_per_100k)
        FROM risk_scores
        WHERE homicide_rate_per_100k IS NOT NULL
      )) * 100 >= 75 THEN 'high'
      WHEN (r.homicide_rate_per_100k / (
        SELECT MAX(homicide_rate_per_100k)
        FROM risk_scores
        WHERE homicide_rate_per_100k IS NOT NULL
      )) * 100 >= 40 THEN 'medium'
      ELSE 'low'
    END AS violence_risk_level,

    mp.year_month AS price_data_ref,
    mp.price_per_m2,
    mp.source AS price_source,

    r.notes AS violence_notes,
    r.homicide_rate_per_100k IS NOT NULL AS has_violence_data,
    mp.price_per_m2 IS NOT NULL AS has_price_data

FROM 
    neighborhoods n
LEFT JOIN 
    risk_scores r ON r.neighborhood_id = n.id
LEFT JOIN 
    market_prices mp ON mp.neighborhood_id = n.id;
