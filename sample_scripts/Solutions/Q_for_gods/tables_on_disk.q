
/1)Add attribute `p (partitioned) to one column on disk

/Start a q session with an empty directory:
/c:\q>q test


// defining a suitable test table
tab:([]x:`a`b`c`d`a`b`c`d;y:til 8;z:"qwertyui")

// Saving test table as splayed
`:tab/ set .Q.en[`:.;tab]

key `:tab /display contents of spalyed table

// Applying `p fails as column x is not sorted
/@[`:tab;`x;`p#]

/error thrown:
/k){$[3=x;(y;`u#y i;(i:&~=':y),#y);(y;`u#!r;+\0,#:'x;,/x:. r:=y)]}
/'u-fail
/#
/`u
/`sym$`a`b`c`d`a`b`c`d

// Save again the splayed table sorted by column x:
`:tab/ set .Q.en[`:.;`x xasc tab]

// column x has the attribute `s (sorted) so we can add the p attribute to the x file
get`:tab/x /results in `s#`sym$`s#`a`a`b`b`c`c`d`d

// Apply `p attribute
@[`:tab;`x;`p#]

get`:tab/x /results in `p#`sym$`a`a`b`b`c`c`d`d

\l exDb.q  /script creates sample db

delete from `. /clear out workspace

\l exDb /load in the HDB

/IMPORTANT NOTE: Run the following OS commands to rename files/folders from the command line manually.
/Running these commands through the script is throwing a 'char error for some unknown Windows related reason.
/
/2)Change name of static table (productInfo -> symInfo)

/Windows: 
system”rename productInfo symInfo”

/Unix: 
/system”mv productInfo symInfo”

/3) Create symbol list of date partitions
parts:key[`:.]where key[`:.]like"[0-9]*"

/4)Change name of partitioned table (quote -> marketData)
/Windows:
tabs:string[parts],\:”\\quote” 

{[old;new]system"rename ",old," ",new;}[;“marketData”]each tabs;

/Unix: 
/tabs:string[parts],\:”/quote” 
/{[old;new]system"mv ",old," ",new;}[“marketData”]each tabs;


/5)Backfill trade table to all partitions
/Note - In this case the backfill has no affect since all partitions already have a trade table present
.Q.chk[`:.];

/6)Get list of column names from schema (.d file) for trade
schema:get` sv(hsym first parts),`trade,`.d

/7)Change order of columns (marketData: reverse column order
schemas:sv[`]each(hsym each parts),\:`marketData`.d
newSchema:reverse get first schemas
set[;newSchema]each schemas;

/8)Change name of column (trade: price -> val)
schemas:sv[`]each(hsym each parts),\:`trade`.d
newSchema:get first schemas
newSchema[newSchema?`price]:`val
set[;newSchema]each schemas;

/Windows:
cls:string[parts],\:”\\trade\\price” 
{[old;new]system"rename ",old," ",new;}[;“val”]each cls;

/Unix:
/cls:string[parts],\:”/trade/price” 
/{[old;new]system"mv ",old," ",new;}[;“val”]each cls;

/9)Make sym column of trade upper case
cls: sv[`]each(hsym each parts),\:`trade`sym
{[s]if[count cl:get s;s set`:sym?upper value cl]}each cls

/10)Remove size column from trade
schemas:sv[`]each(hsym each parts),\:`trade`.d
newSchema: (get first schemas)except`size
set[;newSchema]each schemas;
cls: sv[`]each(hsym each parts),\:`trade`size
hdel each cls;

/11)Create a function to list contents of directory and indicate whether each is a directory or file
f: {[d]k!`file`dir 0<(type key hsym sv[`]d,)each k:key d}
f`:.


	