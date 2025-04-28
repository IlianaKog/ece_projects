-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: world_disasters
-- ------------------------------------------------------
-- Server version	8.0.25
DROP SCHEMA IF EXISTS `world_disasters`;
CREATE SCHEMA `world_disasters`;
USE `world_disasters`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `articles_about_disasters`
--

DROP TABLE IF EXISTS `articles_about_disasters`;
/*!50001 DROP VIEW IF EXISTS `articles_about_disasters`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `articles_about_disasters` AS SELECT 
 1 AS `disaster_name`,
 1 AS `author`,
 1 AS `title`,
 1 AS `publication_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `building`
--

DROP TABLE IF EXISTS `building`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `building` (
  `street` varchar(255) NOT NULL,
  `street_number` varchar(10) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `disasterSituationID` int NOT NULL,
  `monument` tinyint(1) DEFAULT NULL,
  `damage_type` enum('DESTROYED','PARTLY DESTROYED','MAJOR ISSUES','MINOR ISSUES') DEFAULT NULL,
  `reconstruction_cost` decimal(10,2) DEFAULT NULL,
  `constructed_year` int DEFAULT NULL,
  PRIMARY KEY (`street`,`street_number`,`postal_code`,`disasterSituationID`),
  KEY `disasterSituationID` (`disasterSituationID`),
  CONSTRAINT `building_ibfk_1` FOREIGN KEY (`disasterSituationID`) REFERENCES `disaster_situation` (`disasterSituationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building`
--

LOCK TABLES `building` WRITE;
/*!40000 ALTER TABLE `building` DISABLE KEYS */;
INSERT INTO `building` VALUES ('Aleppo Historic Street','47','SYR-2111',5,1,'PARTLY DESTROYED',1850.00,3000000),('Gaziantep Boulevard','101','27000',4,0,'DESTROYED',1990.00,2000000),('Marina Drive','220','70130',6,0,'PARTLY DESTROYED',1985.00,500000),('Minamata Bay Road','77','867-0055',7,1,'MAJOR ISSUES',1950.00,100000),('Nuclear Avenue','18','07270',1,0,'PARTLY DESTROYED',1975.00,0),('Pripyat Central Plaza','3','07270',1,1,'DESTROYED',1970.00,0),('Sendai Shoreline Road','256','980-0823',2,0,'DESTROYED',1980.00,1000000),('Yangtze Riverfront','88','443300',3,0,'DESTROYED',1920.00,2000000);
/*!40000 ALTER TABLE `building` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `population` int DEFAULT NULL,
  `GDP` bigint DEFAULT NULL,
  `country_name` varchar(255) NOT NULL,
  PRIMARY KEY (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1400000000,25000000000000,'China'),(125000000,6000000000000,'Japan'),(17000000,40000000000,'Syria'),(84000000,2400000000000,'Turkey'),(41000000,535000000000,'Ukraine'),(331000000,22000000000000,'United States');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disaster`
--

DROP TABLE IF EXISTS `disaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disaster` (
  `Disaster_ID` int NOT NULL AUTO_INCREMENT,
  `Disaster_name` varchar(255) NOT NULL,
  `start_date` date DEFAULT NULL,
  `stop_date` date DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  `injured` int DEFAULT NULL,
  `missing` int DEFAULT NULL,
  `air_quality` enum('very low','low','medium','high','very high') DEFAULT NULL,
  `water_quality` enum('very low','low','medium','high','very high') DEFAULT NULL,
  `Continent` enum('Africa','Antarctica','Asia','Europe','North America','Oceania','South America') DEFAULT NULL,
  `center_latitude` decimal(9,6) DEFAULT NULL,
  `center_longitude` decimal(9,6) DEFAULT NULL,
  `radius` int DEFAULT NULL,
  `type` enum('Human','Natural') DEFAULT NULL,
  `Base_location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Disaster_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disaster`
--

LOCK TABLES `disaster` WRITE;
/*!40000 ALTER TABLE `disaster` DISABLE KEYS */;
INSERT INTO `disaster` VALUES (1,'Chernobyl Disaster','1986-05-26','1986-05-26',93000,1000,0,'low','low','Europe',51.400000,30.100000,30,'Human','Pripyat'),(2,'Tohoku Earthquake and Tsunami','2011-03-11','2011-03-11',15899,6000,2500,'medium','very low','Asia',38.322000,142.369000,10,'Natural','Honsu Island'),(3,'China Floods','1931-07-20','1931-08-25',3000000,1000000,2000000,'low','very low','Asia',30.000000,112.000000,2,'Natural','Central China'),(4,'Turkey-Syria Earthquakes','2023-02-06','2023-02-15',50000,20000,5000,'medium','medium','Asia',37.066200,37.383300,100,'Natural','Southwest Turkey and northwest Syria'),(5,'BP Deepwater Horizon Oil Rig Spill','2010-05-20','2010-09-19',11,17,0,'low','very low','North America',27.736000,-88.386000,600,'Human','Gulf of Mexico'),(6,'Minamata Mercury Poisoning','1956-03-20','1968-05-26',1784,2265,0,'high','very low','Asia',32.216900,130.400000,300,'Natural','Kumanoto Prefecture');
/*!40000 ALTER TABLE `disaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disaster_affected_person`
--

DROP TABLE IF EXISTS `disaster_affected_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disaster_affected_person` (
  `disaster_id` int NOT NULL,
  `person_id` int NOT NULL,
  PRIMARY KEY (`disaster_id`,`person_id`),
  KEY `person_id` (`person_id`),
  CONSTRAINT `disaster_affected_person_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disaster` (`Disaster_ID`),
  CONSTRAINT `disaster_affected_person_ibfk_2` FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disaster_affected_person`
--

LOCK TABLES `disaster_affected_person` WRITE;
/*!40000 ALTER TABLE `disaster_affected_person` DISABLE KEYS */;
INSERT INTO `disaster_affected_person` VALUES (6,101),(1,105),(1,106),(2,108),(5,125),(5,139),(3,177),(3,188),(6,207),(2,256),(4,352),(4,446);
/*!40000 ALTER TABLE `disaster_affected_person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `disaster_date_deaths_cost`
--

DROP TABLE IF EXISTS `disaster_date_deaths_cost`;
/*!50001 DROP VIEW IF EXISTS `disaster_date_deaths_cost`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `disaster_date_deaths_cost` AS SELECT 
 1 AS `disaster_name`,
 1 AS `start_date`,
 1 AS `deaths`,
 1 AS `total_cost`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `disaster_situation`
--

DROP TABLE IF EXISTS `disaster_situation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disaster_situation` (
  `RGDP` bigint DEFAULT NULL,
  `disasterSituationID` int NOT NULL AUTO_INCREMENT,
  `financial_aid` bigint DEFAULT NULL,
  `recovery_time` int DEFAULT NULL,
  `Total_cost` bigint DEFAULT NULL,
  `Plan_title` varchar(255) DEFAULT NULL,
  `country_name` varchar(255) DEFAULT NULL,
  `disaster_id` int DEFAULT NULL,
  PRIMARY KEY (`disasterSituationID`),
  KEY `country_name` (`country_name`),
  KEY `disaster_id` (`disaster_id`),
  CONSTRAINT `disaster_situation_ibfk_1` FOREIGN KEY (`country_name`) REFERENCES `country` (`country_name`),
  CONSTRAINT `disaster_situation_ibfk_2` FOREIGN KEY (`disaster_id`) REFERENCES `disaster` (`Disaster_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disaster_situation`
--

LOCK TABLES `disaster_situation` WRITE;
/*!40000 ALTER TABLE `disaster_situation` DISABLE KEYS */;
INSERT INTO `disaster_situation` VALUES (70000000000,1,600000000,6,235000000000,'Chernobyl Recovery and Development Program','Ukraine',1),(50000000000,2,50000000000,120,360000000000,'Great East Japan Earthquake Recovery Plan','Japan',2),(70000000000,3,70000000000,26,270000000000,'Huang He Flood Control and Relief effort','China',3),(10000000000,4,10000000000,60,50000000000,'Anatolian Earthquake Recovery and Reconstruction Program','Turkey',4),(2000000000,5,2000000000,84,15000000000,'Syrian Earthquake Rehabilitation Initiative','Syria',4),(20000000000,6,20000000000,60,40000000000,'Gulf Coast Restoration Initiative','United States',5),(3000000000,7,3000000000,3,600000000000000,'Minamata Disease Relief and Rehabilitation Plan','Japan',6);
/*!40000 ALTER TABLE `disaster_situation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disease`
--

DROP TABLE IF EXISTS `disease`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease` (
  `disease_id` int NOT NULL AUTO_INCREMENT,
  `disaster_situation_id` int DEFAULT NULL,
  `disease_name` varchar(255) DEFAULT NULL,
  `affected` int DEFAULT NULL,
  `disease_type` varchar(255) DEFAULT NULL,
  `pandemic` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`disease_id`),
  KEY `disaster_situation_id` (`disaster_situation_id`),
  CONSTRAINT `disease_ibfk_1` FOREIGN KEY (`disaster_situation_id`) REFERENCES `disaster_situation` (`disasterSituationID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disease`
--

LOCK TABLES `disease` WRITE;
/*!40000 ALTER TABLE `disease` DISABLE KEYS */;
INSERT INTO `disease` VALUES (1,1,'Radiation Sickness',4000,'Radiation-induced illness',0),(2,1,'Chernobyl Theroid Cancer',6000,'Cancer',0),(3,2,'Earthquake Trauma',1000,'Mental',0),(4,2,'Post-Tsunami Infectious Disease',1500,'Various Infections',0),(5,3,'Flood-Related Gastrointestinal Infection',20000,'Gastrointestinal Infection',0),(6,3,'Flood-induced Respiratory illness',10000,'Respiratory illness',0),(7,4,'Earthquake-induced PTSD',5000,'Mental',0),(8,5,'Earthquake-induced PTSD',7000,'Mental',0),(9,5,'Post-Disaster Infectious',2000,'Infectious Disease',0),(10,6,'Oil Spill Dermatitis',1000,'Physical',0),(11,6,'Gulf Respiratory Syndrome',2500,'Respiratory Illness',0),(12,7,'Minamata Disease',2000,'Neurological Disorder',0);
/*!40000 ALTER TABLE `disease` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation_center`
--

DROP TABLE IF EXISTS `donation_center`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation_center` (
  `street` varchar(255) NOT NULL,
  `street_number` varchar(10) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `country_name` varchar(255) NOT NULL,
  `closing_hour` time DEFAULT NULL,
  `donation_type` varchar(50) DEFAULT NULL,
  `opening_hour` time DEFAULT NULL,
  PRIMARY KEY (`street`,`street_number`,`postal_code`,`country_name`),
  KEY `country_name` (`country_name`),
  CONSTRAINT `donation_center_ibfk_1` FOREIGN KEY (`country_name`) REFERENCES `country` (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_center`
--

LOCK TABLES `donation_center` WRITE;
/*!40000 ALTER TABLE `donation_center` DISABLE KEYS */;
INSERT INTO `donation_center` VALUES ('Aleppo Relief Road','112','2111','Syria','19:00:00','money','08:00:00'),('Coastal Avenue','458','70130','United States','21:00:00','goods','06:00:00'),('Fukushima Street','15','9608111','Japan','19:00:00','effort','08:00:00'),('Gaziantep Avenue','340','27000','Turkey','22:00:00','goods','06:00:00'),('Gulf Shore Drive','1020','32541','United States','20:00:00','effort','08:00:00'),('Heroes of Chernobyl','89','07400','Ukraine','17:00:00','goods','09:00:00'),('Hubei Road','256','430000','China','19:00:00','effort','08:00:00'),('Kuma River Road','591','8691234','Japan','19:00:00','effort','08:00:00'),('Pripyat Bypass','47','07270','Ukraine','18:00:00','money','07:00:00');
/*!40000 ALTER TABLE `donation_center` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `human_disaster`
--

DROP TABLE IF EXISTS `human_disaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `human_disaster` (
  `Disaster_ID` int NOT NULL,
  `intentionality` tinyint(1) DEFAULT NULL,
  `predictability` float DEFAULT NULL,
  PRIMARY KEY (`Disaster_ID`),
  CONSTRAINT `human_disaster_ibfk_1` FOREIGN KEY (`Disaster_ID`) REFERENCES `disaster` (`Disaster_ID`),
  CONSTRAINT `human_disaster_chk_1` CHECK (((`predictability` >= 0) and (`predictability` <= 1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `human_disaster`
--

LOCK TABLES `human_disaster` WRITE;
/*!40000 ALTER TABLE `human_disaster` DISABLE KEYS */;
INSERT INTO `human_disaster` VALUES (1,1,0.22),(5,1,0.22);
/*!40000 ALTER TABLE `human_disaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_article`
--

DROP TABLE IF EXISTS `media_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_article` (
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `media_type` enum('Print','Online','TV','Radio') DEFAULT NULL,
  `publication_date` date DEFAULT NULL,
  `origin_country` varchar(255) DEFAULT NULL,
  `disaster_id` int DEFAULT NULL,
  PRIMARY KEY (`title`,`author`),
  KEY `disaster_id` (`disaster_id`),
  CONSTRAINT `media_article_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disaster` (`Disaster_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_article`
--

LOCK TABLES `media_article` WRITE;
/*!40000 ALTER TABLE `media_article` DISABLE KEYS */;
INSERT INTO `media_article` VALUES ('Chernobyl: 30 Years of Living with the Fallout','Olga Ivanova','Print','2016-04-26','Ukraine',1),('Deepwater Horizon: A Decade Later','Emily Nguyen','Print','2020-04-20','United States',5),('In the Wake of Tragedy: The Turkey-Syria Earthquake','Lina Al-Khaled','TV','2023-02-15','Turkey',4),('Nuclear Safety in the Post-Chernobyl World','Richard Green','Print','2016-05-10','United States',1),('Seismic Lessons: The 2011 Tohoku Earthquake','Johnathan Smith','Print','2012-09-20','United Kingdom',2),('The Great Floods of 1931: An Historical Perspective','Zhang Wei','Print','2005-07-15','China',3),('Tohoku Ten Years On: Rebuilding and Remembering','Naomi Kikuchi','Online','2021-03-11','Japan',2);
/*!40000 ALTER TABLE `media_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `national_emergency_agency`
--

DROP TABLE IF EXISTS `national_emergency_agency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `national_emergency_agency` (
  `agency_name` varchar(255) NOT NULL,
  `country_name` varchar(255) NOT NULL,
  `website` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`agency_name`,`country_name`),
  KEY `country_name` (`country_name`),
  CONSTRAINT `national_emergency_agency_ibfk_1` FOREIGN KEY (`country_name`) REFERENCES `country` (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `national_emergency_agency`
--

LOCK TABLES `national_emergency_agency` WRITE;
/*!40000 ALTER TABLE `national_emergency_agency` DISABLE KEYS */;
INSERT INTO `national_emergency_agency` VALUES ('Chernobyl Disaster Response Unit','Ukraine','www.cdru.ua','response@cdru.ua','+380-44-765-4321'),('China National Flood Relief Commission','China','www.cnfrc.cn','support@cnfrc.cn','+86-10-1234-5678'),('Gulf Coast Disaster Management Authority','United States','www.gcdma.us','info@gcdma.us','+1-800-987-6543'),('Japan Disaster Response Agency','Japan','www.jdramin.jp','contact@jdramin.jp','+81-3-9876-5432'),('Japan Environmental Health Organization','Japan','www.jeho.jp','contact@jeho.jp','+81-3-1234-5678'),('Kumamoto Prefecture Health Bureau','Japan','www.kphb.kumamoto.jp','healthbureau@kumamoto.jp','+81-96-1234-5678'),('Syria Crisis Management Authority','Syria','www.scma.sy','contact@scma.sy','+963-11-987-6543'),('Tohoku Regional Emergency Management Office','Japan','www.tremo.jp','info@tremo.jp','+81-22-1234-5678'),('Turkey National Disaster Response Agency','Turkey','www.tndra.tr','helpdesk@tndra.tr','+90-312-123-45-67'),('U.S. Environmental Protection Agency Gulf','United States','www.epagulfresponse.us','response@epagulf.us','+1-800-123-4567'),('Ukraine National Radiation Safety Committee','Ukraine','www.unrsc.ua','safety@unrsc.ua','+380-44-123-4567');
/*!40000 ALTER TABLE `national_emergency_agency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `natural_disaster`
--

DROP TABLE IF EXISTS `natural_disaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `natural_disaster` (
  `disaster_id` int NOT NULL,
  `intensity` float DEFAULT NULL,
  `unit_measurement` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`disaster_id`),
  CONSTRAINT `natural_disaster_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disaster` (`Disaster_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `natural_disaster`
--

LOCK TABLES `natural_disaster` WRITE;
/*!40000 ALTER TABLE `natural_disaster` DISABLE KEYS */;
INSERT INTO `natural_disaster` VALUES (2,2.5,'Richter '),(3,2.5,'Richter '),(4,2.5,'Richter '),(6,2.5,'Richter ');
/*!40000 ALTER TABLE `natural_disaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nea_helped_country`
--

DROP TABLE IF EXISTS `nea_helped_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nea_helped_country` (
  `disaster_situation_id` int NOT NULL,
  `agency_name` varchar(255) NOT NULL,
  `country_name` varchar(255) NOT NULL,
  PRIMARY KEY (`disaster_situation_id`,`agency_name`,`country_name`),
  KEY `agency_name` (`agency_name`),
  KEY `country_name` (`country_name`),
  CONSTRAINT `nea_helped_country_ibfk_1` FOREIGN KEY (`disaster_situation_id`) REFERENCES `disaster_situation` (`disasterSituationID`),
  CONSTRAINT `nea_helped_country_ibfk_2` FOREIGN KEY (`agency_name`) REFERENCES `national_emergency_agency` (`agency_name`),
  CONSTRAINT `nea_helped_country_ibfk_3` FOREIGN KEY (`country_name`) REFERENCES `country` (`country_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nea_helped_country`
--

LOCK TABLES `nea_helped_country` WRITE;
/*!40000 ALTER TABLE `nea_helped_country` DISABLE KEYS */;
INSERT INTO `nea_helped_country` VALUES (1,'Chernobyl Disaster Response Unit','Ukraine'),(3,'China National Flood Relief Commission','China'),(6,'Gulf Coast Disaster Management Authority','United States'),(2,'Japan Disaster Response Agency','Japan'),(7,'Japan Environmental Health Organization','Japan'),(7,'Kumamoto Prefecture Health Bureau','Japan'),(5,'Syria Crisis Management Authority','Syria'),(2,'Tohoku Regional Emergency Management Office','Japan'),(4,'Turkey National Disaster Response Agency','Turkey'),(6,'U.S. Environmental Protection Agency Gulf','United States'),(1,'Ukraine National Radiation Safety Committee','Ukraine');
/*!40000 ALTER TABLE `nea_helped_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ngo`
--

DROP TABLE IF EXISTS `ngo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ngo` (
  `website` varchar(255) DEFAULT NULL,
  `organisation_name` varchar(255) DEFAULT NULL,
  `organisation_id` int NOT NULL AUTO_INCREMENT,
  `contact_num` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`organisation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ngo`
--

LOCK TABLES `ngo` WRITE;
/*!40000 ALTER TABLE `ngo` DISABLE KEYS */;
INSERT INTO `ngo` VALUES ('www.cchf.ua','Chernobyl Children\'s Health Fund',1,'+380-44-555-9876','care@cchf.ua'),('www.nsa.org.ua','Nuclear Safety Alliance',2,'+380-44-555-1122','info@nsa.org.ua'),('www.trn.jp','Tohoku Recovery Network',3,'+81-22-555-6789','support@trn.jp'),('www.jerf.jp','Japan Earthquake Relief Foundation',4,'+81-3-5550-4321','contact@jerf.jp'),('www.cfralliance.cn','China Flood Relief Alliance',5,'+86-10-5550-1234','support@cfralliance.cn'),('www.hdrf.cn','Historical Disaster Research & Aid Foundation',6,'+86-21-5550-7890','contact@hdrf.cn'),('www.aea.tr','Anatolian Earthquake Assistance',7,'+90-312-555-0199','help@aea.tr'),('www.shsg.sy','Syrian Humanitarian Support Group',8,'+963-11-555-9876','aid@shsg.sy'),('www.olps.org','Ocean Life Preservation Society',9,'+1-800-555-0199','contact@olps.org'),('www.gmai.jp','Global Mercury Awareness Initiative',10,'+81-3-5550-7894','support@gmai.jp');
/*!40000 ALTER TABLE `ngo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ngo_responds_to_country`
--

DROP TABLE IF EXISTS `ngo_responds_to_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ngo_responds_to_country` (
  `organization_id` int NOT NULL,
  `disaster_situation_id` int NOT NULL,
  PRIMARY KEY (`organization_id`,`disaster_situation_id`),
  KEY `disaster_situation_id` (`disaster_situation_id`),
  CONSTRAINT `ngo_responds_to_country_ibfk_1` FOREIGN KEY (`organization_id`) REFERENCES `ngo` (`organisation_id`),
  CONSTRAINT `ngo_responds_to_country_ibfk_2` FOREIGN KEY (`disaster_situation_id`) REFERENCES `disaster_situation` (`disasterSituationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ngo_responds_to_country`
--

LOCK TABLES `ngo_responds_to_country` WRITE;
/*!40000 ALTER TABLE `ngo_responds_to_country` DISABLE KEYS */;
INSERT INTO `ngo_responds_to_country` VALUES (1,1),(2,1),(3,2),(4,2),(5,3),(6,3),(7,4),(8,4),(8,5),(9,6),(10,7);
/*!40000 ALTER TABLE `ngo_responds_to_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `people_affected_by_disasters`
--

DROP TABLE IF EXISTS `people_affected_by_disasters`;
/*!50001 DROP VIEW IF EXISTS `people_affected_by_disasters`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `people_affected_by_disasters` AS SELECT 
 1 AS `person_name`,
 1 AS `person_surname`,
 1 AS `age`,
 1 AS `disaster_name`,
 1 AS `Base_location`,
 1 AS `year`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `person_id` int NOT NULL AUTO_INCREMENT,
  `age` int DEFAULT NULL,
  `person_name` varchar(255) DEFAULT NULL,
  `person_surname` varchar(255) DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
  `status` enum('Missing','Dead','Injured','Evacuated') DEFAULT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=447 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (101,32,'Akira','Tanaka','Male','Japanese','Injured'),(105,34,'Ivan','Kuznetsov','Male','Russian','Dead'),(106,29,'Elena','Petrova','Female','Ukrainian','Evacuated'),(108,41,'Hiroshi','Sato','Male','Japanese','Missing'),(125,45,'James','Carter','Male','American','Injured'),(139,37,'Maria','Rodriquez','Female','American','Dead'),(177,39,'Li','Wei','Male','Chinese','Missing'),(188,33,'Chen','Yue','Female','Chinese','Dead'),(207,28,'Yumi','Nakamura','Female','Japanese','Dead'),(256,36,'Keiko','Ishikawa','Female','Japanese','Evacuated'),(352,47,'Mehmet','Ozcan','Male','Turkish','Injured'),(446,54,'Amina','Hassan','Female','Syrian','Dead');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `articles_about_disasters`
--

/*!50001 DROP VIEW IF EXISTS `articles_about_disasters`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `articles_about_disasters` AS select `d`.`Disaster_name` AS `disaster_name`,`ma`.`author` AS `author`,`ma`.`title` AS `title`,`ma`.`publication_date` AS `publication_date` from (`media_article` `ma` join `disaster` `d` on((`ma`.`disaster_id` = `d`.`Disaster_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `disaster_date_deaths_cost`
--

/*!50001 DROP VIEW IF EXISTS `disaster_date_deaths_cost`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `disaster_date_deaths_cost` AS select `d`.`Disaster_name` AS `disaster_name`,`d`.`start_date` AS `start_date`,`d`.`deaths` AS `deaths`,`ds`.`Total_cost` AS `total_cost` from (`disaster_situation` `ds` join `disaster` `d` on((`ds`.`disaster_id` = `d`.`Disaster_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `people_affected_by_disasters`
--

/*!50001 DROP VIEW IF EXISTS `people_affected_by_disasters`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `people_affected_by_disasters` AS select `p`.`person_name` AS `person_name`,`p`.`person_surname` AS `person_surname`,`p`.`age` AS `age`,`d`.`Disaster_name` AS `disaster_name`,`d`.`Base_location` AS `Base_location`,year(`d`.`start_date`) AS `year` from ((`disaster_affected_person` `dap` join `person` `p` on((`dap`.`person_id` = `p`.`person_id`))) join `disaster` `d` on((`dap`.`disaster_id` = `d`.`Disaster_ID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-12-22 22:55:58
