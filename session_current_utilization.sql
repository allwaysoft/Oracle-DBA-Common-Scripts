SELECT resource_name,current_utilization current_count,limit_value max_value,ROUND (current_utilization / limit_value * 100, 1) percent_used  FROM v$resource_limit WHERE resource_name IN ('sessions')