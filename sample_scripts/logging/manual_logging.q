
\l trade.q
/initialise the log file
.[`:file3;();:;()]
/open connection to the log file
h:hopen `:file3
/write out messages to the log file
h enlist(`upd;`trade;(.z.T;`IBM;100f;100));
h enlist(`upd;`trade;(.z.T;`MSFT;200f;200));
h enlist(`upd;`trade;(.z.T;`GOOG;300f;300));
h enlist(`upd;`trade;(.z.T;`VOD;400f;400));
h enlist(`upd;`trade;(.z.T;`BT;500f;500));
h enlist(`upd;`trade;(.z.T;`HSBC;600f;600));



/close connection to the log file
hclose h

/define update/replay function
upd:{[t;x]insert[t;x]};

delete from `trade

/replay log file
-11!`file3

/we could check to see how many lines are in the log file if desired
-11!(-2;`:file3)

/we could reply only the first n lines of the log file if desired
-11!(4;`:file3)

/we could load in the log file to examine it if desired
x:get `:file3














/