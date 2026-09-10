CREATE DATABASE datashield;

USE datashield;

CREATE TABLE file_metadata (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255),
    upload_time DATETIME,
    status VARCHAR(50)
);

INSERT INTO file_metadata
(filename, upload_time, status)
VALUES
('test.csv', NOW(), 'TEST');

SELECT * FROM file_metadata;
