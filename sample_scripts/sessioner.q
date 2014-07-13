I:0
f:{[x;y]d:abs y-x;if[d>00:00:01t;I+:1];I};

modify:{
	res:f':[exec `time$time from requests];
	update session_id:res from `requests;
	};
	
\t modify[]	