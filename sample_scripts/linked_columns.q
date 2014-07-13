/Linked Columns
/Example 1
/use a link column from a table to itself to create a parent-child relationship
t:([] id:101 102 103 104; v:1.1 2.2 3.3 4.4);

/To create the column parent, we look up the values in the key column using ? (find function) 
/and then declare the link using ! (instead of $ as we would for a foreign key enumeration). 

update parent:`t!id?101 101 102 102 from `t;
show meta t;

show res1:select id, parentid:parent.id from t;


/Example 2

sym:`IBM`GOOG`MSFT
t1:([]c1:`sym$sym; c2:10 20 30;c3:"ABC");

t2:([]col1:6?sym; col2:6?10f);

update link2:`t1!((t1.c1)?col1) from `t2;

show res2:select from t2 where link2.c3="A";

\l fk.q

update I:i from `ref2
update link:`ref2!ref2[;`I]flip(sym;ex)from `trade

show select from trade where link.I=0














/

