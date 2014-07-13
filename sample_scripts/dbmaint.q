/ kdb+ partitioned database maintenance

/ * private
\d .os
WIN:.z.o in`w32`w64
pth:{p:$[10h=type x;x;string x];if[WIN;p[where"/"=p]:"\\"];(":"=first p)_ p}
cpy:{system$[WIN;"copy /v /z ";"cp "],pth[x]," ",pth y}
del:{system$[WIN;"del ";"rm "],pth x}
delpart:{system@("rm -rf ";"rmdir ")[WIN],pth x}
ren:{system$[WIN;"ren ";"mv "],pth[x]," ",pth[y]}
here:{hsym`$system$[WIN;"cd";"pwd"]}

\d .
add1col:{[tabledir;colname;defaultvalue]
    if[not colname in ac:allcols tabledir;
        stdout"adding column ",(string colname)," (type ",(string type defaultvalue),") to `",string tabledir;
        num:count get(`)sv tabledir,first ac;
        .[(`)sv tabledir,colname;();:;num#defaultvalue];
        @[tabledir;`.d;,;colname]]}

allcols:{[tabledir]get tabledir,`.d}

allpaths:{[dbdir;table]
    files:key dbdir;
    if[any files like"par.txt";
        :raze allpaths[;table]each hsym each`$read0(`)sv dbdir,`par.txt];
    files@:where files like"[0-9]*";
    (`)sv'dbdir,'files,'table}

allpart:{[dbdir]
    files:key dbdir;
    if[any files like"par.txt";
        :raze allpart each hsym each`$read0(`)sv dbdir,`par.txt];
    ` sv'dbdir,'files@where files like"[0-9]*"}

backuppar:{[partdir]
    stdout"changing partition ",(string partdir)," to ",(string partdir),"_old";
    .os.ren[partdir;`$(string partdir),"_old"];}

modpar:{[partdir;days]
    dateold:"D"$string last ` vs partdir;
    datenew:dateold+days;
    stdout"changing partition ",(string dateold),"_old to ",(string datenew);
    .os.ren[`$(string partdir),"_old";` sv (-1_` vs partdir),`$string datenew];}

clear1tbl:{[dbdir;table;dt]
    dir:` sv dbdir,(`$string dt),table;
    .os.delpart[dir];
    .Q.chk[dbdir];}

copy1col:{[tabledir;oldcol;newcol]
    if[(oldcol in ac)and not newcol in ac:allcols tabledir;
        stdout"copying ",(string oldcol)," to ",(string newcol)," in `",string tabledir;
        .os.cpy[(`)sv tabledir,oldcol;(`)sv tabledir,newcol];
        @[tabledir;`.d;,;newcol]]}

delete1col:{[tabledir;col]
    if[col in ac:allcols tabledir;
        stdout"deleting column ",(string col)," from `",string tabledir;
        .os.del[(`)sv tabledir,col];
        @[tabledir;`.d;:;ac except col]]}

move1tbl:{[srcdbdir;dstdbdir;srctbldir]
    dsttbldir:`$(string dstdbdir),(count string srcdbdir)_string srctbldir;
    stdout"moving ",(string srctbldir)," to ",string dsttbldir;
    col:allcols[srctbldir];
    putdst[srctbldir;dsttbldir;srcdbdir;dstdbdir] each col;
    @[dsttbldir;`.d;:;col];}

putdst:{[srctbldir;dsttbldir;srcdbdir;dstdbdir;col]
    data:value ` sv srctbldir,col;
    at:attr data;
    if[(type data) within 20 97h;
        if[not `sym in key dstdbdir;@[dstdbdir;`sym;:;`s#enlist `]];
        `sym set get srcdbdir,`sym;
        data:value data;
        `sym set get dstdbdir,`sym;
        data:`sym?data;
        @[dstdbdir;`sym;:;sym]];
    @[dsttbldir;col;:;at#data];
    `sym set get srcdbdir,`sym;}

merge1tbl:{[dbdir1;dbdir2;table;date;ucol]
    stdout"merging ",(string table)," for ",date:string date;
    date:`$date;
    tbldir1:` sv dbdir1,date,table;
    tbldir2:` sv dbdir2,date,table;
    col:allcols[tbldir1];
    if[not col~allcols[tbldir2];stdout"mismatch in table schemas";:()];
    if[not ucol in col;stdout"column ",(string ucol)," not present in ",string table;:()];
    data1:value ` sv tbldir1,ucol;
    data2:value ` sv tbldir2,ucol;
    if[data1~data2;stdout"tables are identical";:()];
    missing1:where not data2 in data1;
    mergecol[dbdir1;dbdir2;tbldir1;tbldir2;missing1] each col;}
    

mergecol:{[dbdir1;dbdir2;tbldir1;tbldir2;mergeidx;col]
    data:value ` sv tbldir1,col;
    ad:(value ` sv tbldir2,col)mergeidx;
    $[(type data) within 20 97h;
        [`sym set get dbdir1,`sym;
         data:value data;
         `sym set get dbdir2,`sym;
         data,:value ad;
         data:`sym?data;
         @[dbdir2;`sym;:;sym];
         @[tbldir2;col;:;data];
         data:value data;
         `sym set get dbdir1,`sym;
         data:`sym?data;
         @[dbdir1;`sym;:;sym];
         @[tbldir1;col;:;data]];
        [data,:ad;
         @[tbldir1;col;:;data];
         @[tbldir2;col;:;data]]];}
    
    

remove1tbl:{[tbldir]
    stdout"deleting ",string tbldir;
    .os.delpart[tbldir];}

enum:{[tabledir;val]
    if[not 11=abs type val;:val];
    .[p;();,;u@:iasc u@:where not(u:distinct enlist val)in v:$[type key p:(`)sv tabledir,`sym;get p;0#`]];`sym!(v,u)?val}

find1col:{[tabledir;col]
    $[col in allcols tabledir;
        stdout"column ",(string col)," (type ",(string first"i"$read1((`)sv tabledir,col;8;1)),") in `",string tabledir;
        stdout"column ",(string col)," *NOT*FOUND* in `",string tabledir]}

