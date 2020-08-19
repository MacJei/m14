USE jovyan;

DROP TABLE IF EXISTS logs_raw;

CREATE EXTERNAL TABLE logs_raw (
    ip STRING,
    request_time STRING,
    request STRING,
    page_size INT,
    status_code INT,
    user_agent STRING
)
ROW FORMAT
serde 'org.apache.hadoop.hive.serde2.RegexSerDe'
with serdeproperties (
    "input.regex" = "^(\\S*)\\t*(\\S*)\\t(\\S*)\\t(\\S*)\\t(\\S*)\\t(.*)$"
)
STORED AS textfile
LOCATION '/user/jovyan/user_logs/user_logs_S/';

SELECT * FROM logs_raw LIMIT 10;
