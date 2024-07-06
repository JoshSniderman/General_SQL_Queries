-- Data aggregation over time

SELECT
	Make,
	COUNT(*) AS Count
FROM
	Input TIMESTAMP BY Time
GROUP BY
	Make,
	TumblingWindow(second, 10)
;




-- Return last event in window

WITH LastInWindow AS
(
	SELECT 
		MAX(Time) AS LastEventTime
	FROM 
		Input TIMESTAMP BY Time
	GROUP BY 
		TumblingWindow(minute, 10)
)

SELECT 
	Input.License_plate,
	Input.Make,
	Input.Time
FROM
	Input TIMESTAMP BY Time 
	INNER JOIN LastInWindow
	ON DATEDIFF(minute, Input, LastInWindow) BETWEEN 0 AND 10
	AND Input.Time = LastInWindow.LastEventTime
;



-- Duration between events

SELECT
	[user],
	feature,
	DATEDIFF(
		second,
		LAST(Time) OVER (PARTITION BY [user], feature LIMIT DURATION(hour, 1) WHEN Event = 'start'),
		Time) as duration
FROM input TIMESTAMP BY Time
WHERE
	Event = 'end'
;




-- https://learn.microsoft.com/en-us/azure/stream-analytics/stream-analytics-stream-analytics-query-patterns#detect-the-duration-between-events