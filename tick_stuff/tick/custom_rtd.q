/q tick/custom_rtd.q [host]:port[:usr:pwd] [host]:port[:usr:pwd]
show "custom_rtd.q";
/
This custom RTD appends intra day updates to on disk date partitioned trade table 
This means the EOD
\

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

\l tick/binary3.q

if[not "w"=first string .z.o;system "sleep 1"];

/TP Log replay definition of upd
upd_replay:{[t;x]
	t insert x;
 };

\l trade.q /temp
delete from `trade /temp
/initialise splayed table on disk

/intra day updates to on disk date partitioned trade table 
upd_trade:{[x]
	`trade insert x;
	h[` sv `:db,(`$string .z.D),`trade,`sym]@`:db/sym?x[`sym];/update sym files
	{[data;c]h[` sv `:db,(`$string .z.D),`trade,c]@data[c]}[x;]each (cols x)except `sym;/update remaining files
 };

/Real time definition of upd 
upd_realtime:`trade`quote!(upd_trade;{});
 
/ end of day
/clear out table
.u.end:{
	delete from `trade;
	(`$":db/",(string .z.D),"/trade/") set .Q.en[`:db;trade];
	};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{
	(.[;();:;].)each x;
	if[null first y;:()];
	-11!y;
	system "cd ",1_-10_string first reverse y
	};
/ HARDCODE \cd if other than logdir/db

/set upd to replay definition initially
upd:upd_replay;

/ connect to ticker plant for (schema;(logcount;log))
/.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

/Initialise today's partition of the on disk database with data received so far today
(`$":db/",(string .z.D),"/trade/") set .Q.en[`:db;trade];

delete from `trade

/Establish open file handles to each columns' file on disk
h!:hopen each h:{[t;c]` sv `:db,(`$string .z.D),t,c}[`trade;]each 1_key ` sv `:db,(`$string .z.D),`trade

/switch to intra day definition of upd
upd:upd_realtime

/temp
n:1
.z.ts:{
	upd[`trade;flip`time`sym`price`size!(.z.T+n?100;n?`4;n?100f;n?100)];
 };
\t 20



