USE US_STOCKS_DAILY;
// use ZEPL_STOCKS;
SELECT date, close from STOCK_HISTORY where DATE >= '2018-12-10' and DATE <= '2019-08-07' and symbol='OPER'
order by date ASC;


with stocks as
(select * FROM  US_STOCKS_DAILY.PUBLIC.STOCK_HISTORY WHERE DATE>'2022-01-01')
select symbol, days_of_increasing_stock_price, STREAK_START_DATE, STREAK_END_DATE
from stocks
match_recognize(
--    limit duration(minute, 400)
    partition by symbol
    order by DATE
    measures
        first(DATE) as STREAK_START_DATE,
        last(DATE) as STREAK_END_DATE,
        count(*) as days_of_increasing_stock_price
    ONE ROW PER MATCH
    PATTERN (INCREASE+)
    DEFINE
          INCREASE as close > LAG(close)
)
--where DATE>'2022-01-01'
order by days_of_increasing_stock_price DESC;
