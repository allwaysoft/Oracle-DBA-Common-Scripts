v$session视图 中LAST_CALL_ET列的 重要性
好吧，我们都知道v $ session视图在oracle中的重要性。我们经常在此表中查找状态，sid，sql_text，程序名称和其他与对象相关的东西。但是其中还有一个重要的列，我们经常会忽略它，即LAST_CALL_ET
如果会话STATUS当前处于活动状态，则该值表示自会话变为活动状态以来经过的时间（以秒为单位）。

如果会话状态当前为非活动状态，则该值表示自会话变为非活动状态起所经过的时间（以秒为单位）。



因此，这是一本很棒的列，可以了解系统上会话正在执行的操作，例如，


select s.sid||','||s.serial# sess,
       s.USERNAME,
       s.last_call_et,
       s.status,
       s.sql_address,
       s.program
from v$session s
where ( s.status = 'ACTIVE' and s.last_call_et > 10 ) or      -- has been active for 10 seconds or more
      ( s.status != 'ACTIVE' and s.last_call_et > 1200 );     -- has been inactive for 20 mins or more

如果长时间无操作对于应用连接池来说应该应用没有正确关闭连接，发现连接池泄露时执行的SQL语句

select sid,serial#,username,trunc

(last_call_et/3600,2)||' hr' 

last_call_et 

from V$session where

last_call_et > 3600 and username is not null



select
   ses.username,
   ses.machine,
   ses.program,
   ses.status,
   ses.last_call_et,
   sql.hash_value,
   sql.sql_text
from
   v$session ses,
   v$sql sql
where
   ses.sql_hash_value = sql.hash_value
and
   ses.type = 'USER';

