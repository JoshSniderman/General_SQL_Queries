SELECT
	 r.filepath() AS filepath
	,r.filepath(1) AS [year]
	,r.filepath(2) AS [month]
	,COUNT_BIG(*) AS [rows]
FROM 
	OPENROWSET(
		BULK 'csv/taxi/yellow_tripdata_*-*.csv',
		DATA_SOURCE = 'SqlOnDemandDemo',
		FORMAT = 'CSV',
		PARSER_VERSION = '2.0',
		FIRSTROW = 2
	)
	WITH (
		vendor_id INT
	) AS [r]
WHERE
	r.filepath(1) IN ('2017')
	AND r.filepath(2) IN ('10', '11', '12')
GROUP BY
	 r.filepath()
	,r.filepath(1)
	,r.filepath(2)
ORDER BY
	filepath
;