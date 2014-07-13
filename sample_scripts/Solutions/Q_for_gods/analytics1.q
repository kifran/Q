/delete the outlying quotes from the quote table
/An outlying quote is one where the spread is very wide
/Specifically, where the spread is greater than 1.5* (avg spread - dev spread) for the last 10 quotes
/so need to calculate the rolling deviation and average of the spread for the last 10 quotes by stock

system"cd ../..";
\l taq.q
t:select from trade where date=first date,sym in `IBM`MSFT,time within (09:40t;09:45t);
q:select from quote where date=first date,sym in `IBM`MSFT,time within (09:38t;09:45t);

update MAVG:mavg[10;abs bid-ask],DEV:mdev[10;abs bid-ask] by sym from `q
delete from `q where (abs bid-ask)>1.5*abs MAVG-DEV