/q db_gen.q -dir mydb/ -perday 1000000 - startday 2009.01.01 -noday 50 -symlist VOD.L,BAR.L,BMW.DE,CITG.NY,BNPP.PA

/Extract command line parameters and store in a dictionary of arguments. Left-join to a dictionary of defaults to ensure that each argument has a value
defaults:`dir`perday`startday`noday`symlist!("/mydb";"1000000";"2009.01.01";"5";enlist("VOD.L,BAR.L,BMW.DE,CITG.NY,BNPP.PA"))
args:defaults,.Q.opt .z.x

rc:{[x;y]first y$x}

/Cast each argument to the approriate datatype
args[`dir]:hsym rc[args[`dir];"S"]
args[`perday]:rc[args[`perday];"I"]
args[`startday]:rc[args[`startday];"D"]
args[`noday]:rc[args[`noday];"I"]
args[`symlist]:`$"," vs first args[`symlist]
args[`datelist]:args[`startday]+til args[`noday]

args[`symlist],:-100?`3;

/Work out how many records per sym, per day are needed to ensure the "perday" condition holds. Store this value in the "args" table for easy reference
args[`persym]:floor args[`perday]%count args[`symlist]

/To make things easier, assign n to args[`persym] - it's used a lot and this will make the code more readable
n:args[`persym]

/Create a table to hold the trade data
trade:([]date:`date$();sym:`symbol$();time:`time$();price:`float$();size:`int$())

/Create randomised trade data. Sizes are random multiples of 100. Prices attempt to follow on from each other. 
{[x]insert[`trade;0N!(n#(x 0);n#(x 1);asc n?24:00:00.000;sums (1?100.0),0.005-(n-1)?0.01;100*1+n?50)]} each args[`datelist] cross args[`symlist]

trade2:trade;

/Write to disk in 3 different ways - partitioned by date (sorted by time,sym/sorted by sym,time), partitioned by sym (sorted by date,time).
{[d]trade::`sym`time xasc delete date from (select from trade2 where date=d);.Q.dpft[` sv args[`dir],`ds;d;`sym;`trade]} each args[`datelist]
{[d]trade::`time`sym xasc delete date from (select from trade2 where date=d);.Q.dpft[` sv args[`dir],`dt;d;`time;`trade]} each args[`datelist]

/For the sym list we need to be slightly clever as q cannot partition by sym. Instead we partition by integer and assign a sym per integer.
/This also means we will have to save down a dictionary to recover the syms and use this in our queries
symdict:(a)!(til count a:distinct args[`symlist])
{[s]trade::`date`time xasc delete sym from (select from trade2 where sym=s);.Q.dpft[` sv args[`dir],`s;symdict[s];`date;`trade]} each args[`symlist]
set[` sv args[`dir],`$"s/symdict";symdict]