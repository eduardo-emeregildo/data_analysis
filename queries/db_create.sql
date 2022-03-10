DROP DATABASE IF EXISTS market_data;
 CREATE DATABASE market_data;

 \c market_data 

DROP TABLE IF EXISTS fundamentals;
DROP TABLE IF EXISTS prices;
DROP TABLE IF EXISTS securities;

CREATE TABLE fundamentals(
id INTEGER,
symbol TEXT,
year_ending TEXT,
cash_and_cash_equiv BIGINT,
earnings_before_interest_and_taxes BIGINT,
gross_margin INTEGER,
net_income BIGINT,
total_assets BIGINT,
total_liabilities BIGINT,
total_revenue BIGINT,
year INTEGER,
earnings_per_share FLOAT,
shares_outstanding FLOAT
);

CREATE TABLE prices(
price_date text,
symbol text,
open FLOAT,
close FLOAT,
low FLOAT,
high FLOAT,
volume INTEGER

);


CREATE TABLE securities(
symbol text,
company text,
sector text,
sub_industry text,
init_trade_date text
);

\COPY fundamentals FROM 'C:\Users\Eduardo\Desktop\data_analysis\assn_data\fundamentals.csv' DELIMITER ',' CSV;
\COPY prices FROM 'C:\Users\Eduardo\Desktop\data_analysis\assn_data\prices.csv' DELIMITER ',' CSV;
\COPY securities FROM 'C:\Users\Eduardo\Desktop\data_analysis\assn_data\securities.csv' DELIMITER ',' CSV;