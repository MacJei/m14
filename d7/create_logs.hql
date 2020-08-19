ADD JAR /opt/cloudera/parcels/CDH/lib/hive/lib/hive-serde.jar;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict


USE jovyan;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
    ip STRING,
    request STRING,
    page_size INT,
    status_code INT,
    region STRING,
    gender STRING,
    age INT,
    browser STRING
)
PARTITIONED BY (request_date STRING)
ROW FORMAT DELIMITED 
    FIELDS TERMINATED BY '\t' 
STORED AS TEXTFILE
LOCATION '/user/jovyan/user_logs/logs';



INSERT OVERWRITE TABLE logs
PARTITION (request_date)
SELECT logs_raw.ip, logs_raw.request, logs_raw.page_size, logs_raw.status_code,
        ip_regions.region,
        users.gender, users.age, users.browser,
        SUBSTR(logs_raw.request_time, 1, 8) AS request_date
  FROM logs_raw 
  JOIN ip_regions ON (logs_raw.ip = ip_regions.ip)
  JOIN users ON (logs_raw.ip = users.ip and regexp_extract(logs_raw.user_agent, "(\\w*).*") = regexp_extract(users.browser, "(\\w*).*"));
                
                
SELECT * FROM logs LIMIT 10;