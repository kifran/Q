/client
/connect to server process
h:hopen `::5000
/send single row insert asynch
(neg h)"`trade insert (9t;`A;1f)"; /string message format

/send bulk insert asynch
(neg h)(insert;`trade;(10?.z.T;10?`1;10?10f)); /list of function call message format

/send query synch and insert result to local table tl
`tl insert h"select from trade"

/send message assynch defining quote table on server
(neg h)(set;`quote;([]time:`time$();sym:`symbol$();bid:`float$();ask:`float$()));

/execute stored proc on server
show h"proc1[`A]"




/