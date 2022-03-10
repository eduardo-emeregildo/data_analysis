---- creating view and allows export of resulting queries
\c market_data


DROP VIEW IF EXISTS check_great_performers;

CREATE VIEW check_great_performers AS
SELECT great_performers.symbol,prices.price_date,
prices.open,prices.close,prices.low,prices.high,
prices.volume

FROM great_performers
INNER JOIN prices
ON 
great_performers.symbol = prices.symbol
ORDER BY prices.price_date DESC
limit 50;


SELECT * FROM check_great_performers;
