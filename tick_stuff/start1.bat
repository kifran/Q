start "Start Tickerplant on port 5000" q tick.q TP_schema C:/q_work/data -p 5000 -t 500
start "Start Real Time Database on port 5001" q tick/r.q localhost:5000 localhost:5002 -p 5001
start "Start Sample Feed" q sample_feed_np.q
start "Start Historical Database on port 5002" q hdb_np.q C:/q_work/data/TP_schema -p 5002
start "Start RTS1 on port 5003" q tick/rts1.q localhost:5000 localhost:5002 -p 5003 
