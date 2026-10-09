-- Data Preparation and Cleaning

SELECT
    unique_key,
    TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')) AS created_date,
    TRY(date_parse(closed_date, '%m/%d/%Y %h:%i:%s %p')) AS closed_date,
    complaint_type,
    borough,
    status
FROM nyc311_analytics.service_requests
WHERE TRY(date_parse(created_date, '%m/%d/%Y %h:%i:%s %p')) IS NOT NULL
ORDER BY created_date;