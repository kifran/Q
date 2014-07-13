/
In five minute buckets per date/sym, we need:
1. The price asof the start of the bucket
2. All trade prices/time within the bucket

09:30 - 09:35

trade as of start: price:10

1st trade in bucket: price:20 at 09:32
2nd trade in bucket: price:15 at 09:34

=> TWAP = ((("i"$09:32-09:30)*10)+(("i"$09:34-09:32)*20)+(("i"$09:35-09:34)*15))%("i"$00:05) = 15

\

\l taq.q

/table t will have the buckets of trades per date/sym/5 minute interval
t:select COUNT:count i,prices:price,times:time by date,sym,(5*60*1000) xbar time 
	from trade

/Use an aj to get the asof trade price/time for the start of each bucket
a:aj[`date`sym`time;t;select date,time,sym,PRICE:price,TIME:time from trade]

/a:select from a where not null PRICE /ignore buckets where there is no asof trade for the start of the bucket

/input is a row of the table a as a dictionary
/vector of time weights
/vector of price values
twap_calc:{[x]
	/if else statement checks whether there is an asof trade for the start of the bucket
	/If yes, include the earlier trade's price in twap calculation
	/otherwise, just use trades in bucket
	/yyy;
	$[not null x[`PRICE];
	[w:"i"$1_deltas x[`time],x[`times],x[`time]+00:05t;p:x[`PRICE],x[`prices]];
	[w:"i"$1_deltas x[`times],x[`time]+00:05t;p:x[`prices]]
	];
	twap:(sum p*w)%sum w; /twap value
	twap
	};

show"calc_twap";
\t res:twap_calc each xkey[();a];
update twap:res from `a;	








/