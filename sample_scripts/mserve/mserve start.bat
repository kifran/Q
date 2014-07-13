start "Start Master Process on 5000" q mserve_np.q -p 5000 4 servant.q
start "Start Client 1" q client.q -sym IBM -master 5000
start "Start Client 2" q client.q -sym MSFT -master 5000
start "Start Client 3" q client.q -sym GOOG -master 5000
start "Start Client 4" q client.q -sym YHOO -master 5000