SELECT TO_CHAR (TRUNC (redocompletion), 'YYYY/MM/DD - DY') TO_CHAR, ROUND (SUM (redosize) / 1024 / 1024, 2) ROUND_redosize,SUM(cnt) SUM_cnt,ROUND (SUM (cnt) / 24, 1) ROUND_cnt,ROUND (MAX (redosize) / 1024 / 1024, 2) ROUND_max_redosize ,MAX (cnt) max_cnt FROM (  SELECT TRUNC (al.completion_time, 'HH24') redocompletion, SUM (al.blocks * al.block_size) redosize, COUNT (*) cnt FROM v$archived_log al, v$instance i WHERE al.completion_time > SYSDATE - 30 AND al.thread# = i.thread# GROUP BY TRUNC (al.completion_time, 'HH24'))GROUP BY TRUNC (redocompletion) ORDER BY 1