SELECT i.instance_number,i.instance_name,TO_CHAR(d.created,'MM/DD/YYYY') created,i.host_name,i.version,TO_CHAR(i.startup_time,'MM/DD/YYYY') startup_time,i.status,i.parallel FROM gv$instance i,gv$database d WHERE i.inst_id = d.inst_id