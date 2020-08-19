
SET hive.enforce.bucketing=true;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=non-strict;

ADD FILE mapper.py;
ADD FILE reducer.py;

CREATE DATABASE IF NOT EXISTS jovyan;

USE jovyan;

DROP TABLE IF EXISTS data_raw;

CREATE EXTERNAL TABLE data_raw (
    line STRING
)
ROW FORMAT DELIMITED
LINES TERMINATED BY '\n'
STORED AS textfile
LOCATION '/data/stackexchange1000/posts/';

--- SELECT COUNT(*) FROM data_raw;
--- SELECT * FROM data_raw LIMIT 3;

DROP TABLE IF EXISTS formatted_raw;

CREATE TABLE formatted_raw (
    tag STRING,
    count INT
)
PARTITIONED BY (year INT);

--- SELECT COUNT(*) FROM formatted_raw;
--- SELECT * FROM formatted_raw LIMIT 3;

FROM (
    FROM data_raw
    SELECT TRANSFORM (line)
    USING "mapper.py" AS tag, count, year
    DISTRIBUTE BY year SORT BY tag
) Tags
INSERT OVERWRITE TABLE formatted_raw
    PARTITION (year)
    SELECT TRANSFORM(Tags.tag, Tags.count, Tags.year)
    USING "reducer.py" AS tag, count, year;

SELECT year, tag, count
FROM (
    SELECT year, tag, count, rnk
    FROM (
        SELECT year, tag, count, RANK() OVER(
            PARTITION BY year 
            ORDER BY count DESC, tag) AS rnk
        FROM formatted_raw
    ) AS tgs
    WHERE rnk <= 10
) AS tgs
ORDER BY year ASC, count DESC;
--- INTO OUTFILE 'hw3_hive.out';