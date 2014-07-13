/calculate the moving average price 
/for the last N days by stock
/then only select those trades whose price 
/is less than that average value

system"cd ../..";
\l taq.q

temp1:select P:sum price,C:count price by date,sym from trade;

f1:{[n;P;C](msum[n;P])%(msum[n;C])}; 

res1:update MAVG:f1[300;P;C] by sym from temp1

res2:trade lj res1
res3:select from res2 where price<MAVG
/
/wj approach - calc average price for the last 10 days by stock
update PRICE:price from `trade
w:(-9+trade.date;trade.date+1);
r1:wj1[w;`sym`date;trade;(`date`sym xasc trade;(avg;`price))];
r2:xcol[`date`time`sym`AVG;r1];
r3:select from r2 where PRICE<AVG

show (select date,time,sym,price from res3)~(`date`time`sym`price xcol select date,time,sym,PRICE from r3)




	
	


 

