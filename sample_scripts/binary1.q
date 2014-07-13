\l taq.q
\c 30 160
/write

save `:db/trade
load `:db/trade

set[`:db/file1;select from trade]; /unkeyed table
set[`:db/file2;(`a;10;.z.D)]; /heterogeneous list
set[`:db/file3;portfolio]; /homogeneous list
set[`:db/file4;ref1]; /keyed table

set[`:db/dns;value `.]; /save entire default namespace as a dictionary to disk as a single binary file

/read
delete from `.; /clear out default namespace

/load each file individually into memory
x:get[`:db/file1];
y:get[`:db/file2];
z:get[`:db/file3];
k:get[`:db/file4];
dns:get[`:db/dns]; /load in old default namespace as a dictionary called dns

/we can get a list of all files and folders at the top level of a directory using the key function:
contents:key `:db /this returns the file and folder names as a list of symbols


/
This function takes a variable name as input called k.
It grabs the associated data for that variable name from the dictionary dns and saves as local variable data.
It then creates a variable in the default namespace and assigns data to that variable.
It uses the @ form of amend to achieve this.

This function is a programatic way of reconstructing the default namespace from the file dns
\
historical_load:{[k]
	data:dns[k];
	@[`.;k;:;data];
 };

historical_load each key dns; 


/
The next two lines demonstrate how we can append to on disk tables saved previously as single binary files
\

/grab the first 1000 rows from the in memory trade table and save as t
t:trade[til 1000];

insert[`:db/file1;t]; /append the 100 rows to the end of a file on disk















/