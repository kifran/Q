\l taq.q

jobs:([]hdl:`int$();id:`int$();request:();callback:();finished:`boolean$());

/message signature: (callback_func;request)
/example call from client:
/
h:hopen 5001
results:();
queries:([id:enlist 0N]start_time:0Nt;end_time:0Nt;query:enlist();result:enlist();finished:0b;success:0b);

acknowledge:{show "acknowledge at time: ",-3!.z.T;show x;`queries upsert x};

callback1:{show "callback1 at time: ",-3!.z.T;show x;`queries upsert x};

(neg h)(`callback1;"select max price from trade where sym=99")
(neg h)(`callback1;"select max price from trade")
\

.z.ps:{
	$[0<count jobs;maxid:exec max id from jobs;maxid:0];
	(neg .z.w)@(`acknowledge;`start_time`query`id!(.z.T;x;maxid+1));
	`jobs insert (.z.w;maxid+1;x[1];x[0];0b);
 };

.z.ts:{
	outstanding_jobs:select from jobs where not finished;
	if[0<count outstanding_jobs;
	maxid:exec max id from outstanding_jobs;
	j:exec from outstanding_jobs where id=maxid;
	res:@[value;j[`request];{`error}];
	$[res~`error;success:0b;success:1b];
	(neg j[`hdl])@(j[`callback];`id`end_time`finished`success`result!(j[`id];.z.T;1b;success;res));
	update finished:1b from `jobs where id=maxid;
	/delete from `jobs where id=max id
	];
 }; 
 
/\t 3000 