/ cx.q
/ example clients 

x:.z.x 0             / client type
s:enlist `MSFT`IBM   / default symbols to read
t:`trade`quote       / default tables
h:hopen `::5010      / connect to tickerplant 

/ rdb
if[x~"rdb";s:`all;upd:insert]

/ high low close volume
if[x~"hlcv";
 t:`trade;
 hlcv:([sym:()]high:();low:();price:();size:());
 upd:{[t;x]hlcv::select max high,min low,last price,sum size by sym 
    from(0!hlcv),select sym,high:price,low:price,price,size from x}]

/ last
if[x~"last";s:`all;
 upd:{[t;x].[t;();,;select by sym from x]}]

/ show only
if[x~"show";s:`all;upd:{show x;show y}]

/ all trades with then current quote
if[x~"tq";
 upd:{[t;x]$[t~`trade;
   @[{tq,:x lj q};x;""];
   q,:select by sym from x]}]

/ vwap for each sym
if[x~"vwap";
 t:`trade;
 upd:{[t;x]vwap+:select size wsum price,sum size by sym from x}]

{h("sub";x;s)} each t;
