SELECT owner  as Owner,segment_type as Segment_Type, tablespace_name as  Tablespace,round(SUM (bytes) / 1024 / 1024,2) as Mb   FROM dba_segments WHERE segment_name LIKE 'BIN%' GROUP BY owner, segment_type, tablespace_name ORDER BY owner, segment_type, tablespace_name