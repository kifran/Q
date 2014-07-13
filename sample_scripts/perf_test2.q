f_par:{[dt]
	show"f entered with date ",-3!dt;
	delete from `.;
	system"l perf_test.q";
	.Q.dpft[`:dbt;dt;`id;`quote];
	`:dbt/y set y;
 };
 
f_par each .z.D-til 20 

\l dbt
/
/test1
\t do[1;res1:select max bid0 by sym from quote]
\t do[1;res2:select max bidn[;0] by sym from quote]
\

/test2
\t do[1;res1:select from quote where sym=`GOOG,ex=`N,location=`TK]
\t do[1;res2:select from quote where id=y[`GOOG`N`TK]]












/