CREATE TABLE `stats` (
    `license`       VARCHAR(255) NOT NULL,
    `gametime`         INTEGER(7) NOT NULL DEFAULT 0,
    `connections`        INTEGER(7) NOT NULL DEFAULT 0,
    PRIMARY KEY (`license`)
);