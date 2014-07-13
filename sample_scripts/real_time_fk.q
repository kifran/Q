\l trade.q
delete from `trade;

ref1:([sym:`IBM`MSFT`GOOG`YHOO]
	name:("IBM";"Microsoft";"Google";"YAHOO");
	cusip:`ABC123`DEF456`GHI789`JKL012;
	city:(`Armonk;`Redmond;`Sunnyvale;`$"San Francisco");
	MC:10000000000j*1+4?10
 );

`trade insert (.z.T;`IBM;100f;100);
update fk1:`ref1$sym from `trade; 
 
trade_unknown:update error:() from delete fk1 from delete from trade

try:{[d]
	/d:enlist d;
	d:update fk1:`ref1$sym from d;
	/yyy;
	`trade insert d;
	};
	
catch:{[e;d]
	d:update error:e from d;
	`trade_unknown insert d;
	}


upd:{[t;d]
	$[t=`trade;{[row]@[try;row;catch[;row]]}each d;t insert d];
 };
 
/show"upd1" 
/upd[`trade;([]time:.z.T+til 2;sym:`IBM`MSFT;price:2?100f;size:2?100)]; 

/show"upd2" 
/upd[`trade;([]time:.z.T+til 2;sym:`IBM`AAPL;price:2?100f;size:2?100)]; 

n:1000000
i:100
portfolio:`IBM`MSFT`GOOG`YHOO,1?`4
data:([]time:.z.T+til n;sym:n?portfolio;price:n?100f;size:n?100);

show"FK"
st1:.z.T
\t upd[`trade] each cut[i;data]
et1:.z.T

show"No FK"
\l trade.q
delete from `trade
`trade insert (.z.T;`IBM;100f;100);
upd:{[t;d]t insert d};
st2:.z.T
\t upd[`trade] each cut[i;data]
et2:.z.T

show"average time taken for a ",(string i)," row insert with FK present is: ",(string (et1-st1)%(n%i)), " ms";

show"average time taken for a ",(string i)," row insert with no FK present is: ",(string (et2-st2)%(n%i)), " ms";
