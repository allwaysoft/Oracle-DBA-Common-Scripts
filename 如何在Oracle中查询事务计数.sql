如何在Oracle中查询事务计数
数据库扩展期间可能需要的脚本。计算两个特定日期之间的交易编号。

该脚本已在11gR1和11gR2中进行了测试。在生产环境中运行脚本之前，请在测试服务器上对其进行测试。

 
1
2
3
4
5
6
7
8
9
10
11
12
SELECT BEGIN_TIME,
END_TIME,
TXNCOUNT,
( (END_TIME - BEGIN_TIME) * 24 * 60 * 60) DIFFSECOND,
TO_CHAR ( (TXNCOUNT / ( (END_TIME - BEGIN_TIME) * 24 * 60 * 60)),
'999999.99')
TRANXPERSECOND
FROM V$UNDOSTAT
WHERE     BEGIN_TIME >= TO_DATE('20.09.2014 00:00','DD.MM.YYYY HH24:MI')
AND BEGIN_TIME <= TO_DATE('25.09.2014 00:00','DD.MM.YYYY HH24:MI')
AND (TXNCOUNT / ( (END_TIME - BEGIN_TIME) * 24 * 60 * 60)) > 50
ORDER BY 1;
以下查询可用于在Oracle数据库中查找事务计数。

Oracle中每天的平均交易数
 
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
SELECT V1          "Total Commits",
       V2          "Total Rollbacks",
       V3          "Total User Calls",
       T1          "Uptime in days",
       S1 / T1     "Avg Daily DML Transactions",
       V3 / T1     "Avg Daily User Calls"
  FROM (SELECT VALUE     V1
          FROM V$SYSSTAT
         WHERE NAME = 'user commits'),
       (SELECT VALUE     V2
          FROM V$SYSSTAT
         WHERE NAME = 'user rollbacks'),
       (SELECT SUM (VALUE)     S1
          FROM V$SYSSTAT
         WHERE NAME IN ('user commits', 'user rollbacks')),
       (SELECT VALUE     V3
          FROM V$SYSSTAT
         WHERE NAME = 'user calls'),
       (SELECT SYSDATE - STARTUP_TIME T1 FROM V$INSTANCE);
每日平均提交次数
 
1
2
3
4
5
6
7
8
9
10
SELECT (V1 + V2) / T1 "Avg Daily DML Transactions",
    V1 "User Commit",
    V2 "User Rollback"
  FROM (SELECT VALUE V1
          FROM V$SYSSTAT
         WHERE NAME = 'user commits'),
       (SELECT VALUE V2
          FROM V$SYSSTAT
         WHERE NAME = 'user rollbacks'),
       (SELECT SYSDATE - STARTUP_TIME T1 FROM V$INSTANCE);
最近24小时的交易计数
 
1
2
3
4
5
SELECT 'DATABASE',
       'TOPLAM TRANSACTION - 24 SAAT',
       TO_CHAR (MAX (NEXT_CHANGE#) - MIN (FIRST_CHANGE#), '9,999,999,999') VALUE
  FROM V$LOG_HISTORY
WHERE TO_DATE (FIRST_TIME, 'DD/MM/RR HH24:MI:SS') > TRUNC (SYSDATE, 'HH24') - 1;
