
queue: ()!() 

.z.ps:{ queue[.z.w]:x}

execute_handle:{
				(neg x)(value;value queue[x]);
				show "responding to request from handle ",string x;
				@[`.;`queue;:;((key queue) except x)#queue]}  
//- answers request then deletes entry from queue
















/