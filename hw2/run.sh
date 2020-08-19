#!/usr/bin/env bash
set -x

HADOOP_STREAMING_JAR=/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-streaming.jar
OUT_DIR="hw2_result"
NUM_REDUCERS=8

hdfs dfs -rm -r -skipTrash ${OUT_DIR}*

# Wordcount
( 
yarn jar $HADOOP_STREAMING_JAR \
	-D mapreduce.job.name="HW_2" \
	-files mapper.py,reducer.py \
	-mapper "python3 mapper.py" \
	-reducer "python3 reducer.py" \
	-numReduceTasks $NUM_REDUCERS \
	-input /data/wiki/en_articles_part \
	-output ${OUT_DIR}_tmp > /dev/null &&

# Global sorting as we use only 1 reducer
yarn jar $HADOOP_STREAMING_JAR \
	-D mapreduce.job.output.key.comparator.class=org.apache.hadoop.mapreduce.lib.partition.KeyFieldBasedComparator \
	-D stream.num.map.output.key.fields=2 \
	-D mapred.text.key.comparator.options="-k2,2nr" \
	-mapper cat \
	-reducer cat \
	-numReduceTasks 1 \
	-input ${OUT_DIR}_tmp \
	-output ${OUT_DIR} > /dev/null ) || echo "Error happens"

hdfs dfs -rm -r -skipTrash ${OUT_DIR}_tmp
hdfs dfs -cat ${OUT_DIR}/part-00000 | head >> hw2_mr.out
