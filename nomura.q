//Q1

// A function that applies f on the specified cols of t
// @param lc: list of columns
// @param t : a (non keyed) table
// @param f : a monadic function to apply to the columns lc
// @return  : a list of rows with f applied on it

fun:{[lc;t;f] flip f t[lc]}

/ q)t
/ c1 c2 c3 
/ ---------
/ 0  10 100
/ 1  11 101
/ 2  12 102
/ 3  13 103
/ 4  14 104
/ q)f:{x*10}
/ q)fun[`c1`c2;t;f]
/ 0  100
/ 10 110
/ 20 120
/ 30 130
/ 40 140


//Q2
// Improve g to indicate that an error occured inf f and what the error was
f:{x*3};
g:{f[x]+1};
g:{ f1:@[f;x;"Error in f"]; 
    if[ 10h=type f1; 
        show f1;
        f[x];
        :];
   f1+1}

/ q)g[10]
/ 31
/ q)g[`0]
/ "Error in f"
/ {x*3}
/ 'type
/ *
/ `0
/ 3



// Q3
match:{[t1;t2] 
       commonCols: (cols t1) inter (cols t2); 
       (cols t1) xcol t2 ij commonCols xkey t1}

/ q)t1:(c1:`a`a`c;c2:`a`a`g;c3:1 2 3)
/ q)t1:([] c1:`a`a`c;c2:`a`a`g;c3:1 2 3)
/ q)t2:([] c1:`a`c;c3:2 3)
/ q)match[t1;t2]
/ c1 c2 c3
/ --------
/ a  2  a 
/ c  3  g 


// IPC
//I1
/ given 
/ Local process  q -p 4242
/ Local function flocal:{show x}
/ Remote process q -p 4141
/ Remote function fremote:{10}
/ Using async function call, we send a request to the remote process to evaluate a function fremote, an call back asynchronously function flocal, passing the result of function fremote"
/ On local process:
h: hopen `:hostremote:portremote;
(neg h) "r:fremote[]; (neg .z.w)  (\"flocal\"; \"r\") "



// 3 Performance
// P1
/ Use attribute #g on c2
/ This attribute will be conserved during inserts


//4 Queries
The table is splayed ( presumably by date ), so date should be the first constraint in our where clause, to reduce the dataset examined by the query as much as possible as early as possible.
I assume that "the change in price is" means "change in 2 consecutive prices."
Query:

select max abs deltas price by time.hh from t where date in (2012.01.01,2012.12.31), sym=`$"VOD.L"

// 5 Design
//D1 
Multiple cores and IO channels: Partition the data over several disks and IO channels to leverage map/reduce with multiple slaves.
If the daily data is very large, consider segmenting it over several IO disks ( see KDB+ for mortals ), into hourly partitions or partitions by region, or by asset range for example. Map-reduce will also work there. 

//D2
Small amounts of data, long queries: use multithreaded input to allow non blocking query processing. If CPU becomes a bottleneck, consider putting the data on a dedicated shared disk ( NAS ) accessed by several machines.

Large amounts of data. Here IO is likely to be a bottleneck. Localize the data and use fusion IO for example. If that is not enough, consider caching. To scale up more and address high CPU + high IO, consider breaking the table(s) down into several tables on several machines and add a process to aggregate the data on the way out.


