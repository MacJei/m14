 add jar /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar; use jovyan; drop table if exists ser_de_example; create external table ser_de_example(ip string) row format serde 'org.apache.hadoop.hive.serde2.RegexSerDe' with serdeproperties ( 'input.regex' = '^(\S*)\t.*') stored as textfile location '/user_logs/user_logs_M'; select * from ser_de_example limit 10;

