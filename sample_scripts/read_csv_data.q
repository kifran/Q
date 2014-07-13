/sample usage: q read_csv_data.q -dir C:/q_work/dba_public_ny_jan2010/data

inputs:.Q.opt[.z.x]

a:first inputs[`dir]
b:string key hsym a

/
q)meta trade
c       | t f a
--------| -----
time    | t
sym     | s
price   | f
size    | i
ex      | s
trade_id| C
\

res1:{x,"\\",y}[a;]each b
file_handles:{hsym `$x}each res1

f:{[file]
		`trade insert ("TSFIS*";enlist ",")0:file;
 };
 
f each file_handles