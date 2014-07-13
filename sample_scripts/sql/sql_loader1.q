\l odbc.k

\c 10 150

h:.odbc.open `sql1.dsn

o:.odbc.eval[h]

/select data from sql to q
t1:o "select * from trade"
show t1;

/insert data from q to sql
o "INSERT INTO [model].[dbo].[trade] VALUES ('2012-04-12', '14:37:55.001','APR12','100.2','2000','N')"

n:4

dts:string each .z.D-til n
times:string each .z.T-til n
syms:string each `APR12`APR13
prices:string each n?100f
sizes:string each n?1000
ex:string each `N`D



f:{[i]
	data:"('",dts[i],"', '",times[i],"', '",syms[i],"', ",prices[i],",",sizes[i],", '",ex[i],"')";
	/'breakpoint;
	o "INSERT INTO [model].[dbo].[trade] VALUES ",data;
 };
 
f each til n 

/confirm inserts worked correctly
t1:o "select * from trade"
show t1;
show exec distinct sym from t1;
