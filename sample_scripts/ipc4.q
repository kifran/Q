/
ipc4.q creates security so that only 2 users (nathan and lucy )can connect and send the server messages.
nathan can only invoke the stored procedures proc1 and proc2
lucy can only invoke the stored procedure proc1
\

\l taq.q
roles:`nathan`lucy!(("proc1";"proc2");(enlist"proc1"));

catch:{[e;m;f](0b;(m;e," ERROR OCCURED WHILE EXECUTING FUNCTION
	 ",f," WITH ARGUMENTS: ",-3!1_m))};

.z.pg:{[m]
	r:roles[.z.u];
	if[10h=type m;:"YOU MUST SUPPLY YOUR MESSAGE IN THE FORMAT:
	handle(\"function_name\";arg1;arg2;...;argN)"];
	f:first m;
	if[any 100 104h in type f;:"YOU CANNOT SEND YOUR OWN FUNCTION DEFINITION OR PROJECTION"];
	if[-11h=type f;f:string f];
	if[not any like\:[r;f];:"YOU ARE NOT PERMITTED TO EXECUTE THE FUNCTION
	 ",f," .YOUR ALLOWED FUNCTION ARE: ",sv[" and ";r]];
	res:@[{(1b;value x)};m;catch[;m;f]];
	last res
 };
 
.z.ps:{}; 