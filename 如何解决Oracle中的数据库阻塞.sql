如何解决Oracle中的数据库阻塞？
2011年8月28日| 提起下：Oracle
数据库阻塞是一种情况，即一个用户运行的语句锁定一条记录或一组记录，而同一用户或不同用户运行的另一条语句则要求该一条或多条记录上的冲突类型由第一位用户锁定。
数据库阻塞问题在任何应用程序中都是很常见的情况。
如何识别阻塞会话？或更具体地说，如何识别阻塞的行和对象？如何解决数据库阻塞问题？让我们一一看。
如何识别阻塞会话
1. DBA_BLOCKERS：仅提供有关阻塞会话的信息。
SQL> select * from dba_blockers;
HOLDING_SESSION
—————
252
2. v $ LOCK：提供阻止和等待会话的详细信息。
SQL> select l1.sid, ‘ IS BLOCKING ‘, l2.sid
from v$lock l1, v$lock l2
where l1.block =1 and l2.request > 0
and l1.id1=l2.id1
and l1.id2=l2.id2
/
SID ‘ISBLOCKING’         SID
———- ————- ———-
244  IS BLOCKING         252
要获取更多具体细节，请使用以下查询：
SQL> select s1.username || ‘@’ || s1.machine
|| ‘ ( SID=’ || s1.sid || ‘ )  is blocking ‘
|| s2.username || ‘@’|| s2.machine || ‘ ( SID=’ || s2.sid || ‘ ) ‘ AS blocking_status
from v$lock l1, v$session s1, v$lock l2, v$session s2
where s1.sid=l1.sid and s2.sid=l2.sid
and l1.BLOCK=1 and l2.request > 0
and l1.id1 = l2.id1
and l2.id2 = l2.id2 ;
BLOCKING_STATUS
——————————————————————————–
MECK@machine1 ( SID=244 )  is blocking TAMY@machine2 ( SID=252 )


如何识别锁定的对象
SQL> select * from v$lock ;
ADDR             KADDR                          SID TY        ID1        ID2             LMODE   REQUEST   CTIME     BLOCK
—————- —————-                    ———- —       ———- ———- ——-    ———-       ———- ———-
0000000451723DE8 0000000451723E20        244 TX    1310745    3139497          6          0         166           1
000000046032AFE0 000000046032B000        252 TX    1310745    3139497          0          6          33             0
锁的类型– UL，TX和AMD
TM1。UL是用户定义的锁，这是使用DBMS_LOCK包定义的锁。
2. TX锁是一个行事务锁；每次更改数据的事务都会获取一次。更改对象的数量无关紧要。ID1和ID2列指向该事务的回滚段和事务表条目。
3. TM锁是DML锁。它为每个要更改的对象获取一次。ID1列标识要修改的对象。
因此，要找到被阻止的对象，我们可以使用v $ lock中的ID1。
SQL> select object_name from dba_objects where object_id=307193;
OBJECT_NAME
————–
OBJ1
如何识别锁定的行？
SQL> select do.object_name,
row_wait_obj#, do.data_object_id, row_wait_file#, row_wait_block#, row_wait_row#,
dbms_rowid.rowid_create ( 1, do.data_object_id, ROW_WAIT_FILE#, ROW_WAIT_BLOCK#, ROW_WAIT_ROW# )
from v$session s, dba_objects do
where sid=252
and s.ROW_WAIT_OBJ# = do.OBJECT_ID ;
OBJECT_NAME
——————————————————————————–
ROW_WAIT_OBJ# DATA_OBJECT_ID ROW_WAIT_FILE# ROW_WAIT_BLOCK# ROW_WAIT_ROW#
————- ————– ————– ————— ————-
DBMS_ROWID.ROWID_C
——————
OBJ1
307193         307193              5             455             0
AABK/5AAFAAAAHHAAA

由此，我们直接得到该行：
SQL> select * from obj1 where rowid=’ AABK/5AAFAAAAHHAAA’ ;
获取被阻止的sql查询
如果获得sid，则使用以下sql会很容易：
SQL>select s.sid, q.sql_text from v$sqltext q, v$session s
where q.address = s.sql_address
and s.sid = 252;
SID SQL_TEXT
—– —————————————————————-
252 update obj1 set bar=:”SYS_B_0″ where bar=:”SYS_B_1″
查找阻止会话SID和序列号。
SQL> Select blocking_session, sid, serial#, wait_class,seconds_in_wait From v$session where blocking_session is not NULL order by blocking_session;
BLOCKING_SESSION     SID    SERIAL#  WAIT_CLASS     SECONDS_IN_WAIT
—————- ———- ———- ————————————————–
244                             252  11049       Application        1634
解决锁定问题的解决方案
杀死阻止会话。
SQL> alter system kill session 244,11049′ immediate;
System altered.
你完成了！

