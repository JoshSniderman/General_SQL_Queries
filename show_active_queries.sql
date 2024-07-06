-- View service objective
SELECT
    db.name AS [Database]
,    ds.edition AS [Edition]
,    ds.service_objective AS [Service Objective]
FROM
     sys.database_service_objectives ds
JOIN
    sys.databases db ON ds.database_id = db.database_id
WHERE
    db.name = 'DatabaseName'
;

-- Scale compute resources by adjusting data warehouse units.
ALTER DATABASE 
	DatabaseName
MODIFY 
	(SERVICE_OBJECTIVE = 'DW300c')
;

-- Monitor scale change request. 
WHILE
(
    SELECT TOP 1 state_desc
    FROM sys.dm_operation_status
    WHERE
        1=1
        AND resource_type_desc = 'Database'
        AND major_resource_id = 'DatabaseName'
        AND operation = 'ALTER DATABASE'
    ORDER BY
        start_time DESC
) = 'IN_PROGRESS'
BEGIN
    RAISERROR('Scale operation in progress',0,0) WITH NOWAIT;
    WAITFOR DELAY '00:00:05';
END
PRINT 'Complete';

-- Check operation status. This shows if there are any active transactions in the database. 
SELECT *
FROM
    sys.dm_operation_status
WHERE
    resource_type_desc = 'Database'
AND
    major_resource_id = 'DatabaseName'
;

-- Show data distributition in dedicated pool.

PDW_SHOWSPACEUSED('SchemaName.TableName');


-- Show transaction log size.

SELECT
	instance_name as distribution_db,
	cntr_value * 1.0 / 1048576 as log_file_size_used_GB,
	pdw_node_id
FROM sys.dm_pdw_nodes_os_performance_counters
WHERE
	instance_name like 'Distribution_%'
	AND counter_name = 'Log File(s) Used Size (KB)'





-- https://learn.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/quickstart-scale-compute-tsql
-- 