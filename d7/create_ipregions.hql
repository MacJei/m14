use jovyan; create external table if not exists ip_regions(ip string, region string) row format delimited fields terminated by '\t' stored as textfile location '/user/jovyan/user_logs/ip_data_S/';
