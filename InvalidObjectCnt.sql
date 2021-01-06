SELECT owner AS Schema, object_type AS Type, status AS Status, count(*) AS Count FROM dba_objects WHERE status != 'VALID' GROUP BY owner, object_type, status ORDER BY owner, object_type, status