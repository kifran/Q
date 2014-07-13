
\c 20 160
trade:([]time:`time$();sym:`symbol$();
	price:`float$();size:`int$());

syms:`IBM`GS`FD`KX
n:1000
insert[`trade;(n?"t"$.z.Z;n?syms;10*n?100.0;10*n?100)]

`time xasc `trade;

show"q1";
update price:price*2 from `trade;

show"q2";
update price+10 from `trade where sym=`FD;

show"q3";
basket:-2#syms
update RSUM1:sums size from `trade where sym in basket;

show"q4";
update RSUM2:sums size by sym from `trade 
	where sym in basket;

show"q5";
update RAVG1:avgs price from `trade where sym in basket;

update RAVG0:(sums price)%mcount[max i;i] from `trade where  sym in basket;

show"q6";
update RAVG2:avgs price by sym from `trade;

show"q7";
update RAVG3:3 mavg price by sym from `trade;

show"q8";
update RVWAP1:(sums size*price)%sums size from `trade

show"q9";
update RVWAP2:(sums size*price)%(sums size)by sym 
	from `trade




/