#/usr/bin/env bash
set -x
 
HADOOP_STREAMING_JAR=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar
 
yarn jar $HADOOP_STREAMING_JAR \
    -files mapper.py, reducer.py \
    -mapper 'python mapper.py' \
    -reducer './reducer.py' \
    -numReduceTasks 1 \
    -input /data/wiki/en_articles \
    -output wc_mr_with_reducer
 
#echo $?


#    -D mapreduce.job.name="surname: my first line_count" \
#    -mapper "wc -l" \
#    -reducer "ls -al" \