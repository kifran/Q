/1)
trade:([]time:`time$();sym:`symbol$();price:`float$();size:`int$())
syms:`IBM`GS`FD`KX
n:1000
insert[`trade;(n?"t"$.z.Z;n?syms;10*n?100.0;10*n?100)]
`time xasc `trade

/2)
select sum size by 5 xbar time.minute from trade

/3)
select sum size by 1 xbar time.minute from trade
select sum size by 2 xbar time.minute from trade
select sum size by 10 xbar time.minute from trade

/4)
select sum size by 10 xbar time.second from trade

/5)
select sum size by 60 xbar time.second from trade

/6)
select sum size by 5 xbar time.minute,sym from trade
select sum size by 60 xbar time.second,sym from trade


/7)
/Query the generated tables from the two questions and sum the size by time for the one with a sym column.
a:select sum size by time:3 xbar time.second,sym from trade
b:select sum size by time:3 xbar time.second from trade
b~select sum size by time from a

/Note:
/It will be noticed in all of the previous queries that if there has been no trades in a particular time bucket 
/then there will be no corresponding row to the table. If this is a problem it can be overcome 
/by constructing a grid with all the necessary rows, joining this with the query in question 
/and if necessary filling in the nulls in the table.

/8)
grid:{[start;end]([]time:(start+til 1+"i"$(end-start)))cross([]sym:syms)}
/this function takes the start and end times required and depending on the type of their input, 
/generates the necessary grid to complete the task.

grid[00:00;12:00]
grid[00:00:00;12:00:00]

/9)
grid[00:00;12:00]lj select sum size by time:3 xbar time.minute,sym from trade
grid[00:00:00;12:00:00]lj select sum size by time:3 xbar time.second,sym from trade

/10)
update size:0^size from grid[00:00;12:00]lj select sum size by time:3 xbar time.minute,sym from trade
update size:0^size from grid[00:00:00;12:00:00]lj select sum size by time:3 xbar time.second,sym from trade


tbl:([]sym:20#`FD`KX`VC;time:09:00+til 20;price:20?100)
t:09:00 09:02 09:05 09:10 09:17 09:20

/11)
select count i by bucket:t@t bin time from tbl

/12)
select sumPrice:sum price by bucket:t@t bin time from tbl

/13)
select times:time,sumPrice:sum price by t  bin time from tbl

/14)
select avPrice:avg price by bucket:t[1+t bin time] from tbl
