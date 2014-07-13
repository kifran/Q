\l C:/q_work/data1
\c 200 200

N:count date /number of partitions/dates

/.Q.pn - the first time the process counts the number of rows in each partition of a table, it then
/caches the resulting counts. These cached partition row counts will make subsequent row count queries 
/per partition almost instantaneous
/the cached partition counts can be viewed by the function .Q.pn
/If you invoke the .Q.view function (explained below), this will clear the caches partition row counts
show .Q.pn;
quote_counts:.Q.cn quote /count the number of rows in each partition
show .Q.pn;

/.Q.view - this function limits the partitions in scope. Can be a useful way of limiting the
/worst case memory footprint of poorly formed queries (eg: no date where clause)

show select count sym by date from trade;
.Q.view -2#date /limits the partitions in scope to just the last 2 dates. 
show count date;
show select count sym by date from trade;
.Q.view[] /resets the number of partitions in scope to all partitions
show count date;
show select count sym by date from trade;

/.Q.qp - used to check whether a table is partitioned, splayed or in memory
/.Q.qp[tbl] returns 1b if tbl is partitioned
/.Q.qp[tbl] returns 0b if tbl is splayed
/.Q.qp[tbl] returns 0 if tbl is neither partitioned nor splayed (i.e an in memory table)
show .Q.qp[trade]; /partitioned
show .Q.qp[t1]; /splayed
show .Q.qp[([]c1:10 20)];

/.Q.qt this function will return true if the input is any kind of a table
show .Q.qt[trade]; /true for partitioned
show .Q.qt[t1]; /true for splayed
show .Q.qt[([]c1:10 20)]; /true for in memory unkeyed
show .Q.qt[([c0:`a`b]c1:10 20)]; /true for in memory keyed
show .Q.qt[`c0`c1!10 20]; /false for anything else

