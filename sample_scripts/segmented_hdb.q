/builds a segmented date partitioned database.
/2 segments - C:/q_work/db1 and C:/q_work/db2
/The root directory for this database is `:C:/q_work/segmented_db
/which contains the par.txt file. This file lists the locations of the 2 segments

segment_builder:{[dt]
	show"build segment for ",-3!dt;
	system"l taq2.q";
	.Q.dpft[`:C:/q_work/segmented_db;dt;`sym;`trade];
	.Q.dpft[`:C:/q_work/segmented_db;dt;`sym;`quote];
 };
 
segment_builder each .z.D-1+til 11;

delete from `.
\l C:/q_work/segmented_db

/.Q.P - contains the list of segments that have been loaded (i.e. the contents of par.txt)
show .Q.P;

/.Q.D - lists out the partitions contained in each segment
show .Q.D;

/.Q.PD - lists out the path for each partition
show date!.Q.PD;

/.Q.pd - .Q.PD as modified by .Q.view
show count .Q.PD;
.Q.view 2#date
show count .Q.PD;
show count .Q.pd;
.Q.view[];
show count .Q.PD;
show count .Q.pd;


/