use jovyan; select request_date, count(*)  as cnt from logs group by request_date sort by cnt DESC limit 10;
