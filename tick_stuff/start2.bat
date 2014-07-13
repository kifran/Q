start "Start Tickerplant on port 5000" q tick.q TP_schema C:/q_work/data -p 5000
start "Start Chained Tickerplant on port 5001" q chainedtick.q :5000 -p 5001 -t 1000
start "Start CTP Subscriber on port 5002" q tick/chainedr.q localhost:5001 -p 5002
start "Start Writer on port 5003" q tick/w.q localhost:5000 -p 5003
start "Start Sample Feed" q sample_feed_np.q

