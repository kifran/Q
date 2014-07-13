/
Foreign keys are enumerations linking one or more columns of a source table to the key column(s) of a 
lookup/keyed table
Their two main features are:
1. Linking data from source to lookup is faster compared to vanilla lj/ij
2. referential data integrity linking the source table to the lookup table
\

\l taq.q
\c 15 150

show"Foreign Key Example 1 - ref1 is keyed on sym (1 column in the key)";

/create fk
update fk1:`ref1$sym from `trade /enumerate the sym column implicitely against the key column of ref1

/Foreign keys provide faster look ups for data from keyed table compared to vanilla lj

show"fk";
\t do[100;res1:select date,time,price,size from trade where fk1.city=`Armonk]

show"explicit lj";
\t do[100;res2:select date,time,price,size from select from lj[trade;ref1] where city=`Armonk]

res1~res2

/Foreign keys also provide referential data integrity linking the trade table to ref1 such that only trades for those
/stocks listed in ref1 can be inserted into the trade table

unknown_symbols:delete fk1 from delete from trade;

try:{[x]
	x:raze[(x;`ref1$x[2])];
	/x:x,`ref1$x[2];
	/break;
	`trade insert x;show"insert succeeded"
	};

catch:{[e;d]show e," error on insert";
	if[e~"cast";`unknown_symbols insert d]}	

upd:{[t;d]
	/t insert d;
	@[try;d;catch[;d]];
	};

/insert succeeds
upd[`trade;(.z.D;.z.T;`IBM;100f;100;`N)];	

/insert fails
upd[`trade;(.z.D;.z.T;`XEROX;100f;100;`N)];	

show"Foreign Key Example 2 - ref2 is keyed on sym,ex (2 columns in the key)";
/In order to create this foreign key, we must add more rows to ref2 so that every combination of sym,ex
/that is present in trade is listed in ref2

x:distinct select sym,ex from trade
data:`sym`ex`city`MC!(x[`sym];x[`ex];(count x)?`5;(count x)?1000000000j)
upsert[`ref2;flip data]

/create fk
update fk2:`ref2$flip(sym;ex)from `trade

/Foreign keys provide faster look ups for data from keyed table compared to vanilla lj
show"fk";
\t do[100;res1:select date,time,price,size from trade where fk2.name like "Microsoft"]

show"explicit lj";
\t do[100;res2:select date,time,price,size from (select from lj[trade;ref2] where fk2.name like "Microsoft")]

res1~res2
/s

/unknown_symbols:delete fk1,fk2 from delete from trade;

/add extra field to data which contains an extra field - the enumeration of (sym;ex)

/insert succeeds
data:(.z.D;.z.T;`IBM;100f;100;`N);

@[{x:raze[(x;`ref1$x[2];`ref2$x[2 5])];`trade insert x;show"insert succeeded"};data;
	{[e]show e," error on insert";
	if[e~"cast";`unknown_symbols insert data]}];

/insert fails
data:(.z.D;.z.T;`IBM;100f;100;`UNKNOWN);

@[{x:raze[(x;`ref1$x[2];`ref2$x[2 5])];`trade insert x;show"insert succeeded"};data;
	{[e]show e," error on insert";
	if[e~"cast";`unknown_symbols insert data]}];






/