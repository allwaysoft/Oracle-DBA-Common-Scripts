Oracle Database Size
Overall/Total Database Size

Select ( Select Sum(Bytes)/1024/1024/1024 Data_Size From Dba_Data_Files ) +
( Select Nvl(Sum(Bytes),0)/1024/1024/1024 Temp_Size From Dba_Temp_Files ) +
( Select Sum(Bytes)/1024/1024/1024 Redo_Size From Sys.V_$Log ) +
( SelectSum(Block_Size*File_Size_Blks)/1024/1024/1024 Controlfile_Size From V$Controlfile) ¡°Size In Gb¡± From Dual;

Actual size of the Database in GB

Select Sum (Bytes) / 1024 / 1024 / 1024 As Gb From Dba_Data_Files;

Share via:



select 
( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) +
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) +
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_$log ) +
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v$controlfile) "Size in GB"
from
dual


SELECT a.data_size + b.temp_size + c.redo_size + d.controlfile_size 
"total_size in GB" 
FROM (SELECT SUM (bytes) / 1024 / 1024/1024 data_size FROM dba_data_files) a, 
(SELECT NVL (SUM (bytes), 0) / 1024 / 1024/1024 temp_size 
FROM dba_temp_files) b, 
(SELECT SUM (bytes) / 1024 / 1024/1024 redo_size FROM sys.v_$log) c, 
(SELECT SUM (BLOCK_SIZE * FILE_SIZE_BLKS) / 1024 / 1024/1024 
controlfile_size 
FROM v$controlfile) d;


Select sum(bytes)/1024/1024/1024 from dba_segments;