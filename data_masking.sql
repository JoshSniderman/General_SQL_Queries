SELECT 
	 c.name
	,tbl.name AS table_name
	,type.name AS data_type
	,c.is_masked
	,c.masking_function
FROM 
	sys.masked_columns c
	INNER JOIN sys.tables tbl 
		ON c.object_id = tbl.object_id 
	INNER JOIN sys.types typ 
		ON c.user_type_id = typ.user_type_id
WHERE
	is_masked = 1
;