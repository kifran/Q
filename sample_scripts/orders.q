
\c 12 160
orders:([]time:`time$();order_id:`int$();sym:`$();size:`int$());
order_status:([]order_id:`int$();status:`$();size:`int$());

n:1000
portfolio:`IBM`GOOG`AAPL`IMID`IUKD`MDAX`GDAX`STOXX`IEX

order_ids:100000+1+til n;

order_data:(asc n?.z.T;order_ids;n?portfolio;1000+n?3000);

/.[`order_data;(2;til floor n%4);neg];

`orders insert order_data;

status:`accepted`cancelled`filled`partially_filled

m:n*4

`order_status insert (m?order_ids;m?status;m?2000);

v1:select from orders where time<01:30t,sym=`GOOG
v2:select status,size by order_id from order_status 
	where order_id in (exec distinct order_id from v1)
	
v3:v1 lj v2

v4:ungroup v3	

v5L:select order_id,status from v4 where not status=`cancelled

/which order_ids are in the table and which are not

x:99998+til 20 /x is a list of orders from ops

show x[where x in orders[`order_id]] /order_ids in table

show x[where not x in orders[`order_id]] /order_ids not in table

