\c market_data

------------------------------------------------------------------------------------------------------------------------------------------------
-- to calculate net worth per year

SELECT great_performers.symbol,fundamentals.total_assets,fundamentals.total_liabilities,
fundamentals.year,
	fundamentals.total_assets - fundamentals.total_liabilities as net_worth
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol
ORDER BY net_worth DESC;

----------------------------------------------------------------------------------------------------------------------------------
-- to calculate average net worth

    WITH calc_net_worth AS(
	SELECT great_performers.symbol,fundamentals.total_assets,fundamentals.total_liabilities,
	fundamentals.total_assets - fundamentals.total_liabilities as net_worth
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol
	)

	SELECT DISTINCT calc_net_worth.symbol,avg(net_worth)
	OVER(
	Partition by calc_net_worth.symbol

	) as avg_net_worth
	FROM calc_net_worth
	ORDER BY avg_net_worth DESC;


----------------------------------------------------------------------------------------------------------------------

	--net income growth for all years

	SELECT great_performers.symbol,fundamentals.year,fundamentals.net_income
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol
	ORDER BY fundamentals.net_income DESC;

-----------------------------------------------------------------------------------------------------------------------

-- net income growth year-over-year formula: (this_yr-last_yr/last_yr)*100

	WITH get_lag_income AS(
	SELECT great_performers.symbol,fundamentals.year,fundamentals.net_income, LAG(fundamentals.net_income,1)
	OVER(
	Partition by great_performers.symbol
	ORDER BY fundamentals.year
	) AS lag_net_income
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol
	)

	SELECT get_lag_income.symbol,get_lag_income.year,get_lag_income.net_income,
	get_lag_income.lag_net_income,
	(CAST(get_lag_income.net_income as FLOAT) - CAST(get_lag_income.lag_net_income AS FLOAT)) / CAST(get_lag_income.lag_net_income AS FLOAT)* 100.0
	AS net_income_growth

	FROM get_lag_income;

----------------------------------------------------------------------------------------------------------------------------------------

--revenue growth year over year

WITH get_lag_revenue AS(
	SELECT great_performers.symbol,fundamentals.year,fundamentals.total_revenue, LAG(fundamentals.total_revenue,1)
	OVER(
	Partition by great_performers.symbol
	ORDER BY fundamentals.year
	) AS lag_revenue
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol
	)

	SELECT get_lag_revenue.symbol,get_lag_revenue.year,get_lag_revenue.total_revenue,
	get_lag_revenue.lag_revenue,
	(CAST(get_lag_revenue.total_revenue as FLOAT) - CAST(get_lag_revenue.lag_revenue AS FLOAT)) 
	/ CAST(get_lag_revenue.lag_revenue AS FLOAT)* 100.0
	AS revenue_growth

	FROM get_lag_revenue;

	------------------------------------------------------------------------------------------------------------------------------------------
	
	-- eps for all years

	SELECT great_performers.symbol,fundamentals.year,fundamentals.earnings_per_share
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol;
	
-----------------------------------------------------------------------------------------------------------------------------------------------------

---amt of liquid cash in the bank vs total liabilities

SELECT great_performers.symbol,fundamentals.year,fundamentals.cash_and_cash_equiv,
fundamentals.total_assets
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol;

	-------------------------------------------------------------------------------------------------------------------------------------------------
	-- gross margin growth for each year.


SELECT great_performers.symbol,fundamentals.year,fundamentals.gross_margin
	FROM great_performers 
	INNER JOIN
	fundamentals
	ON
	great_performers.symbol = fundamentals.symbol;

 --------------------------------------------------------------------------------------------------------------------------------------------------------------

-- query to show the sectors of each company

SELECT great_performers.symbol,securities.sector,
Row_number() OVER(
Partition by securities.sector
Order by great_performers.symbol
)
FROM great_performers
INNER JOIN 
securities
ON
great_performers.symbol = securities.symbol;
