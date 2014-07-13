/ 
This process is a slightly modified version of the mserve solution which can be found at code.kx:
https://code.kx.com/trac/wiki/Cookbook/LoadBalancing

The purpose of mserve is to provide load balancing capabilities so that queries from one or more clients
can be sent to the master who will send these queries in a load balanced way to the servants.
The servants will then send the results back to the master who sends the results back to the client

Sample usage:  q mserve_np.q -p 5001 2 servant.q

.z.x 0 - 1st argument - number of servant to start up
.z.x 1 - 2nd argument - the script we want each servant to load 

On startup of the master process, the following steps take place:
1. Master decide on the port numbers the servants will listen on
2. Master starts up the servant process listening on the required ports 
3. Master connects to the servants
4. Master sends a message to each servant telling servant to:
	a)define .z.pc such that servant terminates when master disconnects
	b)load in the appropriate script so the servant has data

We maintain a dictionary on the master process which keeps track on all the outstanding requests on the servants.
This dictionary maps each servant handle to a list of all client handles for whom that servant has requests currently
When a new request comes in, we do a count 

All the communication between client-master, master-servant, servant-master and master-client is asynchronous.

The changes in this script compared to the vanilla mserve solution Sare mainly making some of the code more transparent as well as redefining the .z.pc port close
function so that when a servant goes down, we ask the affected clients to resend their queries. We also
remove the dropped servant's handle from the dictionary of servants/requests we maintain

\

\c 10 150

/list of the port numbers the servants will listen on
p:(value"\\p")+1+til"I"$.z.x 0

/Start up the multiple servant processes
{system"q -p ",(string x)}each p


/ unix (comment out for windows)
/\sleep 1

/ connect to servants. h is a list of asynch handles
h:neg hopen each p;
/servant will terminate if disconnected from master
h@\:".z.pc:{exit 0}";
/servant loads in script
h@\:"\\l ",.z.x[1];

/map each servant asynch handle to an empty list and assign resultant dictionary back to h
/The values in this dict will be the handles back to the clients who send the queries
h!:()

/
.z.ps is where all the action resides. As said already, all communication is asynch, so any request from a client
or response from a servant will result in .z.ps executing on the master

input to .z.ps is x
There are 2 possibilities
1. x is a query received from a client
2. x is a result received from a servant

w stores the asynch handle back to whoever has sent the master the asynch message (either a client or servant)

We have an if else statement checking whether the call back handle .z.w to the other process exists in the key of h or not
if .z.w exists in h => message is a response froma servant
if .z.w does not exist in h => message is a request from a client

response logic:
1. use protected evaluation to attempt to send the result to the client who sent in the original request.
MAJOR ASSUMPTION - the servant process is single threaded. Therefore the response sent from the servant
corresponds to the earliest request received. Therefore h[hdl;0] is the appropriate client handle for the response

2. Remove the client handle from the start of the list in the servant's row of ther dict h

request logic
1.count up the number of outstanding requests on each servant <a:count each h>
2. Use the find function <?> to find the first servant with the minimum number of outstanding requests. Assign this
servant handle back to variable a. <a?:min a:count each h>
This step constitutes the load balancing aspect to the mserve solution 
3.Append the client's handle to the end of the list of client handles for the servant.<h[a?:min a:count each h],:w>
4. Asynchronously send a message to the servant telling him to execute an anonymous function
with the query x as input. <a(function;query)>
where function is <{(neg .z.w)@[value;x;`error]}>
This functions does the following:
a)servant uses protected eval to execute the query
b)result is send back asynch to the master (neg .z.w)
\

/fields queries. assign query to least busy servant
.z.ps:{show ".z.ps";show x;show .z.w;
	$[(w:neg .z.w)in key h;
		[.[{[data;hdl]h[hdl;0]@data};(x;w);{}];h[w]:1_h[w]]; /response
		[h[a?:min a:count each h],:w;a({(neg .z.w)@[value;x;`error]};x)] /request
	]
	}  

/remove key from h if slave goes down and send message to each affected client asking them to resend their queries
/input to .z.pc is the handle of the servant who has just gone down
.z.pc:{{x enlist"please resend query"}
	each h[neg x];
	h::h _ (neg x);} 
 
/.z.pg:{show .z.pg;show x;value x};
/\l mserve_modifications.q

/
client(h:hopen 5001):  (neg h)x;h[]

l64: 50us overhead(20us base)

