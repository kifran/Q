/Define the number of rows to put into the table
n:9000000

/Generate a random table of sym,price and size
t:([]sym:n?-2000?`3;price:n?10.0;size:n?1.0)

testsym:1# exec distinct sym from t

/Save table as splayed table (use .Q.en because of sym column)
`:tsplayed/ set .Q.en[`:.;t]

/Delete t from the workspace to clear up
delete t from `.

/Load directory to read in the saved table (tsplayed)
\l .

/Select on a sym. Do 1 times to increase overall retrieval time
/Store result as r1 so we can compare to other queries
/Show meta of the table to highlight the lack of attribute

show "without attributes";
show meta tsplayed;
show "";
\t do[1;r1:select from tsplayed where sym in testsym]
show "";

show "with g attribute";

/Add a `g# (grouped) attribute
@[`:tsplayed/;`sym;`g#];

show meta tsplayed;
show "";
\t do[1;r2:select from tsplayed where sym in testsym]
show "";

show "with s attribute";

/Sort ascending by sym. This will add a `s# attribute
`sym xasc `:tsplayed/

show meta tsplayed;
show "";
\t do[1;r2:select from tsplayed where sym in testsym]
show "";

show "with p attribute";

/Add a `p# (parted) attribute. This can be applied as the 
/list is sorted in ascending order, by sym
@[`sym xasc `:tsplayed/;`sym;`p#]

show meta tsplayed;
show "";
\t do[1;r2:select from tsplayed where sym in testsym]

