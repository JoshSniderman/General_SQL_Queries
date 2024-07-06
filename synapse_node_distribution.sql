DBCC PDW_SHOWSPACEUSED(
	'schema.table'
	)
;


SELECT 
    p.object_id,
    OBJECT_NAME(p.object_id) AS TableName,
    p.partition_id,
    p.row_count,
    p.used_bytes / 1024 / 1024 AS UsedSpaceMB,
    p.reserved_bytes / 1024 / 1024 AS ReservedSpaceMB,
    p.total_bytes / 1024 / 1024 AS TotalSpaceMB,
    n.name AS DistributionName,
    n.id AS DistributionId,
    n.ip_address AS DistributionIPAddress
FROM 
    sys.dm_pdw_nodes_db_partition_stats AS p
JOIN 
    sys.pdw_nodes AS n 
		ON p.pdw_node_id = n.pdw_node_id
ORDER BY 
    TableName, partition_id
;
	
	
-- Redistribute

CREATE TABLE NewTable
WITH
(
    DISTRIBUTION = HASH(ColumnB)
)
AS
SELECT *
FROM ExistingSkewedTable
OPTION (
	DISTRIBUTE BY ColumnB
	)
;