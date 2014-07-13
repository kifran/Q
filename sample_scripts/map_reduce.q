/MAP REDUCE

/The aggregates that q can decompose with map-reduce are:
/avg, cor, count, cov, dev, first, last, max, min, prd, sum, var, wavg, wsum

/When any of the above aggregations are invoked in a query against a partitioned table, q will implicitely
/solve the problem in a map-reduce fashion - i.e compute a partial result SEQUENTIALLY for each partition 
/(map stage). Then q will combine these results in some specific way (reduce stage)

/This approach has the advantage that the memory footprint of the query will not go up as the number of
/partitions goes up. This is not the case for a non map reduced approach. 

/In a non map reduced approach, the memory footprint of the query will be proportional 
/to the number of partitions

/Map reduction has the effect of making the query more memory efficient because q doesnt have 
/to load the column(s) from the relevant partitions into memory as one big vector(s).

/for example: select avg price from trade will be solved as follows:
/Step 1: compute 2 fields sequentially per partition: sum of price and count of price
/Step 2: Sum these 2 sets of values and divide them	

\l C:/q_work/data1

/
/Example 1
show"Example 1 - Select avg bsize from quote";
/run the query for n days
/increase n for each test

/Map Reduce solution will consume less memory
show"Map Reduce Solution";

/time taken will increase with n but not memory required
mr:{[n]
	show (string n)," days";
	.Q.gc[]; / garbage collect so the starting heap size for the current test is same as the previous test . 
			/otherwise the current test will have an advantage (less memory allocating would speed up query)
	/show system"w";
	show system"ts select avg bsize from quote 
	where date within (date[0];date[",(string n),"])";
	/show system"w";
	show"";
 };
 
mr each 1+til 18; 

/Non map reduce solution will consume more memory
/time taken will increase with n as well as memory required
show"Non Map Reduce Solution";

nmr:{[n]
	show (string n)," days";
	.Q.gc[]; / garbage collect so the starting heap size for the current test is same as the previous test . 
			/otherwise the current test will have an advantage (less memory allocating would speed up query)
	/show system"w";
	show system"ts select (sum bsize)%count i from select bsize from quote 
	where date within (date[0];date[",(string n),"])";
	/show system"w";
	show"";
 };
nmr each 1+til 18;

/Example 2
show"Example 2 - Select avg bsize by sym from quote";
/This will be more memory and time consuming because of the in memory bucketing by sym that is required 
/run the query for n days
/increase n for each test

/Map Reduce solution will consume less memory
show"Map Reduce Solution";

/time taken will increase with n but not memory required
mr:{[n]
	show (string n)," days";
	.Q.gc[]; / garbage collect so the starting heap size for the current test is same as the previous test . 
			/otherwise the current test will have an advantage (less memory allocating would speed up query)
	/show system"w";
	show system"ts select avg bsize by sym from quote 
	where date within (date[0];date[",(string n),"])";
	/show system"w";
	show"";
 };
 
mr each 1+til 12; 

/Non map reduce solution will consume more memory
/time taken will increase with n as well as memory required
show"Non Map Reduce Solution";

nmr:{[n]
	show (string n)," days";
	.Q.gc[]; / garbage collect so the starting heap size for the current test is same as the previous test . 
			/otherwise the current test will have an advantage (less memory allocating would speed up query)
	/show system"w";
	show system"ts select (sum bsize)%count i by sym from select bsize,sym from quote 
	where date within (date[0];date[",(string n),"])";
	/show system"w";
	show"";
 };
nmr each 1+til 12; 
\
n:`int$(count date)%2

/We can build our own map reduce solutions
/Example - build our own explicit map reduce solution for avg calculation
proc1:{[dts]
	res:select AVG:(sum s)%(sum c)from 
	select s:sum `long$bsize,c:count i by date from quote where date in dts;
	res
 };

.Q.gc[];
show"implicit map reduce solution using built in avg function";
\ts res2:select AVG:avg bsize from quote where date in n#date
    
.Q.gc[]; 
show"explicit map reduce solution for avg bid";
\ts res1:proc1 @ n#date
show"";  
 



 
