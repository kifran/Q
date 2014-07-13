
\l taq.q

/
The purpose of this function is to iterate over each date in the in memory trade/quote tables and for each date,
save down only the trades/quotes that took place on that date in splayed format to the appropriate date partition
on disk in the db database.

To achive this, we use the high level function .Q.dpft
This is a function which takes 4 arguments:

d - file handle to the top level of the database (where the date partitions and sym files reside)

p - partition. What is the particular partition we wish to write to. In the case of a date partitioned database,
p will be a given date

f - field or column name. Which column do we wish to sort the table by in ascending order prior to saving the table
to disk. This step is included as a means of speeding up important queries. 
For example, if a typical query on the historical trade table is:

select avg price from trade where date=2011.08.01,sym=`IBM

Then a sensible approach would be to save the trade table in a date partitioned database where within each date, the
trade table is sorted in ascending order on sym

t - name of the in memory table. Always pass in `trade, never trade or select from trade
\

trade_all:trade; /make reference copy of trade table
quote_all:quote; /make reference copy of quote table

date_part:{[dt]
		show dt;
		trade::delete date from select from trade_all where date=dt; /redefine trade to be only those trades on date dt
		quote::delete date from select from quote_all where date=dt; /redefine quote to be only those quotes on date dt
		{[dt;x].Q.dpft[`:db1;dt;`sym;x]}[dt;]each `trade`quote;
 };

date_part each exec distinct date from trade_all; /iterate over each date
trade:trade_all;
quote:quote_all;
delete trade_all,quote_all from `.







/