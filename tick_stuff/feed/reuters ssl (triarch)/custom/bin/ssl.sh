#!/bin/bash
# Takes a variable number of sym files and creates an ssl feed for each sym file.
# echo current working directory should be $QSRCDIR

if [ -z $KDBHOME ]; then
    echo "KDBHOME must be defined in the environment"
    exit 1
fi

. `dirname $0`/functions
. $KDBHOME/LOCALCONFIG/q.env

usage()
{
    echo "Usage: $0 config_file"
    exit 1
}

if [ ${#@} -ne 1 ]; then
    usage
fi

source_file $1
check_var_exists QINSNAME
check_var_exists QPORT
check_var_exists NUM_INSTANCES
check_var_exists SYMFILE_PREFIX

cd $QSRCROOT

echo "Number of symfiles: $NUM_INSTANCES"

for x in `seq 0 $((NUM_INSTANCES - 1))`
do
  nohup $QHOME/l32/q $QSRCROOT/q/ssl.q -tp localhost:`expr $QPORT + 10` -symfile $SYMFILE_PREFIX$x -insname $QINSNAME -p `expr $QPORT + $x + 13` </dev/null > $QLOGS/$QPORT/ssl.$PPID.log 2>&1 &
done

echo "Finished starting feed handler"
