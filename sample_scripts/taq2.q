/this is a comment
\c 20 100
trade:([]
		time:`time$();
		sym:`symbol$();
		price:`float$();
		size:`int$();
		ecn:`symbol$()
 );
 
/
SAMPLE FIX MESSAGE:
fix_message:”8=FIX.4.2\00155=FDP\00153=1000”

add a QuoteID column - FIX TAG: 117

to be published:
MktBidPx - FIX TAG: 645 - Can be used by markets that require showing the current best bid and offer 
MktOfferPx - FIX TAG: 646 - Can be used by markets that require showing the current best bid and offer 

No MktBidSize or MktOfferSize - so could either just publish the associated size of the most recent top of book quote

BC wants to "publish" the TOB quotes as FIX messages so could make this a custom RTS process
and write the TOB FIX messages to a log file or to a downstream subscriber. 
\ 


 
quote:([]
		time:`time$(); /FIX TAG OrigTime=42
		sym:`symbol$(); /FIX TAG symbol=55
		bid:`float$(); /FIX TAG BidPx=132
		bsize:`int$(); /FIX TAG BidSize=134
		ask:`float$(); /FIX TAG OfferPx=133
		asize:`int$(); /FIX TAG OfferSize=135
		ecn:`symbol$() /FIX TAG SecurityExchange=207
 ); 
 
portfolio:`USDJPY`GBPUSD`GBPJPY`EURGBP`EURJPY`AUDUSD`NZDUSD;

st:02:00:00.000; /define start time
et:22:00:00.000;

sqt:02:10:00.000;

ecns:`EBS`REUTERS`CURRNEX`HOTSPOT`LAVA;

n:100000;
tdata:(st+n?et-st;n?portfolio;n?100f;n?1000;n?ecns);

n*:10;

qdata:(sqt+n?et-sqt;n?portfolio;n?100f;n?1000;n?100f;n?1000;n?ecns);

insert[`trade;tdata];


`quote insert qdata;

xasc[`time;`quote];
`time xasc `trade;

counterparties:`GS`MS`DB`BAR`BDMU`SMBC`CITI`ZU`TOYO`NIS`H1`H2;

update cpty:(count trade)?counterparties from `trade;
update cpty:(count quote)?counterparties from `quote;

sector:counterparties!(8#`bank),(2#`corporate),2#`hedge;

f1:{[x]0N!"f1 entered with input: ",-3!x;max x};


proc1:{[s]
	res1:`hour xasc `sym xdesc 
	select MAX1:max[price],MIN:min[price],AVG:avg[price],VWAP:wavg[size;price],
	DEV:dev[price],VAR:var[price],OPEN:first[price],CLOSE:last[price] 
	by sym,hour:time.hh from trade 
	where sym=s,time within (10t;12t);
	res1
 };

proc2:{[s;e]
	res1:`time xasc `SECTOR xdesc 
	select MAX:max[price],MIN:min[price],AVG:avg[price],VWAP:wavg[size;price],
	DEV:dev[price],VAR:var[price],OPEN:first[price],CLOSE:last[price] 
	by SECTOR:sector[cpty],time:xbar[5*60*1000;time] from trade 
	where sym=s,ecn=e;
	res1
 };
 
proc1_wrapper:{[s]
	show s;
	do[8000;res:proc1[s]];
	res
 };
  
 
/res1:proc1[`GBPUSD];
/res2:proc2[`GBPUSD;`REUTERS];


/keyed tables
ref1:([sym:`USDJPY`GBPUSD`GBPJPY`EURGBP`EURJPY`NZDUSD]
		name:("Dollar Yen";"Cable";"Pon Yen";" Euro Sterling";"Euro Yen";"NZ Dollar");
		fx_type:(`straight;`straight;`cross;`straight;`straight;`straight);
		primary_ecn:`EBS`Reuters`REUTERS`REUTERS`EBS`Reuters;
		VALUE:10000000000j*1+6?10);

ref2:([sym:`USDJPY`GBPUSD`GBPJPY`EURGBP`EURJPY;ecn:5#`REUTERS]
		name:("Dollar Yen";"Cable";"Pon Yen";" Euro Sterling";"Euro Yen");
		fx_type:(`straight;`straight;`cross;`straight;`straight);
		precision:(2 4 2 5 2);
		VALUE:10000000000j*1+5?10
 );		
		
data1:(`AUDUSD;"Aussie Dollar";`straight;`Reuters;2000000000j);		
upsert[`ref1;data1];

data2:(`USDJPY;"Dollar Yen";`straight;`LAVA;6000000000j);				
upsert[`ref1;data2];

data3:`sym`primary_ecn`VALUE!(`GBPUSD;`CURRNEX;3000000000j);
upsert[`ref1;data3];

data4:`sym`primary_ecn`name!(`UDSSGD;`CURRNEX;"Dollar Sing");
upsert[`ref1;data4];

data5:`sym`primary_ecn`name!(`GBPUSD`UDSSGD;2#`LAVA;("Dummy 1";"Dummy 2"));
data6:flip data5;
/upsert[`ref1;data6];
/
x:value exec distinct sym,distinct ecn from trade;
y:flip x[0] cross x[1];

data:flip `sym`ecn`fx_type`precision`VALUE!
	(y[0];y[1];(count y[0])?`straight`cross;(count y[0])?10;1000000000j*1+(count y[0])?10);

upsert[`ref2;data];	

/uj
u:uj[trade;quote];
`time xasc `u;

/historical data
trade_hdb:`date`time xasc `date xcols update date:(count trade)?.z.D-til 10 from trade;
quote_hdb:`date`time xasc `date xcols update date:(count quote)?.z.D-til 10 from quote;

 
 