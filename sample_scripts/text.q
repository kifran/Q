/
The purpose of this script is to demonstrate how we can write our in memory tables to disk as
delimited text files. This script will also demonstrate how we can read such text files into memory
\

\l taq.q

/write in memory tables to disk as delimited text files

/
First approach - save function

The save function is a simple but limited way of writing in memory tables to disk in either
comma delimited (.csv), tab delimited (.txt), xml or xls format

This function takes a single argument - the file handle to the file we wish to create on disk
A file handle is a symbol with a leading ':' which gives the full or relative path to a file or directory

Q figures out the in memory table to be saved and the type of delimiting to use from the file name.
eg: 
save[`:data/trade.csv]

this command will save the in memory table called trade to disk as a comma separated file called trade.csv in the subdirectory
data.
\

/save[`:data/trade.csv];
/save[`:data/trade.txt];
/save[`:data/trade.xml];

/save[`:data/trade.xls];

/
Second Approach - 0: function
0: is an overloaded low level operator used for the purpose of writing data to text files and also reading text files into 
memory. It allows for more flexibility compared to the save function at the expense on increases terseness

It is used in three distinct but related ways.

1. Convert in memory table to a list of strings

eg: 
x1:0:[",";trade];

The above creates a list of strings of length N+1 where there are N rows in the trade table.
Each row of the trade table is converted to a string where each datapoint is separated from it's neighbour by a ','
The first string in the list consists of the column names separated by the ',' character.

2. Save list of strings to text file on disk
eg:
0:[`:data/file1.txt;x1];

The above code saves the list of strings to disk in file1.txt in the subdirectory data.

3. Read text file into memory with appropriate casting

There are two cases.
Case A - first row of text file are column headers as opposed to data
Case B - first row of text file is data, as are all other subsequent rows

Case A example:
tbl1:0:[("DTSFIS";enlist",");`:data/file1.txt];

-	The "," tells q to tokenise the data based on the ','
-	Enlist tells q to treat the first row of the text file as column headers, not data. The presence of the word
	'enlist' acts as a switch

-	"DTSFIS" is specifying the datatypes to be used to cast the columns once they have been read into memory as strings
	"D" - date
	"T" - time
	"S" - symbol
	"F" - float
	"I" - int
	"*" - don't cast. i.e. read in but keep as string
	" " - don't read column into memory

-	`:data/file1.txt file handle of the file to be loaded in

-The resultant variable tbl1 is an in memory table contains well typed trade rows

Case B example:

Manually edit file1.txt by removing the column headers. Now the first row of the file is the first row
of the trade table. Save this edited file as file4.txt

c:cols[trade] /c contains the column names of the trade table as a list of symbols

data:0:[("DTSFIS";",");`:data/file1.txt];

-	We do not enlist the delimiter. This switch tells q that the first row of the text file should be loaded as data,
	not column headers. There is no column header information in this file. Therefore q cannot turn this data into a table

-	The resultant variable data is a well typed column oritentated list. It is not a table	

tbl2:flip c!data;

-	Create a dictionary mapping the original trade column names 'c' to the column oritentated list 'data'

-	The resultant variable tbl2 is an in memory table containing well typed trade rows	
\

/x1:0:[",";trade];
/x2:0:["|";trade];
/x3:0:["\t";trade];

/0:[`:data/file1.txt;x1];
/0:[`:data/file2.txt;x2];
/0:[`:data/file3.txt;x3];

lookup:(",";"|";"\t")!(".csv";".txt";".txt") /dictionary mapping delimiters to file extensions


/
The purpose of the writer function is to save an in memory table to disk as a directory of text files.
One file per sym. So all the IBM rows will be in one file, all the MSFT rows in another file etc.

writer takes three arguments - table name 't' , sym 's' and delimiter 'd'
\
writer:{[t;s;d]
	t1:value"select from ",(string t)," where sym=`",(string s); /build the dynamic query as a string and evaluate using value
	/t1 is a table containing the subset of rows for the input sym 's' 
	d1:0:[d;t1]; /convert the table t1 to a list of strings where each datapoint is separated from it's neighbour with the delimiter 'd'
	p:hsym `$"data/",(string t),"/",(string s),lookup[d]; /build the path to the text file we wish to create
	0:[p;d1]; /write data in d1 to the file given by p
 };
 
/create a projection where we fix the table as `quote and the delimiter as ','
/Execute the resultant monadic projection over each distinct stock in the quote table
update index:i from `quote;
/writer[`quote;;","]each exec distinct sym from quote 
/
reader is the opposite of writer. reader iterates over the directory of text files created by writer
and inserts the data from each file into the appropriate in memory table

reader takes four arguments - table name 't' , sym 's',datatypes for the columns 'dt' and delimiter 'd'
\
reader:{[t;s;dt;d]
	show s;
	p:`$":data/",(string t),"/",(string s),lookup[d]; /build the path to the text file
	x:0:[(dt;enlist d);p]; /load the data from the text file into memory as a table x
	insert[t;x]; /insert the table x into the global table t
 };

delete from `quote /clear out quote table from memory
/projection where we fix the table as `quote, the datatypes as "DTSFIFIS" and the delimiter as ','
/Execute the resultant monadic projection over each stock  
/reader[`quote;;"DTSFIFISI";","]each portfolio
/`index xasc `quote;
/delete index from `quote;

/read
/read in a file with column headers
t1:0:[("DTSFIS";enlist ",");`:data/file1.txt];

col_names:cols t1;

/ignore some columns
t2:0:[(" T FIS";enlist ",");`:data/file1.txt]

/read in some columns as strings
t3:0:[("D**FI*";enlist ",");`:data/file1.txt]

/read in a file without column headers
/x:0:[("DTSFIS";",");`:data/file4.txt];
/t2:flip col_names!x;

/load in text file as a list of strings
y:read0[`:data/file1.txt]; /read0 does not attempt to cast, tokenise or turn data into a table


/
chunk reading
The function .Q.fs allows users to load large text files into memory chunk by chunk as opposed to loading
in the entire file in one go. Therefore this new approach would have a lower memory footprint for large tables

.Q.fs ensures that each chunk is a whole number of rows. By default the largest possible chunk size is approximately 
131kb

eg:
.Q.fs[chunk_reader;`:data/quote.csv]

-	1st argument is the function to apply to each in memory chunk
-	2nd argument is the file handle to the text file

\

flag:0b; /flag to switch behaviour from 1st chunk to remaining chunks
chunk_reader:{[chunk]
		$[not flag; /initially this condition is true. On subsequent iterations, it is false
		[
		show "first chunk";
		quote::0:[("DTSFIFIS";enlist ",");chunk]; /first chunk contains column headers (case A)
		/resultant table used to initialise global quote table
		flag::1b; /set flag to true so remaining chunks will be treated differently
		];
		[
		show "other chunk";
		quote,:flip(cols quote)!0:[("DTSFIFIS";",");chunk]; /remaining chunks do not contain column headers (Case B)
		/resultant table is appended to the global quote table
		]];
 };

delete quote from `.; 

\t .Q.fs[chunk_reader;`:data/quote.csv]; 
flag:0b;
/
show"larger chunks";
.Q.fs:value ssr[string .Q.fs;"131000";"5000000"]; /change the largest possible chunk size to desired number of bytes

\t .Q.fs[chunk_reader;`:data/quote.csv]; 
	
