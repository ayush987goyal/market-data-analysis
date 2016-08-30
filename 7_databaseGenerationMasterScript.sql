#create database and declare it as current database
create database exchangemarket;
use exchangemarket;


#create required tables
create table exchanges(
	marketID int PRIMARY KEY,
	marketName varchar(50)
);

create table nyse(
	ticker varchar(50),
	exchangeDate int,
	openingPrice decimal(10,4),
	high decimal(10,4),
	low decimal(10,4),
	closingPrice decimal(10,4),
	volume int,
	market_ID int DEFAULT 1,
	FOREIGN KEY (market_ID) REFERENCES exchanges (marketID)
);

create table liffe(
	ticker varchar(50),
	exchangeDate int,
	openingPrice decimal(10,4),
	high decimal(10,4),
	low decimal(10,4),
	closingPrice decimal(10,4),
	volume int,
	market_ID int DEFAULT 2,
	FOREIGN KEY (market_ID) REFERENCES exchanges (marketID)
);

create table nasdaq(
	ticker varchar(50),
	exchangeDate int,
	openingPrice decimal(10,4),
	high decimal(10,4),
	low decimal(10,4),
	closingPrice decimal(10,4),
	volume int,
	market_ID int DEFAULT 3,
	FOREIGN KEY (market_ID) REFERENCES exchanges (marketID)
);

create table nasdaq1(
	ticker varchar(50),
	exchangeDate int,
	openingPrice decimal(10,4),
	high decimal(10,4),
	low decimal(10,4),
	closingPrice decimal(10,4),
	volume int,
	market_ID int DEFAULT 3,
	FOREIGN KEY (market_ID) REFERENCES exchanges (marketID)
); 


#populate exchanges table with default values
insert into exchanges values(1,'nyse');
insert into exchanges values(2,'liffe');
insert into exchanges values(3,'nasdaq');


#load flat files generated by SSIS package (using MSSQL SERVER) into tables of exchangedata database in MYSQL Server
load data local infile 'C:\\Users\\Grad_43\\Downloads\\Market Data Analysis\\Exchange Market Database\\nyse.csv'
into table nyse
fields terminated by ','
lines terminated by '\n'
IGNORE 1 LINES;

load data local infile 'C:\\Users\\Grad_43\\Downloads\\Market Data Analysis\\Exchange Market Database\\liffe.csv'
into table liffe
fields terminated by ','
lines terminated by '\n'
IGNORE 1 LINES;

load data local infile 'C:\\Users\\Grad_43\\Downloads\\Market Data Analysis\\Exchange Market Database\\nasdaq.csv'
into table nasdaq1
fields terminated by ','
lines terminated by '\n'
IGNORE 1 LINES;


#limit the number of rows to be loaded into the table to avoid long query execution duration
INSERT INTO nasdaq
SELECT * FROM nasdaq1 LIMIT 100000;


#drop the template copy of original table
DROP TABLE nasdaq1;


#add primary key columns and other required columns to all the tables
ALTER TABLE nyse
ADD indexkey int auto_increment primary key;
ALTER TABLE liffe
ADD indexkey int auto_increment primary key;
ALTER TABLE nasdaq
ADD indexkey int auto_increment primary key;
ALTER TABLE nyse
ADD sector varchar(50);
ALTER TABLE nyse
ADD region varchar(50);
ALTER TABLE liffe
ADD sector varchar(50);
ALTER TABLE liffe
ADD region varchar(50);
ALTER TABLE nasdaq
ADD sector varchar(50);
ALTER TABLE nasdaq
ADD region varchar(50);


#populate volume fields in the tables having NULL values with random values
UPDATE liffe SET volume = FLOOR(20000 + RAND( ) *1000000)
WHERE volume is NULL;
UPDATE nyse SET volume = FLOOR(20000 + RAND( ) *1000000)
WHERE volume is NULL;


#populate sector and region fields in the tables having NULL values with random values
UPDATE nasdaq SET sector = ELT(1 + FLOOR(RAND()*6), 'Banking/Finance', 'Technology', 'Pharmaceuticals', 'Engineering', 'Automotive', 'Oil and Gas')
WHERE sector is NULL;
UPDATE liffe SET sector = ELT(1 + FLOOR(RAND()*6), 'Banking/Finance', 'Technology', 'Pharmaceuticals', 'Engineering', 'Automotive', 'Oil and Gas')
WHERE sector is NULL;
UPDATE nyse SET sector = ELT(1 + FLOOR(RAND()*6), 'Banking/Finance', 'Technology', 'Pharmaceuticals', 'Engineering', 'Automotive', 'Oil and Gas')
WHERE sector is NULL;
UPDATE nasdaq SET region = ELT(1 + FLOOR(RAND()*4), 'NAM', 'APAC', 'EMEA', 'Latin America')
WHERE region is NULL;
UPDATE liffe SET region = ELT(1 + FLOOR(RAND()*4), 'NAM', 'APAC', 'EMEA', 'Latin America')
WHERE region is NULL;
UPDATE nyse SET region = ELT(1 + FLOOR(RAND()*4), 'NAM', 'APAC', 'EMEA', 'Latin America')
WHERE region is NULL;



