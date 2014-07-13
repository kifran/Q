/1)
/code to generate a sample trade.csv file
n:100
trade:([]date:`date$();sym:`symbol$();size:`int$();price:`float$();cond:`char$());
`trade insert (n?.z.D;n?`3;n?100;n?100f;n?"abcdefgh");
save `:trade.csv

/Start q on the same directory as the file "trade.csv" and do: 
trade:("DSIFC";enlist ",") 0: `:trade.csv
delete trade from `. /clean up workspace after test

/2)
/Run to create a folder of csv files containing mock trade data:

g:{([]date:x?$[`date;.z.Z] - til 3;sym:x?`3;size:50*x?10;price:10*x?10.0;cond:x?"abcdefgh")}
f:{(`$"files/file",(string x),".csv") 0: csv 0: g rand 10000}
f each 1+til 9
/Run this from the same location as the "files" folder: 
trade:`date xasc raze 0:[("DSIFC";enlist ",");] each {` sv `:files,x} each key `:files

/
/3)
/Ensure the file 'odbc.dll' is in the q/w32 directory
\l odbc.k
.odbc.load `test.mdb

/4)
d:.odbc.open `test.mdb
.odbc.tables d
.odbc.eval[d;"select * from Table1 where size=1000"]
.odbc.close d

