start "Start Server on 5001" q server -l -p 5001
start "Start Feed on 5002" q feed.q -p 5002
start "Start Replication on 5003" q -r 5001 -p 5003