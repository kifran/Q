\l odbc.k

\c 10 150

h:.odbc.open `sql3.dsn

o:.odbc.eval[h]

/select data from sql to q
t1:o "select * from trade"
show t1;
/
/insert data from q to sql
o "INSERT INTO [model].[dbo].[trade] VALUES ('2011.07.20', 'FEB17','100.2','2000')"

o "INSERT INTO [model].[dbo].[trade] VALUES ('2011.07.20', 'FEB18','100.2','2000')"
/
n:4

dts:string each .z.D-til n
syms:string each `DEC5`DEC6
prices:string each n?100f
sizes:string each n?1000

f:{[i]
	data:"('",dts[i],"', '",syms[i],"', ",prices[i],",",sizes[i],")";
	/'breakpoint;
	o "INSERT INTO [model].[dbo].[trade] VALUES ",data;
 };
 
f each til n 

/confirm inserts worked correctly
t1:o "select * from trade"
show t1;
show exec distinct sym from t1;