fix1table:{[tabledir;goodpartition;goodpartitioncols]
    if[count missing:goodpartitioncols except allcols tabledir;
        stdout"fixing table `",string tabledir;
        {[tabledir;goodpartition;x]add1col[tabledir;x;0#get goodpartition,x]}[tabledir;goodpartition]each missing]}

fn1col:{[tabledir;col;fn]
    if[col in allcols tabledir;
        oldattr:-2!oldvalue:get p:tabledir,col;
        if[(type oldvalue)=87;oldvalue:{x y}[oldvalue;til count oldvalue]];
        if[(type oldvalue) within 20 97;oldvalue:value oldvalue];
        $[not $[`]~fn;newattr:-2!newvalue:fn oldvalue;
          newattr:-2!newvalue:fn each oldvalue];
        if[$[not oldattr~newattr;1b;not oldvalue~newvalue];
            stdout"resaving column ",(string col)," (type ",(string type newvalue),") in `",string tabledir;
            oldvalue:0;
            newvalue:enum[tabledir;newvalue];
            .[(`)sv p;();:;newvalue]]]}

reordercols0:{[tabledir;neworder]
    if[not((count ac)=count neworder)or all neworder in ac:allcols tabledir;
        '`order.error];
    stdout"reordering columns in `",string tabledir;
    @[tabledir;`.d;:;neworder]}

rename1col:{[tabledir;oldname;newname]
    if[(oldname in ac)and not newname in ac:allcols tabledir;
        stdout"renaming ",(string oldname)," to ",(string newname)," in `",string tabledir;
        .os.ren[(`)sv tabledir,oldname;(`)sv tabledir,newname];
        @[tabledir;`.d;:;.[ac;where ac=oldname;:;newname]]]}

rename1tbl:{[tabledir;newname]
    newtabledir:` sv (-1_` vs tabledir),newname;
    stdout"renaming ",(string tabledir)," to ",string newtabledir;
    .os.ren[tabledir;newtabledir];}

sort1tbl:{[tabledir;sortcol]
    stdout"sorting ",(string tabledir)," based on column ",string sortcol;
    i:iasc o:get w:` sv tabledir,sortcol;
    (` sv tabledir,`tmptest) set o i; / try save to temporary file first just in case
    hdel ` sv tabledir,`tmptest; 
    w set o i;
    {[i;d;f] set[wp;(get wp:` sv d,f)[i]];}[i;tabledir] each (cols tabledir) except sortcol;}


stdout:{-1(raze(string`date`second$.z.z),\:" "),x;}

validcolname:{$[all(sx:string x)in .Q.an;(first sx)in .Q.a,.Q.A;0b]}

/ * public

thisdb:`:. / if functions are to be run within the database instance then use <thisdb> (`:.) as dbdir

addcol:{[dbdir;table;colname;defaultvalue] / addcol[`:/data/taq;`trade;`noo;0h]
    if[not validcolname colname;'(`)sv colname,`invalid.colname];
    add1col[;colname;enum[dbdir;defaultvalue]]each allpaths[dbdir;table];}

castcol:{[dbdir;table;col;newtype] / castcol[thisdb;`trade;`size;`short]
    fncol[dbdir;table;col;newtype$]}

checkfile:{[file]
    $[-1~@[value;file;-1];show "Error loading file ",1_string file ;show "File ",(1_string file)," is OK"];}

clearattrcol:{[dbdir;table;col] / clearattr[thisdb;`trade;`sym]
    setattrcol[dbdir;table;col;(`)]}

copycol:{[dbdir;table;oldcol;newcol] / copycol[`:/k4/data/taq;`trade;`size;`size2]
    if[not validcolname newcol;
        '(`)sv newcol,`invalid.newname];
    copy1col[;oldcol;newcol]each allpaths[dbdir;table];}

deletecol:{[dbdir;table;col] / deletecol[`:/k4/data/taq;`trade;`iz]
    delete1col[;col]each allpaths[dbdir;table];}

findcol:{[dbdir;table;col] / findcol[`:/k4/data/taq;`trade;`iz]
    find1col[;col]each allpaths[dbdir;table];}

/ adds missing columns, but DOESN'T delete extra columns - do that manually
fixtable:{[dbdir;table;goodpartition] / fixtable[`:/k4/data/taq;`trade;`:/data/taq/2005.02.19]
    fix1table[;` sv dbdir,goodpartition,table;allcols ` sv dbdir,goodpartition,table]each allpaths[dbdir;table] except ` sv dbdir,goodpartition,table;}

fncol:{[dbdir;table;col;fn] / fncol[thisdb;`trade;`price;2*]
    fn1col[;col;fn]each allpaths[dbdir;table];}

listcols:{[dbdir;table] / listcols[`:/k4/data/taq;`trade]
    allcols first allpaths[dbdir;table]}

movetbl:{[srcdbdir;dstdbdir;table]
    allsrc:allpaths[srcdbdir;table];
    alldst:allpaths[dstdbdir;table];
    move1tbl[srcdbdir;dstdbdir] each allsrc;}

removetbl:{[dbdir;table]
    remove1tbl each allpaths[dbdir;table];}
    

renamecol:{[dbdir;table;oldname;newname] / renamecol[`:/k4/data/taq;`trade;`woz;`iz]
    if[not validcolname newname;
        '(`)sv newname,`invalid.newname];
    rename1col[;oldname;newname]each allpaths[dbdir;table];}

renametbl:{[dbdir;oldname;newname]
    rename1tbl[;newname]each allpaths[dbdir;oldname];}

reordercols:{[dbdir;table;neworder] / reordercols[`:/k4/data/taq;`trade;reverse cols trade]
    reordercols0[;neworder]each allpaths[dbdir;table];}

setattrcol:{[dbdir;table;col;newattr] / setattr[thisdb;`trade;`sym;`g] / `s `p `u
    fncol[dbdir;table;col;newattr#]}

shiftpar:{[dbdir;days]
    parts:allpart[dbdir];
    backuppar each parts;
    modpar[;days] each parts;}

sorttbl:{[dbdir;table;sortcol]
    sort1tbl[;sortcol] each allpaths[dbdir;table];}

\
test with www.kx.com/q/taq/tq.q (sample taq database)

if making changes to current database you may need to reload (\l .) to make modifications visible

if the database you've been modifying is a tick database don't forget to adjust the schema (tick/???.q) to reflect your changes to the data
