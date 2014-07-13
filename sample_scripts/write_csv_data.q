/sample usage: q write_csv_data.q -dir C:/q_work/dba_public_ny_jan2010/data

inputs:.Q.opt[.z.x]

dir:first inputs[`dir]
dir:hsym `$dir

\l script2.q

write_data:{[s]
	t:select from trade where sym=s;
	file_handle:`$(string dir),"/trade_",(string s),".csv";
	0:[file_handle;0:[",";t]];
 };
 
\t write_data each exec distinct sym from trade; 

0:[`$(string dir),"/trade_meta.csv";0:[",";meta trade]];