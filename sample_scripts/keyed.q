/
This script creates and modifies keyed tables. A keyed table is a table which has a primary key composed
of one of more columns. 

Keyed table introduction:

The type of a keyed table is 99h whereas the type of an unkeyed table is 98h.
Dictionaries in q have a type of 99h. Under the surface, a keyed table is a dictionary
mapping one unkeyed table (primary key columns) to another unkeyed table (remaining columns)
eg: kt1:([c1:1 2 3;c2:`a`a`b]c3:"QWE";c4:10 20 30)
kt1 is a keyed table where c1 and c2 form the primary key
(([]c1:1 2 3;c2:`a`a`b)~key kt1)and(([]c3:"QWE";c4:10 20 30)~value kt1)

A keyed table can be accessed in the following ways:
1. qSQL - select, exec, update and delete (exactly the same as unkeyed tables)
2. Dictionary of dictionaries
Examples: 
kt1[(1;`a)]
kt1[`c1`c2!(1;`a)]
kt1[(2;`a)]:("U";12)
kt1[`c1`c2!(1;`a)]:("T";11)
kt1[(10;`X)]:("V";13)

\

/
ref1 has a single column as a primary key. The values in this column should be unique 
but this is not enforced
\
ref1:([sym:`IBM`MSFT`GOOG`YHOO]
	name:("IBM";"Microsoft";"Google";"YAHOO");
	cusip:`ABC123`DEF456`GHI789`JKL012;
	city:(`Armonk;`Redmond;`Sunnyvale;`$"San Francisco");
	MC:10000000000j*1+4?10
 );

/
Now we turn our attention to how to add new data to a keyed table
Unlike unkeyed tables, we do not use the insert function, instead we use the upsert function
Insert would fail. 
Upsert will add a new row (insert behaviour) if the data pertains to a new key 
Upsert will update an existing row (update behaviour) if the data pertains to an existing key 
The data input to the upsert function can either be a dictionary, an unkeyed table,a keyed table
or a row orietated list
In all cases, the data object must have data pertaining to the primary key column(s) of the destination
table otherwise the upser will fail.
\
 
/data1 is a dictionary pertaining to an existing key (`MSFT). Update behaviour
data1:`sym`name!(`MSFT;"Windows 7");

upsert[`ref1;data1]; 
/Only the name field changed. All other columns for MSFT remained the same

/data2 is a dictionary pertaining to a new key (`VOD). Insert behaviour
data2:`sym`name`city!(`VOD;"Vodafone";`London); 

upsert[`ref1;data2];
/The fields MC and cusip are initialised to nulls of the appropriate type
/because data2 did not contain these fields

/make a copy of the ref1 table called x
x:ref1; 

/data3 is an unkeyed table
data3:([]sym:`IBM`BOI;name:("Lenovo";"Bank of Ireland"));

/Each row of data3 will implicitely be upserted one at a time
/The first row of data3 results in an update (`IBM exists in ref1)
/The second row of data3 results in an insert (`BOI does not exist in ref1)
upsert[`ref1;data3];

/make a keyed copy of data3 using the xkey function and upsert this keyed table into ref1
upsert[`x;xkey[`sym;data3]];
/There is no change in behaviour if you upsert a keyed table as data or an unkeyed table as data
/The next line proves this using the match operator
show ref1~x

/data4 is a heterogenous list containing data for a single row of ref1
/If the data is a list, you must specify data for every column in the table
/Furthermore, the columns must be in the same order as the destination table 
data4:(`GOOG;"Chrome";`FFF567;`Boston;100000000000j);
upsert[`ref1;data4];
 
/
ref2 has 2 columns as it's primary key. It is the combinations of these columns that should be unique 
but this is not enforced
\
 
ref2:([sym:`IBM`MSFT`GOOG`YHOO;ex:4#`N]
	name:("IBM";"Microsoft";"Google";"Yahoo");
	cusip:`ABC123`DEF456`GHI789`JKL012;
	city:(`Armonk;`Redmond;`Sunnyvale;`$"San Francisco");
	MC:10000000000j*1+4?10
 );

/
There is no change in behaviour of upsert if the destination table has more than one column forming it's
primary key
\ 

/data1 is a dictionary pertaining to an existing key (`sym`ex!(`IBM;`N)). Update behaviour 
data1:`sym`ex`name!(`IBM;`N;"Lenovo");
`ref2 upsert data1

/data2 is a dictionary pertaining to a new key (`sym`ex!(`DELL;`O)). Insert behaviour 
data2:`sym`ex`name!(`DELL;`O;"Dell Inc");
`ref2 upsert data2;
/data3 is an unkeyed table.
/Each row of data3 will implicitely be upserted one at a time
/The first row of data3 results in an update (`sym`ex!(`DELL;`O) exists in ref2)
/The second row of data3 results in an insert (`sym`ex!(`GW;`N) does not exist in ref2)

data3:([]sym:`DELL`GW;ex:`O`N;name:("DELL COMP";"Gateway");MC:1000000000 2000000000j);
`ref2 upsert data3;


/We typically define our tables (both keyed and unkeyed )to be empty
ref3:([sym:`symbol$()]
	name:();
	cusip:`symbol$();
	city:`symbol$();
	MC:`long$()
 ); 
 /
 
 /xkey is used to either to transform a table from unkeyed to keyed and vice versa
 /This will remove the key from ref1
 /xkey[();`ref1]
 /This will key ref1 by date and sym
 /ref1:`date`sym xkey update date:.z.D from ref1
 
 /Extract the value columns form ref1 and treat the resultant unkeyed table as a dictionary of lists
 /(value[ref1])[`city]
 
 
 
 
 