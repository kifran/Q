/Functional/Dynamic Queries

/In each solution first is the example of standard query which then is transformed to functional form.

/1)
t:select from quote where date=2008.08.05,sym=`IBM

t:?[quote;((=;`date;2008.08.05);(=;`sym;enlist `IBM));0b;()]

/2)
delete from `t where (ask<bid) or (null bsize) or (null asize)

![`t;enlist (|;(<;`ask;`bid);(|;(null;`bsize);(null;`asize)));0b;`symbol$()]
 
/3)
delete ex from `t

![`t;();0b;enlist `ex]
 
/4)
update ratio:bid%ask from `t where ask>1.1*bid

![`t;enlist (>;`ask;(*;1.1;`bid));0b;(enlist `ratio)!enlist (%;`bid;`ask)]
 
/5)
exec minprice:min price, maxprice:max price from trade where date within (.z.d-3;.z.d-1)

?[trade;enlist (within;`date;(.z.d-3;.z.d-1));();`minprice`maxprice!((min;`price);(max;`price))]

/6) 
select from trade where sym=`IBM,not price>1.5

?[trade;((=;`sym;enlist `IBM);(not;(>;`price;1.5)));0b;()]
 
/7)
select last price by date,hour:time.hh, sym from trade

?[trade;();`date`hour`sym!(`date;`time.hh;`sym);(enlist `price)!enlist (last;`price)]
 
/8)
select mean:avg price, variance:var price, stdDev:dev price by date, hour:time.hh from trade where sym=`AIG

?[trade;enlist (=;`sym;enlist `AIG);`date`hour!(`date;`time.hh); `mean`variance`stdDev!((avg;`price);(var;`price);(dev;`price))]
 
/9)
select spread:avg bid-ask by date from quote where date within (.z.d-5;.z.d-1),sym=`CSCO

?[quote;((within;`date;(.z.d-5;.z.d-1));(=;`sym;enlist `CSCO));(enlist `date)!enlist `date;(enlist `spread)!enlist (avg;(-;`bid;`ask))]

/
\l required_tables.q   /load the script

10)
?[quote;();(enlist `sym)!(enlist `sym);(enlist `ask)!(enlist(max;`ask))]

11)
?[quote;();(enlist `sym)!(enlist `sym);(enlist `bid)!(enlist(min;`bid))]

12)
?[quote;();(`sym`exchange)!(`sym`exchange);(enlist `ask)!(enlist(max;`ask))]

13)
?[quote;();(enlist `exchange)!(enlist `exchange);(`bid`ask)!((last;`bid);(last;`ask))]

14)
?[quote;();(`sym`exchange)!(`sym`exchange);(`first_ask`min_bid)!((first;`ask);(min;`bid))]

15)
?[execution;();(`sym`account)!(`sym`account);(enlist `$"last - time")!(enlist(last;`time))]

16)
?[execution;();(enlist `sym)!(enlist `sym);(enlist `$"wavg - price")!enlist (wavg;`time;`price)]

17)
?[execution;();(`strategy_id`inserted_by)!(`strategy_id`inserted_by);(`max_price`min_price)!((max;`price);(min;`price))]

18)
?[execution;();(enlist `thresh)!enlist (>;`price;1.2);(enlist `execution_id)!(enlist `execution_id)]

19)
?[execution;();(`sym`client_id)!(`sym`client_id);(`max_price`last_exec)!((max;`price);(last;`execution_id))]


 
