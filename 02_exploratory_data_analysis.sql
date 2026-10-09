-- Total Service Requests

SELECT COUNT(*) AS total_requests
FROM nyc311_analytics.service_requests;


-- Requests by Complaint Type

SELECT
    complaint_type,
    COUNT(*) AS total_requests
FROM nyc311_analytics.service_requests
GROUP BY complaint_type
ORDER BY total_requests DESC
LIMIT 25;


-- Service Requests by Borough

SELECT
    borough,
    COUNT(*) AS total_requests
FROM nyc311_analytics.service_requests
GROUP BY borough
ORDER BY total_requests DESC;


-- Service Request Status Distribution

SELECT
    status,
    COUNT(*) AS total_requests,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM nyc311_analytics.service_requests
GROUP BY status
ORDER BY total_requests DESC;


-- Overall Average Service Request Closure Time

WITH closure_times AS (
    SELECT
        date_diff(
            'second',
            TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')),
            TRY(date_parse(closed_date, '%m/%d/%Y %h:%i:%s %p'))
        ) AS seconds_to_close
    FROM nyc311_analytics.service_requests
    WHERE status = 'Closed'
)
SELECT
    COUNT(*) AS valid_closed_requests,
    ROUND(AVG(seconds_to_close) / 3600.0, 2) AS avg_closure_hours
FROM closure_times
WHERE seconds_to_close >= 0;


-- Average Closure Time by Complaint Type


WITH closure_times AS (
    SELECT
        complaint_type,
        date_diff(
            'second',
            TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')),
            TRY(date_parse(closed_date, '%m/%d/%Y %h:%i:%s %p'))
        ) AS seconds_to_close
    FROM nyc311_analytics.service_requests
    WHERE status = 'Closed'
)
SELECT
    complaint_type,
    COUNT(*) AS closed_requests,
    ROUND(AVG(seconds_to_close) / 3600.0, 2) AS avg_closure_hours
FROM closure_times
WHERE seconds_to_close >= 0
GROUP BY complaint_type
HAVING COUNT(*) >= 100
ORDER BY avg_closure_hours DESC
LIMIT 25;


-- Daily Service Request Trends

SELECT
    CAST(
        TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p'))
        AS DATE
    ) AS request_date,
    COUNT(*) AS total_requests
FROM nyc311_analytics.service_requests
WHERE TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')) IS NOT NULL
GROUP BY 1
ORDER BY request_date;


-- Average Closure Time by Borough

WITH closure_times AS (
    SELECT
        borough,
        date_diff(
            'second',
            TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')),
            TRY(date_parse(closed_date, '%m/%d/%Y %h:%i:%s %p'))
        ) AS seconds_to_close
    FROM nyc311_analytics.service_requests
    WHERE status = 'Closed'
)
SELECT
    borough,
    COUNT(*) AS closed_requests,
    ROUND(AVG(seconds_to_close) / 3600.0, 2) AS avg_closure_hours
FROM closure_times
WHERE seconds_to_close >= 0
GROUP BY borough
ORDER BY avg_closure_hours DESC;
