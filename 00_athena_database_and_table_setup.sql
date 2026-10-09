-- Create NYC 311 Analytics Database

CREATE DATABASE IF NOT EXISTS nyc311_analytics;


-- Create External Table for NYC 311 Service Requests

CREATE EXTERNAL TABLE IF NOT EXISTS nyc311_analytics.service_requests (
    unique_key STRING,
    created_date STRING,
    closed_date STRING,
    complaint_type STRING,
    status STRING,
    borough STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    'separatorChar' = ',',
    'quoteChar' = '"',
    'escapeChar' = '\\'
)
STORED AS TEXTFILE
LOCATION 's3://nj-nyc311-analytics-2026/prepared-data/'
TBLPROPERTIES ('skip.header.line.count' = '1');