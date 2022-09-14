DROP DATABASE IF EXISTS PIDTS03;
CREATE DATABASE IF NOT EXISTS PIDTS03;
USE PIDTS03;
# 1. Año con más carreras -----------------------------------------------------------------
DROP TABLE IF EXISTS `races`;
CREATE TABLE IF NOT EXISTS `races` (
  	`raceId` 	INT NOT NULL,
  	`year` 		INT,			-- raceId,year,round,circuitId,name,date,time,url
    `round`		INT,
    `circuitId`	INT NOT NULL,
  	`name` 		VARCHAR(50),
    `date`		DATE,
    `time`		VARCHAR(50),
    `url`		VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\races.csv'
INTO TABLE `races`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select `year`, count(`year`) as Numero_carreras from races
group by `year`
order by Numero_carreras desc
limit 1;
#-------------------------------------------------------------------------------------------------

# 2. Piloto con mayor cantidad de primeros puestos -----------------------------------------------------------------
DROP TABLE IF EXISTS `qualifying`;
CREATE TABLE IF NOT EXISTS `qualifying` (
  	`qualifyId` 	INT NOT NULL,
  	`raceId` 		INT NOT NULL,			-- raceId,year,round,circuitId,name,date,time,url
    `driverId`		INT NOT NULL,
    `constructorId`	INT NOT NULL,
  	`number` 		INT,
    `position`		INT,
    `q1`		VARCHAR(50),
    `q2`		VARCHAR(50),
    `q3`		VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\qualifying.csv'
INTO TABLE `qualifying`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

DROP TABLE IF EXISTS `drivers`;
CREATE TABLE IF NOT EXISTS `drivers`( -- driverId;driverRef;number;code;forename;surname;dob;nationality;url
  	`driverId`		INT NOT NULL,
    `driverRef` 	VARCHAR(70),
  	`number` 		VARCHAR(10),
    `code`			VARCHAR(10),
  	`forename` 		VARCHAR(70),
    `surname`		VARCHAR(70),
    `dob`			DATE,
    `nationality` 	VARCHAR(70),
    `url`			VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\drivers.csv'
INTO TABLE `drivers`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT drivers.driverId, count(qualifying.position) as Cantidad_primeros_puestos, drivers.forename as Nombre, drivers.surname as Apellido
FROM qualifying
	JOIN drivers ON qualifying.driverId = drivers.driverId
WHERE position = 1
GROUP BY driverId
ORDER BY Cantidad_primeros_puestos DESC
LIMIT 1;

# 3. Nombre del circuito más corrido -----------------------------------------------------------------
DROP TABLE IF EXISTS `circuits`;
CREATE TABLE IF NOT EXISTS `circuits`( -- driverId;driverRef;number;code;forename;surname;dob;nationality;url
  	`raceId`	INT NOT NULL,
    `year` 		INT,
  	`round`		INT,
    `circuitId` INT,
  	`name` 		VARCHAR(70),
    `date`		DATE,
    `time`		VARCHAR(40),
    `url`		VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\circuits.csv'
INTO TABLE `circuits`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT count(circuitId) as CantidadCarreras, `name` FROM circuits
GROUP BY circuitId
ORDER BY CantidadCarreras DESC
LIMIT 1;

# 4. Piloto con mayor cantidad de puntos en total, cuyo constructor sea de nacionalidad American o British 
# ----------------------------------------------------------------------------------------------------------
# https://www.google.com/search?q=jenson+button&oq=jenson+button&aqs=chrome..69i57.2702j0j9&sourceid=chrome&ie=UTF-8
DROP TABLE IF EXISTS `results`;
CREATE TABLE IF NOT EXISTS `results` (
  	`resultId`	INT NOT NULL,
  	`raceId` 	INT NOT NULL,
  	`driverId` 	INT NOT NULL,
    `constructorId`	INT NOT NULL,
  	`number` 	INT,
    `grid`		INT,
    `position`	INT,
    `positionText`	VARCHAR(20),
    `positionOrder` INT,
    `points`	DECIMAL(10,2),
    `laps`		INT,
    `time`		VARCHAR(40),
    `milliseconds`	INT,
    `fastestLap`	INT,
    `rank`		INT,
    `fastestLapTime`	VARCHAR(70),
    `fastestLapSpeed`	DECIMAL,
    `statusId` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\results.csv'
INTO TABLE `results`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM results;

DROP TABLE IF EXISTS `constructors`;
CREATE TABLE IF NOT EXISTS `constructors` (
  	`constructorId` 		VARCHAR(50),
  	`constructorRef` 			VARCHAR(50),
  	`name` 		VARCHAR(50),
    `nationality`		VARCHAR(50),
  	`url` 			VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\PI_Data03\\constructors.csv'
INTO TABLE `constructors`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select * from constructors;

SELECT sum(r.points) as Puntaje_total, c.nationality as Nacionalidad_del_constructor, c.name as Nombre, d.forename as Nombre, d.surname as Apellido -- , r.driverId
FROM results r
	JOIN constructors c ON (r.constructorId = c.constructorId)
    JOIN drivers d ON (r.driverId = d.driverId)
WHERE c.nationality = 'British' OR c.nationality = 'American'
GROUP BY r.driverId
ORDER BY Puntaje_total DESC
LIMIT 1;















