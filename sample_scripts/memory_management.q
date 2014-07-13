/
This script demonstrates how memory management works in q.
Specifically, this script demonstrates behaviour as of version 2.7

\

\c 30 300

/**************************************** .Q.w[]*************************************************************
show".Q.w[] example";

show .Q.w[] /this function returns a dictionary displaying memory statistics of a q process. For example:
/
used| 112640 /the subset of the heap in bytes which is currently in use

heap| 67108864 /the amount of physical memory in bytes which is currently allocated to this q process

peak| 67108864 /the largest size that the heap has ever been throughout the lifetime of this q process

wmax| 0 /the artificial memory cap to a process. If set from the command line with -w flag,the q process will terminate
/if it attempts to have more than the specificed number of MBs allocated to it 

mmap| 0 /the number of bytes that are currently being memory mapped from files on disk making up the HDB.
/only non zero if the process is currently reading from one or more such files

syms| 556 /The number of distinct symbols in this q process.Every distinct symbol in a q process is mapped to a unique
/integer in a hidden hash map.

symw| 16004 /the memory footprint of the hidden symbol hash map
\
/**************************************** \w *************************************************************
show"\\w example";
show "\\w";
/In older versions of q, .Q.w[] was not present. The older, less user friendly way of obtaining the above statistics is
/\w and \w 0 :
\w
/112512 67108864 67108864 0 0j /used heap peak wmax mmap
show "\\w 0";
\w 0
/556 16004j /syms symw

/**************************************** .Q.gc[] *************************************************************

show ".Q.gc[] example";
/
The function .Q.gc is the garbage collection function in q. When executed, it identifies all objects on the heap
that no longer have any references and are 64MB or larger. .Q.gc will destroy such objects and return their memory
to the Operating System.
\
show"Attempt garbage collection";
.Q.gc[]
/0j - Q was not able to de allocate any memory to the OS

show"build a large vector";

x:til 40000000 /build a large object
show".Q.w[]`used`heap shows memory has gone up";
.Q.w[]`used`heap /used and heap increase accordingly
/268548240 335544320j

show"remove large vector";
delete x from `. /remove the x reference
/`.
show".Q.w[]`used`heap shows used memory has gone back down but heap remains unchanged";
.Q.w[]`used`heap /used goes down but the heap remains unchanged (since q does not garbage collect automatically)
/112048 335544320j
show"Attempt garbage collection";
.Q.gc[]
/268435456j
show".Q.w[]`used`heap shows garbage collection has freed up the memory previously associated with x and the heap has decreased";
.Q.w[]`used`heap
/112048 67108864j /The heap is now reduced

/**************************************** system"g"*************************************************************
/
system "g" (or \g) is a system command which stands for garbage collection. It's default value is zero. This means
that by default, q does not garbage collect automatically when a reference (to an object >64MB) is removed.
We saw this behaviour in the previous example. 
However, if we set this parameter to 1 (system"g 1" or \g 1), then objects that are elibable for garbage collected
will be garbage collected automatically as soon as they become eligable.
Eg:
\
show"";
show"system\"g\" example";
show"Create large vector";
x:til 40000000
.Q.w[]`used`heap
/268548240 335544320j
show"Garbage collection flag is 0 by default, meaning no automatic garbage collection";
\g
/0 - default value
show"Turn auto garbage collection on by setting \\g to 1";
\g 1  /turn auto garbage collection on
\g
show"delete x from `.";
delete x from `.
show".Q.w[]`used`heap shows garbage collection has taken place";
.Q.w[]`used`heap
/112784 67108864j - the decrease in the heap is evidence that garbage collection 
/has taken place.

/**************************************** Column Orientated Tables and Reference copies *************************************************************
show"";
show"The next example demonstrates that a table in kdb+ is a collection of columns";

n:20000000
show"Create a table with ",(string n)," rows";
t1:([]c1:til n;c2:n?`A`B`C;c3:n?100f);
show".Q.w[]`used`heap";
.Q.w[]`used`heap /the physical memory usage has increased considerably due to the 3 columns

show"Number of references to t1 is:";
-16!t1 /the -16! shortcut gives a reference count on an object. i.e - how many references are pointing at the object
/By default, an object would have a single reference to it

show"t2:select from t1";
t2:select from t1 /make a reference copy of the table. Q is smary enough to realise that this query does not
/require an actual copying of the columns (yet)

show".Q.w[]`used`heap";
.Q.w[]`used`heap /memory usage has not increased
show"Number of references to t1 is:";
-16!t1 /the reference count on t1 has now increased to 2. There are 2 identical references to t1 now.
/As long as t1 and t2 do not diverge, the reference count stays at 2.

show"update c2:`X from `t1 where i=0";
update c2:`X from `t1 where i=0 /modifying the first row of c2 causes a complete copy of this column
show"modifying the first row of c2 causes a complete copy of this column";
show".Q.w[]`used`heap";
.Q.w[]`used`heap /the whole table was not copied however, only c2. t1 and t2 both point at the same c1 and c3

show"Number of references to t1 is:";
-16!t1 /Because t1 and t2 are no longer entirely in synch, the reference count jumps back down to 1

show"update c1+10 from `t1";
update c1+10 from `t1 /modifying the column c1 causes a complete copy of this column
show"modifying the column c1 causes a complete copy of this column";
show".Q.w[]`used`heap";
.Q.w[]`used`heap /the whole table was not copied however, only c1. t1 and t2 both point at the same c3

show"update c3:0f from `t1";
update c3:0f from `t1 /modifying the column c3 causes a complete copy of this column
show"modifying the column c3 causes a complete copy of this column";
show".Q.w[]`used`heap";
.Q.w[]`used`heap /Now t1 and t2 each have their own complete set of columns

show"delete t2 from `.";
delete t2 from `.
show"Now only t1 in memory";
show".Q.w[]`used`heap";
.Q.w[]`used`heap /Now only t1 in memory

show"t3:delete from t1 where i=0";
t3:delete from t1 where i=0;
show"Entire copies of columns c1,c2 and c3 were required";
show".Q.w[]`used`heap";
.Q.w[]`used`heap /Entire copies of columns c1,c2 and c3 were required











/