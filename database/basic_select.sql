SELECT 
    n.id AS neighborhood_id,
    n.name AS neighborhood_name,
    n.city,
    n.state,
    r.reference_date AS violence_data_ref,
    r.homicide_rate_per_100k,
    r.notes AS violence_notes,
    mp.year_month AS price_data_ref,
    mp.price_per_m2,
    mp.source AS price_source
FROM 
    neighborhoods n
LEFT JOIN 
    risk_scores r ON r.neighborhood_id = n.id
LEFT JOIN 
    market_prices mp ON mp.neighborhood_id = n.id

ORDER BY 
    n.name ASC;
