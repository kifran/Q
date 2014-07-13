/sample usage: q check_hdb.q -hdb broken1 -all
usage:"q check_hdb.q -hdb C:/q/DB -dt 2010.03.03\n or \n q check_hdb.q -hdb C:/db/broken1 -all"

inputs:.Q.opt[.z.x]

hdb:hsym first `$inputs[`hdb];

/inputs[`hdb]:hsym first`$inputs[`hdb]

/if[`dt in key inputs;inputs[`dt]:"D"$inputs[`dt]];
/if[`all in key inputs;inputs[`all]:first"I"$inputs[`all]];


$[`dt in key inputs;
		date:"D"$inputs[`dt];
  `all in key inputs;@[{value"\\l ",x};first inputs[`hdb];
  {show"REMOVE ALL NON KDB+ FILES FROM ",first inputs[`hdb];exit 1}];
  show usage];
 
/@[{config::get hsym `$(first inputs[`hdb]),"/config"};`;{show"CONFIG FILE DOES NOT EXIST IN DIRECTORY ",first inputs[`hdb];exit 1}];  

/tbls:exec distinct TBL from config
tbls:`trade`quote


check_dates:{[dt]
		db_h:(string hdb),"/",(string dt),"/";
		contents:key hsym `$(first inputs[`hdb]),"/",string dt;
		check_tbls[dt;contents];
		check_tbl[dt;;db_h]each inter[tbls;contents]; 
		
 };

 check_tbls:{[dt;contents]
	missing_tbls:tbls except contents;
	extra_files:contents except tbls;
	if[count missing_tbls;
	show("check_tbls date ",(string dt)," missing table "),/:string missing_tbls];
	if[count extra_files;
	show("check_tbls date ",(string dt)," extra_file "),/:string extra_files];
 };
 
check_tbl:{[dt;tbl;db_h]
		tbl_cols:exec COL from config where TBL=tbl;
		types:exec TYPE from config where TBL=tbl;
		attributes:exec ATTR from config where TBL=tbl;
		contents:(key `$db_h,(string tbl))except `.d;
		missing_files:tbl_cols except contents;
		extra_files:contents except tbl_cols;
		if[count missing_files;
		show("check_tbl date ",(string dt)," table ",(string tbl)," missing file "),/:string missing_files];
		if[count extra_files;
		show("check_tbl date ",(string dt)," table ",(string tbl)," extra_file "),/:string extra_files];
		
		data:(inter[tbl_cols;contents])!{[tbl;db_h;file]get[`$db_h,(string tbl),"/",string file]}[tbl;db_h;]each inter[tbl_cols;contents];
		check_count[data;dt;tbl];
 }; 

/check if count of each file is the same
check_count:{[data;dt;tbl]
	if[1<count distinct value count each data;
	show"check_count date ",(string dt)," table ",(string tbl)];
 };
 
check_dates each date


/functions to check data in hdb
/
/db:`$":C:/Users/Nathan/Documents/My Dropbox/work/Training_Logistics/Manuals/qDBA/q_for_DBAs_Exercises/Broken_DBAs_Example/broken1"



dt:2009.01.02
tbl:`quote

tbl_cols:`sym`time`bid`bsize`ask`asize

types:tbl_cols!(11 19 9 6 9 6h);


/splayed table checks

splay_tbl:`$(string db),"/",(string dt),"/",(string tbl),"/"

data:tbl_cols!{get[`$(string splay_tbl),(string x)]}each tbl_cols;

/check_count[data] 
 
/check if type of each file matches config 
check_type:{

 }; 