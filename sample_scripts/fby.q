\c 15 150
s:`IBM`WMT`GS`LEH; 
x:`O`N`Q
n:100000; 
nt:n; 
nq:4*n;
dts:.z.D-til 3
trade:([]
		date:nt?dts;
		time:nt?0t;
		sym:nt?s;
		price:50+0.1*nt?5000;
		size:nt?1000;
		ex:nt?x);

quote:([]
		date:nq?dts;
		time:nq?0t;
		sym:nq?s;
		bid:50+0.1*nq?5000;
		ask:50+0.1*nq?5000;
		bsize:nq?1000;
		asize:nq?1000;
		ex:nq?x);

xasc[`date`time;`trade];
xasc[`date`time;`quote];		
/
show"query 1";
/select trades where price > avg price for that symbol
\ts do[100;res1:delete AVG from select from 
	lj[trade;select AVG:avg price by sym from trade]where price>AVG];

f_avg:{avg x};

\ts do[100;res2:select from trade where price>fby[(avg;price);sym]];
\ts do[100;res3:select from trade where price>fby[({avg x};price);([]sym)]];
\ts do[100;res4:select from trade where price>fby[(f_avg;price);([]sym)]];

show (res1~res2)and(res2~res3)and(res3~res4);	

show"query 2";
/select trades where price > avg price for that symbol,date combination
\ts do[100;res1:delete AVG from select from lj[trade;select AVG:avg price by date,sym from trade]where price>AVG];

\ts do[100;res2:select from trade where price>fby[(avg;price);([]date;sym)]];
show res1~res2;

show"query 3";
/select top 5 prices by date,sym combination
x:select price,time,ex by date,sym from trade;
f:{5 sublist(desc x)};

res1:`sym`price xdesc ungroup select date,sym,each[f;price] from x

res2:`sym`price xdesc select from trade where price>fby[({(desc x)[5]};price);([]date;sym)];

/show res1~res2;
\
show"query 4";
/select trade if its price>the daily vwap for that sym
update ps:flip(price;size) from `trade

vwap_calc:{[x]d:flip x;wavg[d[1];d[0]]}

res1:delete ps from select from trade where price>fby[(vwap_calc;ps);([]date;sym)];
delete ps from `trade;
res2:select from trade where price>fby[(vwap_calc;flip(price;size));([]date;sym)];
res1~res2

show"query 5";
/only include a trade if its price its within a standard deviation of the average price
/for that stock

/f returns a list of booleans - 1b for prices within the window, 0b for prices outside the window
f:{[x]a:avg x;d:dev x;x within (a-d;a+d)}

res2:select from trade where fby[(f;price);([]sym)]

r1:p where f p:exec price from trade where sym=`IBM













/
	
		