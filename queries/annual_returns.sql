\c market_data
-- initial queries to find high performers  
 DROP TABLE IF EXISTS annual_returns;


CREATE TABLE annual_returns AS 

		WITH get_lead_price AS(
	SELECT * FROM(
SELECT prices.price_date,prices.symbol,prices.close, LEAD(prices.close,253)      -- looking 253 days ahead of each date to get the close of that date next year. the amount of days that the market
											--is open is roughly 52 * 5 = 260. The stock market closes approx 7 days a year
OVER( Partition by prices.symbol
Order by prices.price_date

) as end_year_price
from prices
	)t

WHERE t.price_date LIKE '%-01-04' -- string match to get the  start date for each year
	)	


SELECT get_lead_price.price_date,get_lead_price.symbol, 
(get_lead_price.end_year_price / get_lead_price.close) - 1 AS annual_return
FROM get_lead_price;



DROP TABLE IF EXISTS great_performers CASCADE;
CREATE TABLE great_performers AS
SELECT DISTINCT annual_returns.symbol, 
avg(case when annual_returns.annual_return is NULL then 0 ELSE annual_returns.annual_return END) 
OVER(
Partition by annual_returns.symbol



) as avg_annual_ret_per_company

FROM annual_returns 
ORDER BY avg_annual_ret_per_company DESC
limit 40;



SELECT * FROM great_performers;