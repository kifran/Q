
\c 10 150
s:`IBM`WMT`GS`LEH; 
x:`O`N`Q
n:10000; 
nt:n; 
nq:4*n;
trade:([]
		time:asc nt?0t;
		sym:nt?s;
		price:50+0.1*nt?5000;
		size:nt?1000;
		ex:nt?x);

quote:([]
		time:asc nq?0t;
		sym:nq?s;
		bid:50+0.1*nq?5000;
		ask:50+0.1*nq?5000;
		bsize:nq?1000;
		asize:nq?1000;
		ex:nq?x);

/
/question 1
show "Q1";
	
hour:flip`time`sym!flip cross[1t*til 24;s];

\w
\t do[100;res1:aj[`sym`time;hour;quote]];
update `g#sym from `quote;
\w
\t do[100;res2:aj[`sym`time;hour;quote]];
res1~res2

chk1:select by sym from quote where time within(00:59t;1t)
\

/question 2
show "Q2";

trade_five:select time,time_five,sym,price_five from 
	update time:time+00:05t,time_five:time,price_five:price from trade;

res2:select from aj[`sym`time;trade;trade_five] where not null time_five;
update change:price-price_five from `res2

\ts do[10;r1:aj[`sym`time;trade;trade_five]];
show .Q.w[];

update `g#sym from `trade_five;
show"";
show .Q.w[];
\ts do[10;r2:aj[`sym`time;trade;trade_five]];

r1~r2
/
/question 3
show "Q3";

show"Solution 1 - loop over rows - time,sym";

ftime:{[row;w]
	row[`vwap]:exec wavg[size;price] from trade
	where time within(row[`time];row[`time]+"t"$w*00:01),sym=row[`sym];
	row
 };

window:10 /window width in minutes 
 
show"time,sym"; 
\t res3time:ftime[;window] each trade;

show"Solution 1 - loop over rows - sym,time";

show"sym,time";  

fsym:{[row;w]
	row[`vwap]:first exec wavg[size;price] from trade
	where sym=row[`sym],time within(row[`time];row[`time]+"t"$w*00:01);
	row
 }; 

\t res3sym:fsym[;window] each trade;
show .Q.w[];
update `g#sym from `trade;
show"sym,time with g attribute on sym";
show .Q.w[]; 
\t res3g:fsym[;window] each trade; 

(res3time~res3sym)and(res3sym~res3g)

/chk3:select vwap:wavg[size;price] from trade where sym=trade[`sym][0],time within(trade[`time][0];trade[`time][0]+00:10t)

show"Solution 2 - window join";

`sym`time xasc `trade; /necessary to sort lookup table in this manner prior to wj/wj1

update ps:flip(price;size)from `trade

f:{[x]y:flip x;p:y[0];s:y[1];wavg[s;p]} /vwap calculation

w:(trade[`time];trade[`time]+`time$00:10) /start and end times for the windows

show"wj - no g attribute on sym";
\ts res_wj_no_g_attr:wj[w;`sym`time;trade;(trade;(f;`ps))];

update `g#sym from `trade
show"wj - g attribute on sym";
\ts res_wj_g_attr:wj[w;`sym`time;trade;(trade;(f;`ps))];

res_wj_g_attr:xcol[(-1_cols res_wj_g_attr),`vwap;res_wj_g_attr]

/compare vwaps from solutions 1 and 2
show"compare vwaps from solutions 1 and 2";
result_tbls:{`sym`time xasc x}each (res3sym;res_wj_no_g_attr); /sort both solution tables by `sym`time xasc
vwaps:@'[result_tbls;`vwap`ps]; /extract the vwap columns from each solution table
1_(~':)vwaps /check that all vwap vectors are the same

/1_(~':)@'[{`sym`time xasc x}each (res3sym;res_wj_no_g_attr);`vwap`ps] /all in one line!











/