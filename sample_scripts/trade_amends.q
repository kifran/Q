
\c 10 130
/
/RDB
trade:([]
	date:`date$(); /always today
	tdate:`date$(); /New-> Today. Amend->Date of amended trade (could be in the past)
	sym:`symbol$();
	transaction_timestamp:`datetime$(); /always right now (tickerplant timestamp)
	trade_id:(); /unique id
	route_id:(); /New->same as trade_id. Amend-> trade_id of amended trade (could be in the past)
	price:`float$();
	size:`int$();
	ttype:`symbol$()); /New or amended or cancelled

/create sample new trades	
n:10000000;
new_trade_ids:string til n;
types:`new`amend`cancel;
portfolio:`IBM`GOOG`MSFT`BA`YHOO`VOD
sd:.z.D-20;
ed:.z.D;
st:9t;
et:16t;
new_trade_dates:sd+n?ed-sd;
new_trade_times:st+n?et-st;

new_trades:flip `date`tdate`sym`transaction_timestamp`trade_id`route_id`price`size`ttype!
					(new_trade_dates;new_trade_dates;n?portfolio;new_trade_dates+new_trade_times;
					new_trade_ids;new_trade_ids;n?100f;n?1000;n#`new);
insert[`trade;new_trades];
				
/amended trades	
na:20000			
amended_route_ids:na?new_trade_ids;
amended_trade_ids:string n+til na;
amended_syms:trade[`sym](trade.trade_id)?amended_route_ids;
amended_tdates:trade[`date](trade.trade_id)?amended_route_ids;
amended_dates:(na?til 3)+amended_tdates;

amend_data:flip `date`tdate`sym`transaction_timestamp`trade_id`route_id`price`size`ttype!
	(amended_dates;amended_tdates;amended_syms;amended_dates+18t;amended_trade_ids;amended_route_ids;na?100f;na?1000;na#`amend);

insert[`trade;amend_data];

`date`transaction_timestamp xasc `trade;

/build on disk DB
trade_all:trade;
date_part:{[dt]
		show dt;
		trade::delete date from select from trade_all where date=dt;
		.Q.dpft[`:db2;dt;`sym;`trade];
 };
 
date_part each exec distinct date from trade_all;

/trade:trade_all;
/delete trade_all from `.
delete from `.
\
\l db2

/initialise amends table to be an empty trade schema
amends:delete from select from trade where date=last date;


f:{[dt]
	data:select from trade where date=dt,ttype=`amend;
	amends,:data;
 };
/populate the amends table from the historical trades
/ which have the amend flag set 
f each date
/group the amends table by route_id and then rename 
/the columns to be upper case letters
amends:xgroup[`route_id;amends];
amends:xcol[`route_id,upper(1_cols amends);amends];
/save the keyed amends table down to disk
set[`:amends;amends];

/sample query
t1:lj[select from trade where date=.z.D-1;amends];
/select those trades on .z.D-1 which had amends
t2:select from t1 where not{x~`sym$()}each SYM;
/select those trades on .z.D-1 which had no amends
t3:select from t1 where {x~`sym$()}each SYM;

/
/at EOD
amend_data:select from trade where ttype=`amend;

.Q.dpft[`:db2;.z.D-2;`sym;`trade];
set[`:db2/historical_amend_data;historical_amend_data];

historical_amend_data:() xkey get `:db2/historical_amend_data;
insert[`historical_amend_data;amend_data];
historical_amend_data:xgroup[`route_id;historical_amend_data];
set[`:db2/historical_amend_data;historical_amend_data];

	
	

