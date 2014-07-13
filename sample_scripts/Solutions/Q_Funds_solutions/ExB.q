
\c 10 150
n:1000000
t:([]time:asc n?0t;sym:n?`a`b`c`d`e;price:n?100e;size:n?1000);

show"question 3";
show select time from t where sym=`b;
show"question 4";
show select from t where price>100;
show"question 5";
show select from t where price>100,size<500;
show"question 6";
show select max price from t;
show"question 7";
show select from t where time within (12:00;13:00);
show"question 8";
show select max price by sym from t;
show"question 9";
show select MAX:max price by sym,xbar[5;time.minute] from t;
show select MAX:max price by sym,xbar[300000;time] from t;
show"xbar[5;time.minute]";
/\t do[100;select MAX:max price by sym,xbar[5;time.minute] from t];
show "xbar[300000;time]";
/\t do[100;select MAX:max price by sym,xbar[300000;time] from t];

show"question 10";
show select OPEN:first price,CLOSE:last price,HIGH:max price,LOW:min price
	by sym,time.hh from t;
show select OPEN:first price,CLOSE:last price,HIGH:max price,LOW:min price
	by sym,xbar[3600000;time] from t;
/show "time.hh";
/\t do[100;select OPEN:first price,CLOSE:last price,HIGH:max price,LOW:min price
/	by sym,time.hh from t];
/show"xbar[3600000;time]";	
/\t do[100;select OPEN:first price,CLOSE:last price,HIGH:max price,LOW:min price
/	by sym,xbar[3600000;time] from t];	

show"question 11";
show select VWAP:wavg[size;price] by sym from t;
show"question 12";
update RSUM1:sums size from `t;
show"question 13";
update RSUM2:sums size by sym from `t;
show"question 14";
update RSUM3:sums size by sym,xbar[10;time.minute]from `t;
show"question 15";
update RVWAP:(sums size*price)%(sums size) by sym from `t;





/





/