\l taq.q
chunk_size:10000 /number of rows you wish to write at a time

flag:0b; /flag to switch behaviour from 1st chunk to remaining chunks
chunk_writer:{[chunk]
		$[not flag; /initially this condition is true. On subsequent iterations, it is false
		[
		show "first chunk";
		(neg h)0:[",";chunk]; /first chunk should have column names
		/yyy;
		flag::1b; /set flag to true so remaining chunks will be treated differently
		];
		[
		show "other chunk";
		(neg h)1_(0:[",";chunk]); /remaining chunks should not have column names
		]];
 };

h:hopen `:data/file1.txt /open a handle to the text file we wish to write to
chunk_writer each cut[chunk_size;trade]; /write out table in incremental chunks
flag:0b;
hclose h /close handle to file
/
/verify that we wrote table out correctly
t1:read0 `:data/file1.txt /read back in file

0:[`:data/file2.txt;0:[",";trade]] /write out table in one chunk

t2:read0 `:data/file2.txt  /read back in file

t1~t2 /verify two results are the same