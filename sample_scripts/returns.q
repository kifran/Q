
\c 80 150

closing_prices:([]
	date:`date$();
	sym:`symbol$();
	price:`float$()
 );
 
dts:.z.D-til 25
dts:dts where not (dts mod 7)in 0 1
portfolio:`IBM`MSFT; /list of stocks we trade

x:`date`sym!flip dts cross portfolio 
x[`price]:(count x[`date])?100f
`closing_prices insert flip x

`date`sym xasc `closing_prices;
update daily_return:100*(price-prev price)%prev price by sym from `closing_prices;

days:(til 7)!`sat`sun`mon`tue`wed`thu`fri

update day:days[date mod 7] from `closing_prices

show "closing_prices";
show closing_prices


thisweek:`week$.z.D

/select week:date,day,price from 

weekly:select last_date:last date,last day, last price by sym,week:`week$date from closing_prices
	where (`week$date)<thisweek;

update weekly_return:100*(price-prev price)%(prev price) by sym from `weekly;	
show "weekly";
show weekly;
	