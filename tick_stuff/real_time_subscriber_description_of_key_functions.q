/*********************************************************************************************************
/
Function:
Summary:
Where is it used:
Input:
Output:
Example Usage:
Line by line description:

\
/*********************************************************************************************************

/*********************************************************************************************************
/
Function: .u.end
Summary: this function executes at EOD as a result of the TP sending a message telling it to do so.
It does the following:
1. Execute .Q.hdpf in order to:
	a)It saves it's tables to the on disk HDB in date partitioned format
	b)

	clears out the in memory tables
Where is it used: TP sends a message
Input:Previous date
Output:None
Example Usage:
Line by line description:
/Get a list of tables in the default namespace
t:tables`.;
/Get a list of tables which have the `g attribute present on the sym column
/modify @ form of apply with the each left adverb to loop over the sym column of each table
t@\:`sym;
/Test each column to see if g attribute is set
where `g=attr each 
/re define variable t to only be the subset of tables for which `g is set on sym column
t@:
/Execute function .Q hdpf t oachieve following:
/		a)Sort in memory tables on the sym column (performance measure to make some on disk queries faster)
/		b)Save down all table to disk in date partitioned format
/		c)Notify HDB process that on-disk has changed and therefore it should refresh
/		d)clear out tables
.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];	
/Clearing out the tables will cause the g attribute to be lost on a table. Therefore re-apply attribute as necessary
@[;`sym;`g#] each t;
	
\
.u.end:{[x]
	t:tables`.;
	t@:where `g=attr each t@\:`sym;
	.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];
	@[;`sym;`g#] each t;
	};
/*********************************************************************************************************


/*********************************************************************************************************
/
Function:.u.rep

Summary: This function does the following:
1. Initalise the TP tables on the RDB to be empty
2. Replay TP log file as necessary
3. CD to the top level of the HDB

Where is it used:
Executed in a rather complicated way on a standalone line when the RDB starts up.
Code: .u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";
Step 1:Open a connection to the TP process
(hopen `$":",.u.x 0) /this returns a handle to the TP
Step 2: Send a synch message to the TP telling it to do two things:
"(.u.sub[`;`];`.u `i`L)"
	First thing:
	.u.sub[`;`] /Execute the subscription function for all tables and all syms
	This will return a list of N pairs  where there are N tables on the TP. 
	For example, if there were 3 tables on the TP - trade,quote and kt1; then .u.sub[`;`] would return:
	(
		(`trade;([]time:`time$();sym:`$();price:`float$();size:`int$()));
		(`quote;([]time:`time$();sym:`$();bid:`float$();bsize:`int$();ask:`float$();asize:`int$()));
		(`kt1;([]time:`time$();sym:`$();city:`$();MC:`long$()))
	);
	Second thing: 
	`.u `i`L /Simply return a list of the form: (number_messages_in_tp_log_file;descriptor_of_tp_log_file) 
Let's say the output from steps 1 and 2 is (output_step1;output_step2)	
Step 3: Use the dot form of apply to execute the dyadic function .u.rep with the two outputs of step 2 as defined above 
.[.u.rep;(output_step1;output_step2)]

Input: (output_step1;output_step2) as defined above
1st input:list of N pairs where there are N tables on the TP. 
Each pair is of the form: (`tbl_name;empty_tbl)
2nd input: list of the form: (number_messages_in_tp_log_file;descriptor_of_tp_log_file)
	Example:(17497;`:C:/q_work/data/TP_schema2012.03.28). 
	This would mean there are currently 17497 messages in the log file which need to be replayed
	and the log file is located at `:C:/q_work/data/TP_schema2012.03.28

Output:None

Example Usage:.u.rep[
	(
	(`trade;([]time:`time$();sym:`$();price:`float$();size:`int$()));
	(`quote;([]time:`time$();sym:`$();bid:`float$();bsize:`int$();ask:`float$();asize:`int$()));
	(`kt1;([]time:`time$();sym:`$();city:`$();MC:`long$()))
    );	
	(17497;`:C:/q_work/data/TP_schema2012.03.28)
	];
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";

Line by line description:
/x is of the form ((`trade;empty_trade);(`quote;empty_quote);(`kt1;empty_kt1))
/Use the dot form of apply (right most .)
/to pass each of these pairs into a dyadic projection onto the dot form of amend (left most dot) 
/Clearer syntax:
		Dyadic_proj:{[tbl_name;empty_tbl].[tbl_name;();:;empty_tbl]}
		.[Dyadic_proj;((`trade;empty_trade);(`quote;empty_quote);(`kt1;empty_kt1))]
/The purpose of this line, is simply to create empty tables on the RDB
(.[;();:;].)each x;		
/The next thing to do is replay the TP log file (IFF there are any messages in it)
/Check if there message count in the log file is null. If so, the log file is empty and .u.rep is finished so return
if[null first y;:()];
/Otherwise, there are messages in the log file which need to be replayed		
-11!y; /standard TP log file replay function
/Next, we want to change directory to the top level of the HDB
/For example: If the TP log file descriptor is: `:C:/q_work/data/TP_schema2012.03.28
/Then the top level of the HDB is therefore C:/q_work/data/TP_schema
system "cd ",1_-10_string first reverse y
\
.u.rep:{[x;y]
	(.[;();:;].)each x;
	if[null first y;:()];
	-11!y;
	system "cd ",1_-10_string first reverse y
	};
/*********************************************************************************************************
