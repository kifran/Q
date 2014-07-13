

hdb_builder:{[dt]
	show"build hdb for ",-3!dt;
	system"l rtd.q";
	.Q.dpft[`:C:/q_work/db;dt;`sym;`trade];
	.Q.dpft[`:C:/q_work/db;dt;`sym;`quote];
 };
 
hdb_builder each .z.D-1+til 10;