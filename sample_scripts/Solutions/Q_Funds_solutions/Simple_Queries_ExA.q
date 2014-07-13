

\c 10 150

trade:([]
	date:`date$();
	time:`time$();
	sym:`symbol$();
	side:`symbol$();
	price:`float$()
	);
	
n:1000000
dts:.z.D-til 3;
portfolio:`VOD.L`BMW.DE`AAA.L`FDP.L`GOOG.NY
sides:`B`S

insert[`trade;(.z.d-n?3;n?.z.T;n?portfolio;n?sides;n?200f)];

show"question 2";
show select from trade where sym=`AAA.L,date=.z.D,side=`B;
/
show"question 3";	
show"sym,date,side";
\t do[100;select from trade where sym=`AAA.L,date=.z.D,side=`B];
show"sym,side,date";
\t do[100;select from trade where sym=`AAA.L,side=`B,date=.z.D];
show"date,sym,side";
\t do[100;select from trade where date=.z.D,sym=`AAA.L,side=`B];
show"date,side,sym";
\t do[100;select from trade where date=.z.D,side=`B,sym=`AAA.L];
show"side,sym,date";
\t do[100;select from trade where side=`B,sym=`AAA.L,date=.z.D];
show"side,date,sym";
\t do[100;select from trade where side=`B,date=.z.D,sym=`AAA.L];


show"question 4";
show"within";
\t do[1;select from trade where date=.z.D,price within 100 110];
show">= <=";
\t do[1;select from trade where date=.z.D,price>=100,price<=110];

show"question 5";
show select COUNT:count i by sym from trade where date=.z.D,price within (100;110);

show"question 6";
update sym:`BBB.L from `trade where date=.z.D,sym=`AAA.L;

show"question 7";
delete from `trade where price>190;

show"question 8";
show exec distinct sym from trade where date>=.z.D-1,sym like "*.L"

show"question 9";
show"solution 0";
show select MAX:max price,MIN:min price,SPREAD:(max price)- min price,AVG:avg price by sym from trade where
	side=`B,date=.z.D-1,time<00:01t


/solution 1
x:select FIRST_MINUTE:min `minute$time by sym from trade
	where date=.z.D-1,side=`B;

/update FIRST_MINUTE+5?100 from `x
	
res1:select from
	((select from trade where date=.z.D-1,side=`B)lj x)
	where time.minute=FIRST_MINUTE;

show res2:select MAX:max price,MIN:min price,AVG:avg price,
		SPREAD:(max price)-min price by sym from res1;

/solution 2 (fby)
res3:select from trade where date=.z.D-1,side=`B

show res4:select MAX:max price,MIN:min price,AVG:avg price,
	SPREAD:(max price)-min price by sym from res3 
	where time.minute=fby[(min;`minute$time);sym]

res2~res4	
		
/