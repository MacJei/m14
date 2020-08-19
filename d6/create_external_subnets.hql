use jovyan; drop table if exists subnets; create external table subnets (ip string, mask string) row format delimited fields terminated by '\t' stored as textfile location '/user/jovyan/hive/warehouse
/';
