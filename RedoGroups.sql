SELECT group# as GroupName,thread# as Thread,sequence# as Seq, bytes / 1024 / 1024 as SizeMb, members as Members, archived as Archived, status as Status,first_change# as FirstSCN, to_char(first_time,'YYYY-MM-DD/HH24:MI:SS') as FirstTime FROM v$log