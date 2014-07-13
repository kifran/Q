

\l broken1

\c 10 100

monitor:{[dt;tbl]
	show dt;
	files:`$(":",(string dt),"/",(string tbl),"/"),/:string key `$":",(string dt),"/",(string tbl);
	/ddd;
	show "COUNT: ",-3!COUNT:count each get each files;
	/yyy;
	show "ALL THE SAME COUNT: ",-3!SAME_COUNT:1=count distinct 1_COUNT;
	/yy::COUNT;
	show "HCOUNT: ",-3!HCOUNT:hcount each files;
	show "TYPE: ",-3!TYPE:type each get each files;
	};
	
tbl:`trade;
dates:date;

monitor[;tbl]each dates