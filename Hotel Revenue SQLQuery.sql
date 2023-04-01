
--in the following query i'll create a temporary table
--consisting of all the data from the excel file.



with hotels as (
select * 
from ..['2018$']
union
select * 
from ..['2019$']
union 
select * 
from ..['2020$']
)


 select * from hotels
 left join ..market_segment$
 on hotels.market_segment = market_segment$.market_segment 
 left join ..meal_cost$
 on meal_cost$.meal = hotels.meal  


 
--select arrival_date_year, hotel,
--round(sum((stays_in_weekend_nights+stays_in_week_nights)*adr),0) as revenue  from hotels
--group by arrival_date_year, hotel
