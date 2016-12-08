CREATE DATABASE  IF NOT EXISTS `nas` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `nas`;
-- MySQL dump 10.13  Distrib 5.7.9, for linux-glibc2.5 (x86_64)
--
-- Host: localhost    Database: nas
-- ------------------------------------------------------
-- Server version	5.7.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accountUsers`
--

DROP TABLE IF EXISTS `accountUsers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountUsers` (
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `userId` varchar(40) NOT NULL DEFAULT '',
  `accountId` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`userId`,`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountUsers`
--

LOCK TABLES `accountUsers` WRITE;
/*!40000 ALTER TABLE `accountUsers` DISABLE KEYS */;
/*!40000 ALTER TABLE `accountUsers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emap`
--

DROP TABLE IF EXISTS `emap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emap` (
  `id` varchar(40) NOT NULL,
  `store` varchar(32) NOT NULL DEFAULT 'nas',
  `hash` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`,`store`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emap`
--

LOCK TABLES `emap` WRITE;
/*!40000 ALTER TABLE `emap` DISABLE KEYS */;
INSERT INTO `emap` VALUES ('063947fdeb68fb5843238f24adbe94ae48200db6','alpha','d32f882f59b130d2c1dabfc56a36f2e73c5e562f'),('063947fdeb68fb5843238f24adbe94ae48200db6','dev','d32f882f59b130d2c1dabfc56a36f2e73c5e562f');
/*!40000 ALTER TABLE `emap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwordCode`
--

DROP TABLE IF EXISTS `passwordCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwordCode` (
  `id` varchar(40) NOT NULL,
  `email` varchar(128) NOT NULL,
  `userId` varchar(40) DEFAULT NULL,
  `expireDate` datetime NOT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nas_passwordCode_uniq_email_userid` (`email`,`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwordCode`
--

LOCK TABLES `passwordCode` WRITE;
/*!40000 ALTER TABLE `passwordCode` DISABLE KEYS */;
/*!40000 ALTER TABLE `passwordCode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmap`
--

DROP TABLE IF EXISTS `tmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmap` (
  `id` varchar(40) NOT NULL DEFAULT '',
  `store` varchar(32) NOT NULL DEFAULT 'nas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmap`
--

LOCK TABLES `tmap` WRITE;
/*!40000 ALTER TABLE `tmap` DISABLE KEYS */;
INSERT INTO `tmap` VALUES ('5d4ab9dc0bc44fbfd21b453391d90390557c9f20','nas');
/*!40000 ALTER TABLE `tmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` varchar(40) NOT NULL,
  `firstname` varchar(128) DEFAULT NULL,
  `lastname` varchar(128) DEFAULT NULL,
  `email` varchar(128) NOT NULL,
  `inactive` datetime DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('063947fdeb68fb5843238f24adbe94ae48200db6','Netop','Admin1','admin@netop.com',NULL,1,'2014-07-04 12:45:41','2016-09-28 12:53:43',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userEmailValidation`
--

DROP TABLE IF EXISTS `userEmailValidation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userEmailValidation` (
  `validationKey` varchar(40) NOT NULL DEFAULT '',
  `userId` varchar(40) NOT NULL,
  `email` varchar(128) NOT NULL,
  `expireDate` datetime DEFAULT NULL,
  `successUrl` varchar(255) NOT NULL,
  `errorUrl` varchar(255) NOT NULL,
  `validated` varchar(45) DEFAULT NULL,
  `languageMsg` varchar(45) NOT NULL,
  `otherOptions` text,
  `created` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `createdby` varchar(40) NOT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`validationKey`),
  KEY `idx_attribute` (`validationKey`,`expireDate`),
  KEY `idx_expireDate` (`expireDate`),
  KEY `idx_userid` (`userId`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userEmailValidation`
--

LOCK TABLES `userEmailValidation` WRITE;
/*!40000 ALTER TABLE `userEmailValidation` DISABLE KEYS */;
/*!40000 ALTER TABLE `userEmailValidation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_auth`
--

DROP TABLE IF EXISTS `user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_auth` (
  `user_id` varchar(40) NOT NULL,
  `username` varchar(128) NOT NULL,
  `algorithm` varchar(32) NOT NULL,
  `params` text,
  `default` tinyint(1) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `inactive` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`username`,`algorithm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_auth`
--

LOCK TABLES `user_auth` WRITE;
/*!40000 ALTER TABLE `user_auth` DISABLE KEYS */;
INSERT INTO `user_auth` VALUES ('063947fdeb68fb5843238f24adbe94ae48200db6','admin@netop.com','netop-v1.0.0','{\"algorithm\":\"netop\",\"encoding\":\"base64\",\"iterations\":2500,\"keylength\":240,\"saltlength\":240,\"salt\":\"e7974aefb1284785939c3dfff9d89dbb38f366ee5683e3a3684a74a07d9e1d3b01f3adae40ba4d16a573f0fba79cc616e3453b9f1c2ae5bf155edfdb371da002b537dfc89fdced47b44f7534be6e73fcff57846c643ab6fd164af4152b3a002abc7d8042d4996f40da15abea28f0be0583e4a82e5c982d12\",\"password\":\"T+j+jkfzgor1ThiL2pn279QO9wswuaBce6a005kRgXAhMMh2X2q58l7zPjy8fFwdrqqCPUKtPh+NrNHXT4kTUVHF0H2zfrstSIWNtjrGAKW9nmenUuLSdlhsTrc6dwSQx72Kyd+V0d8fP87NbqgOaGR3IkMbpwg40KjpnG0YzpI5eSvbbB7uchK13D+J6g6MaTqQVR6KVS85PMprODMOigBC/9vaq+93BHXjKh6TGH5zPbWL/uWM5I4aHDzJprgPeNxl1WjbbB4hKdnYHyJaEkPt09znhYjnFYPxdwj/kKTlvlvxbw8Nu+7GmLmQjhb8\"}',NULL,'2014-09-24 10:58:33','2014-11-05 16:22:48',NULL);
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-08 17:34:49
CREATE DATABASE  IF NOT EXISTS `portal` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `portal`;
-- MySQL dump 10.13  Distrib 5.7.9, for linux-glibc2.5 (x86_64)
--
-- Host: localhost    Database: portal
-- ------------------------------------------------------
-- Server version	5.7.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `id` varchar(40) NOT NULL,
  `company` varchar(128) NOT NULL,
  `seats` int(11) NOT NULL,
  `from` datetime NOT NULL,
  `to` datetime DEFAULT NULL,
  `inactive` datetime DEFAULT NULL,
  `salesforce_id` varchar(128) NOT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `trial` int(11) DEFAULT '0',
  `everyone` varchar(40) DEFAULT NULL,
  `everything` varchar(40) DEFAULT NULL,
  `contact` text,
  `language` varchar(128) DEFAULT NULL,
  `timezone` varchar(45) DEFAULT NULL,
  `authStep` enum('AUTH_PORTAL') NOT NULL DEFAULT 'AUTH_PORTAL',
  `mfaStep` enum('MFA_UNSET','MFA_EMAIL_ENABLED','MFA_EMAIL_ENFORCED') NOT NULL DEFAULT 'MFA_UNSET',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account`
--

LOCK TABLES `account` WRITE;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
INSERT INTO `account` VALUES ('063947fdeb68fb5843238f24adbe94ae48200dc7','Netop Superadmins',100,'2014-08-18 00:00:00',NULL,NULL,'asdasdsadasdasdasdsa',NULL,NULL,NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,'b9d486855f6000006412b6481453893643741713','30041edb80e2651fb50e3b051453893643741700',NULL,NULL,NULL,'AUTH_PORTAL','MFA_UNSET');
/*!40000 ALTER TABLE `account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accountUsers`
--

DROP TABLE IF EXISTS `accountUsers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountUsers` (
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `userId` varchar(40) NOT NULL DEFAULT '',
  `accountId` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`userId`,`accountId`),
  UNIQUE KEY `oneAccountPerUser` (`userId`),
  KEY `accountUsers_idx_accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountUsers`
--

LOCK TABLES `accountUsers` WRITE;
/*!40000 ALTER TABLE `accountUsers` DISABLE KEYS */;
INSERT INTO `accountUsers` VALUES (1,'2016-10-20 07:34:30','2016-10-20 07:34:30',NULL,'063947fdeb68fb5843238f24adbe94ae48200db6','063947fdeb68fb5843238f24adbe94ae48200dc7');
/*!40000 ALTER TABLE `accountUsers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelog`
--

DROP TABLE IF EXISTS `changelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changelog` (
  `id` varchar(40) NOT NULL,
  `title` varchar(255) NOT NULL,
  `summary` varchar(255) NOT NULL,
  `description` text,
  `inactive` datetime DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `display` tinyint(1) DEFAULT '0',
  `highlight` tinyint(1) DEFAULT '0',
  `highlight_expire` datetime DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_inactive` (`inactive`),
  KEY `idx_display` (`display`),
  KEY `idx_hightlight` (`highlight`),
  KEY `idx_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changelog`
--

LOCK TABLES `changelog` WRITE;
/*!40000 ALTER TABLE `changelog` DISABLE KEYS */;
INSERT INTO `changelog` VALUES ('6b51d431df5d7f141cbececc1466584946317625','June 22, 2016','test bla bla ','[\"Permissions associated with Roles have been updated to better align with their descriptions. Specific permissions were added or removed as needed for each Role to ensure the total set of permissions corresponds to the description of the Role\", \"A notification bar has been added to the Portal to alert users of important information and announcements\", \"Email validation is now available from the user profile screen. Email validation provides a recovery email address that can be used in case of a forgotten password\", \"A Recent Updates panel was added to the Portal Dashboard screen to provide information on changes made to Netop Remote Control and the Netop Portal\", \"The username field on the login screen is no longer case sensitive\", \"Fixed an issue where group assignments were removed when a Host went offline and then reconnected to the Portal\"]',NULL,'2016-02-22 00:00:00',1,1,'2017-12-17 14:45:15',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `changelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelogAudience`
--

DROP TABLE IF EXISTS `changelogAudience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changelogAudience` (
  `id` varchar(40) NOT NULL,
  `changelogId` varchar(40) NOT NULL,
  `target` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pk` (`changelogId`,`target`),
  KEY `idx_id` (`changelogId`),
  KEY `idx_target` (`target`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changelogAudience`
--

LOCK TABLES `changelogAudience` WRITE;
/*!40000 ALTER TABLE `changelogAudience` DISABLE KEYS */;
INSERT INTO `changelogAudience` VALUES ('4523540f1504cd17100c48351466584946318608','6b51d431df5d7f141cbececc1466584946317625','user',NULL,NULL,NULL),('b17ef6d19c7a5b1ee83b907c1466584946318582','6b51d431df5d7f141cbececc1466584946317625','superadmin',NULL,NULL,NULL),('e629fa6598d732768f7c726b1466584946318552','6b51d431df5d7f141cbececc1466584946317625','administrator',NULL,NULL,NULL);
/*!40000 ALTER TABLE `changelogAudience` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `changelogType`
--

DROP TABLE IF EXISTS `changelogType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `changelogType` (
  `id` varchar(40) NOT NULL,
  `changelogId` varchar(40) NOT NULL,
  `typeLog` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pk` (`changelogId`,`typeLog`),
  KEY `idx_id` (`changelogId`),
  KEY `idx_type_log` (`typeLog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changelogType`
--

LOCK TABLES `changelogType` WRITE;
/*!40000 ALTER TABLE `changelogType` DISABLE KEYS */;
INSERT INTO `changelogType` VALUES ('b7a56873cd771f2c446d369b1466584946318634','6b51d431df5d7f141cbececc1466584946317625','changelog',NULL,NULL,NULL);
/*!40000 ALTER TABLE `changelogType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device` (
  `id` varchar(40) NOT NULL,
  `microtime` float DEFAULT '0',
  `status` tinyint(1) NOT NULL,
  `host_name` varchar(128) NOT NULL,
  `host_alias` varchar(128) DEFAULT NULL,
  `state` text,
  `deletedby` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `accountId` varchar(40) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `groupId` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `device_ids_groupId` (`groupId`),
  KEY `idx_device_accountId` (`accountId`),
  KEY `idx_device_test` (`accountId`,`status`,`deleted`,`host_name`),
  KEY `idx_device_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deviceGroup`
--

DROP TABLE IF EXISTS `deviceGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deviceGroup` (
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `deviceId` varchar(40) NOT NULL DEFAULT '',
  `groupId` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`deviceId`,`groupId`),
  KEY `deviceGroup_idx_groupId` (`groupId`),
  KEY `deviceGroup_idx_userId` (`deviceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deviceGroup`
--

LOCK TABLES `deviceGroup` WRITE;
/*!40000 ALTER TABLE `deviceGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `deviceGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emap`
--

DROP TABLE IF EXISTS `emap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emap` (
  `id` varchar(40) NOT NULL,
  `store` varchar(32) NOT NULL DEFAULT 'nas',
  `hash` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`,`store`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emap`
--

LOCK TABLES `emap` WRITE;
/*!40000 ALTER TABLE `emap` DISABLE KEYS */;
/*!40000 ALTER TABLE `emap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `id` varchar(40) NOT NULL,
  `accountId` varchar(40) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `inactive` datetime DEFAULT NULL,
  `parentId` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` varchar(45) DEFAULT NULL,
  `group_type` tinyint(1) DEFAULT '1',
  `old_id` varchar(45) DEFAULT NULL,
  `read_only` tinyint(1) DEFAULT '0',
  `special_group` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_group_name_types` (`name`,`accountId`,`group_type`),
  KEY `parentId` (`parentId`),
  KEY `group_idx_accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES ('30041edb80e2651fb50e3b051453893643741700','063947fdeb68fb5843238f24adbe94ae48200dc7','everything',NULL,NULL,NULL,NULL,NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,2,'',1,1),('b9d486855f6000006412b6481453893643741713','063947fdeb68fb5843238f24adbe94ae48200dc7','everyone',NULL,NULL,NULL,NULL,NULL,'0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,1,'',1,1);
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mfaOneTimeCodes`
--

DROP TABLE IF EXISTS `mfaOneTimeCodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mfaOneTimeCodes` (
  `id` varchar(36) NOT NULL,
  `userId` varchar(40) NOT NULL,
  `codeHash` text NOT NULL,
  `algorithm` text NOT NULL,
  `created` datetime NOT NULL,
  `used` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mfaOneTimeCodes_userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mfaOneTimeCodes`
--

LOCK TABLES `mfaOneTimeCodes` WRITE;
/*!40000 ALTER TABLE `mfaOneTimeCodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `mfaOneTimeCodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwordCode`
--

DROP TABLE IF EXISTS `passwordCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwordCode` (
  `id` varchar(40) NOT NULL,
  `email` varchar(128) NOT NULL,
  `userId` varchar(40) DEFAULT NULL,
  `expire_date` datetime NOT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwordCode`
--

LOCK TABLES `passwordCode` WRITE;
/*!40000 ALTER TABLE `passwordCode` DISABLE KEYS */;
/*!40000 ALTER TABLE `passwordCode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `id` varchar(40) NOT NULL,
  `type` int(11) DEFAULT NULL COMMENT 'type:  1 - portal',
  `area` int(11) DEFAULT NULL COMMENT '1 - users\n2 - devices\n3 - groups',
  `name` int(11) DEFAULT NULL COMMENT '1 - list\n2 - view\n3 - add\n4 - edit\n5 - delete\n6 - move to group\n7 - BBSC',
  `old_id` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_permission_id` (`id`),
  UNIQUE KEY `uniq_permission_code` (`type`,`area`,`name`),
  KEY `old_id` (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES ('0b918943df0962bc7a1824c01457946711430634',2,1,3,'39'),('108c995b953c8a35561103e21457946711535698',2,1,14,'65'),('19581e27de7ced00ff1ce50b1457946711967040',1,1,9,'9'),('1abfdf237d062d04e592fa941471425433717475',2,4,4,NULL),('2c624232cdd221771294dfbb1457946711817655',1,1,8,'8'),('349c41201b62db851192665c1457946711783506',2,1,9,'78'),('35135aaa6cc23891b40cb3f31457946711222849',1,6,1,'29'),('3fdba35f04dc8c462986c9921457946710932360',1,2,7,'13'),('44c8031cb036a7350d8b9b861457946711947778',2,3,1,'84'),('4523540f1504cd17100c48351457946711003722',1,3,4,'17'),('48449a14a4ff7d79bb7a1b6f1457946711836148',2,1,11,'80'),('49d180ecf56132819571bf391457946711554949',2,1,16,'67'),('4a44dc15364204a80fe80e901457946710877095',1,2,1,'10'),('4b0379678f664340b010747a1471425433717529',2,4,6,NULL),('4b227777d4dd1fc61c6f884f1457946711452471',1,1,4,'4'),('4e07408562bedb8b60ce05c11457946711249797',1,1,3,'3'),('4e103ffd9a1e40c6d18d4ccc1471425433716802',2,4,1,NULL),('4ec9599fc203d176a301536c1457946711032873',1,3,5,'18'),('4fc82b26aecb47d2868c4efb1457946710890684',1,2,2,'11'),('5316ca1c5ddca8e6ceccfce51457946711849695',2,1,12,'81'),('535fa30d7e25dd8a49f153671457946711140750',1,5,3,'23'),('59e19706d51d39f66711c2651457946711204662',1,5,8,'28'),('624b60c58c9d8bfb6ff1886c1457946711265298',1,6,2,'30'),('670671cd97404156226e50791457946711182268',1,5,7,'27'),('6b51d431df5d7f141cbececc1457946710911697',1,2,4,'12'),('6b86b273ff34fce19d6b804e1457946710854560',1,1,1,'1'),('6f4b6612125fb3a0daecd2791457946711099601',1,5,1,'21'),('76a50887d8f1c2e9301755421457946711389345',1,2,8,'36'),('785f3ec7eb32f30b90cd0fcf1457946711123630',1,5,2,'22'),('7902699be42c8a8e46fbbb451457946711607432',1,1,7,'7'),('7f2253d7e228b22a08bda1f01457946711646349',2,1,20,'71'),('8527a891e224136950ff32ca1457946710951435',1,3,1,'14'),('86e50149658661312a9e0b351457946711354836',3,1,2,'34'),('8722616204217eddb39e7df91457946711674031',2,2,1,'72'),('9400f1b21cb527d7fa3d3eab1457946711043908',1,4,1,'19'),('96061e92f58e4bdcdee73df31457946711686874',2,1,4,'73'),('98a3ab7c340e8a033e7b37b61457946711800230',2,1,10,'79'),('9f14025af0065b30e47e23eb1457946711371910',2,1,1,'35'),('a21855da08cb102d1d217c531457946711575802',2,1,17,'68'),('a46e37632fa6ca51a13fe39a1457946711891646',1,6,4,'82'),('a68b412c4282555f15546cf61457946711521157',2,1,13,'64'),('a88a7902cb4ef697ba0b67591457946711757660',2,1,8,'77'),('aea92132c4cbeb263e6ac2bf1457946711416124',2,1,2,'38'),('b17ef6d19c7a5b1ee83b907c1457946710991925',1,3,3,'16'),('b3d093ffde5f9d8d1530cd571471425433717413',2,4,2,NULL),('b7a56873cd771f2c446d369b1457946711165271',1,5,5,'25'),('bbb965ab0c80d6538cf2184b1457946711914870',2,1,21,'83'),('c2356069e9d1e79ca92437811457946711151560',1,5,4,'24'),('c6f3ac57944a531490cd39901457946711324884',3,1,1,'33'),('c75cb66ae28d8ebc6eded0021457946711593168',2,1,18,'69'),('cad4af87659897abb7e9254d1471425433717502',2,4,5,NULL),('d4735e3a265e16eee03f59711457946711061862',1,1,2,'2'),('e29c9c180c6279b0b02abd6a1457946711308842',1,6,5,'32'),('e629fa6598d732768f7c726b1457946710965809',1,3,2,'15'),('e7f6c011776e8db7cd330b541457946711492499',1,1,6,'6'),('eb1e33e8a81b697b75855af61457946711282513',1,6,3,'31'),('eb624dbe56eb6620ae62080c1457946711706493',2,1,5,'74'),('ef2d127de37b942baad061451457946711468448',1,1,5,'5'),('f369cb89fc627e668987007d1457946711717635',2,1,6,'75'),('f5ca38f748a1d6eaf726b8a41457946711077934',1,4,2,'20'),('f74efabef12ea619e30b79bd1457946711740706',2,1,7,'76'),('f95365c4461a3b1a0757d73d1471425433717446',2,4,3,NULL),('ff5a1ae012afa5d4c889c50a1457946711630285',2,1,19,'70');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` varchar(40) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` text,
  `status` tinyint(1) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `accountId` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  `portalDefault` tinyint(1) DEFAULT '0',
  `old_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_role_name` (`name`),
  KEY `idx_role_role_accountId` (`accountId`),
  KEY `idx_role_accountid_deleted` (`accountId`,`deleted`),
  KEY `old_id` (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('480f5a496560ae4228bb79771457946710814250','Manager','The Manager role provides keyboard, video and mouse control through the Browser Based Support Console or an installed Guest. In addition, those with an installed Guest have Get Inventory, Chat, File Transfer and Remote Management permissions enabled.',1,2,NULL,NULL,NULL,NULL,'2016-02-22 06:21:17',NULL,NULL,1,409),('a46e37632fa6ca51a13fe39a1457946710814651','Administrator','The Administrator role provides full access to the remote device when using the Browser Based Support Console or an installed Guest.',1,2,NULL,NULL,NULL,NULL,'2016-02-22 06:21:17',NULL,NULL,1,82),('a5abb1500bdeaef41e2edd591457946710814024','Technician','The Technician role provides keyboard, video and mouse control through the Browser Based Support Console or an installed Guest. In addition, those with an installed Guest have Get Inventory and Chat permissions enabled.',1,2,NULL,NULL,NULL,NULL,'2016-02-22 06:21:17',NULL,NULL,1,407),('a73b320dc0d3a57c03f897eb1457946710813631','View Only','View Only allows the Guest user to view the screen of the Host from the installed Guest software or from the Browser Based Support Console. Permissions are restricted to viewing the screen only, no additional capabilities or permissions are provided.',1,2,NULL,'c85effd250b7b52605dadb0c15f970c7d02f7a9d',NULL,NULL,'2016-02-22 06:21:17','2016-05-24 12:50:17',NULL,1,405),('d26eae87829adde551bf4b85145794671081','Add Devices','This role provides communication with the Netop Portal, but does not include any permissions or rights. Netop recommends the creation of dedicated user(s) assigned to the Add Devices role so that individuals do not enter their own username and password when enrolling devices in the Portal. For example, an Administrator may create a user named \'portal_access@mycompany.com\' and assign them the \'Add Devices\' role. The portal_access@mycompany.com credentials would be used in the configuration of the Guest & Host Communication Profile.',1,3,NULL,NULL,NULL,NULL,'2016-02-22 06:21:17',NULL,NULL,1,403),('e6f47e008cc58b38596e6fdf1457946710814145','Engineer','The Engineer role provides keyboard, video and mouse control through the Browser Based Support Console or an installed Guest. In addition, those with an installed Guest have Get Inventory, Chat and File Transfer permissions enabled.',1,2,NULL,NULL,NULL,NULL,'2016-02-22 06:21:17',NULL,NULL,1,408),('f64f410744d9470ffe2d6b9e1457946710813933','Web Support','Web Support provides full access to the Browser Based Support Console. Access from an installed Guest is not allowed.',1,2,NULL,'c85effd250b7b52605dadb0c15f970c7d02f7a9d',NULL,NULL,'2016-02-22 06:21:17','2016-04-12 13:00:59',NULL,1,406);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleAssignment`
--

DROP TABLE IF EXISTS `roleAssignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roleAssignment` (
  `id` varchar(40) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `supporters` varchar(40) NOT NULL,
  `role` varchar(40) NOT NULL,
  `devices` varchar(40) DEFAULT NULL,
  `inactive` int(1) DEFAULT '0',
  `accountId` varchar(40) NOT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `roleAssignment_idx_accountId` (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleAssignment`
--

LOCK TABLES `roleAssignment` WRITE;
/*!40000 ALTER TABLE `roleAssignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `roleAssignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolePermissions`
--

DROP TABLE IF EXISTS `rolePermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolePermissions` (
  `roleId` varchar(40) NOT NULL DEFAULT '',
  `permissionId` varchar(40) NOT NULL DEFAULT '',
  `allow` tinyint(1) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `old_role_id` varchar(40) DEFAULT NULL,
  `old_permission_id` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`roleId`,`permissionId`),
  KEY `old_role_id_idx` (`old_role_id`),
  KEY `old_permission_id_idx` (`old_permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolePermissions`
--

LOCK TABLES `rolePermissions` WRITE;
/*!40000 ALTER TABLE `rolePermissions` DISABLE KEYS */;
INSERT INTO `rolePermissions` VALUES ('480f5a496560ae4228bb79771457946710814250','108c995b953c8a35561103e21457946711535698',1,'2016-02-22 06:21:17',NULL,'409','65'),('480f5a496560ae4228bb79771457946710814250','1abfdf237d062d04e592fa941471425433717475',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','48449a14a4ff7d79bb7a1b6f1457946711836148',1,'2016-02-22 06:21:17',NULL,'409','80'),('480f5a496560ae4228bb79771457946710814250','49d180ecf56132819571bf391457946711554949',1,'2016-02-22 06:21:17',NULL,'409','67'),('480f5a496560ae4228bb79771457946710814250','4b0379678f664340b010747a1471425433717529',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','4e103ffd9a1e40c6d18d4ccc1471425433716802',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','8722616204217eddb39e7df91457946711674031',1,'2016-02-22 06:21:17',NULL,'409','72'),('480f5a496560ae4228bb79771457946710814250','98a3ab7c340e8a033e7b37b61457946711800230',1,'2016-02-22 06:21:17',NULL,'409','79'),('480f5a496560ae4228bb79771457946710814250','9f14025af0065b30e47e23eb1457946711371910',1,'2016-02-22 06:21:17',NULL,'409','35'),('480f5a496560ae4228bb79771457946710814250','aea92132c4cbeb263e6ac2bf1457946711416124',1,'2016-02-22 06:21:17',NULL,'409','38'),('480f5a496560ae4228bb79771457946710814250','b3d093ffde5f9d8d1530cd571471425433717413',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','cad4af87659897abb7e9254d1471425433717502',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','f74efabef12ea619e30b79bd1457946711740706',1,'2016-02-22 06:21:17',NULL,'409','76'),('480f5a496560ae4228bb79771457946710814250','f95365c4461a3b1a0757d73d1471425433717446',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('480f5a496560ae4228bb79771457946710814250','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-04-12 12:49:47',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','0b918943df0962bc7a1824c01457946711430634',1,'2016-02-22 06:21:17',NULL,'82','39'),('a46e37632fa6ca51a13fe39a1457946710814651','108c995b953c8a35561103e21457946711535698',1,'2016-02-22 06:21:17',NULL,'82','65'),('a46e37632fa6ca51a13fe39a1457946710814651','1abfdf237d062d04e592fa941471425433717475',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','349c41201b62db851192665c1457946711783506',1,'2016-02-22 06:21:17',NULL,'82','78'),('a46e37632fa6ca51a13fe39a1457946710814651','44c8031cb036a7350d8b9b861457946711947778',1,'2016-02-22 06:21:17',NULL,'82','84'),('a46e37632fa6ca51a13fe39a1457946710814651','48449a14a4ff7d79bb7a1b6f1457946711836148',1,'2016-02-22 06:21:17',NULL,'82','80'),('a46e37632fa6ca51a13fe39a1457946710814651','49d180ecf56132819571bf391457946711554949',1,'2016-02-22 06:21:17',NULL,'82','67'),('a46e37632fa6ca51a13fe39a1457946710814651','4b0379678f664340b010747a1471425433717529',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','4e103ffd9a1e40c6d18d4ccc1471425433716802',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','5316ca1c5ddca8e6ceccfce51457946711849695',1,'2016-02-22 06:21:17',NULL,'82','81'),('a46e37632fa6ca51a13fe39a1457946710814651','7f2253d7e228b22a08bda1f01457946711646349',1,'2016-02-22 06:21:17',NULL,'82','71'),('a46e37632fa6ca51a13fe39a1457946710814651','8722616204217eddb39e7df91457946711674031',1,'2016-02-22 06:21:17',NULL,'82','72'),('a46e37632fa6ca51a13fe39a1457946710814651','96061e92f58e4bdcdee73df31457946711686874',1,'2016-02-22 06:21:17',NULL,'82','73'),('a46e37632fa6ca51a13fe39a1457946710814651','98a3ab7c340e8a033e7b37b61457946711800230',1,'2016-02-22 06:21:17',NULL,'82','79'),('a46e37632fa6ca51a13fe39a1457946710814651','9f14025af0065b30e47e23eb1457946711371910',1,'2016-02-22 06:21:17',NULL,'82','35'),('a46e37632fa6ca51a13fe39a1457946710814651','a21855da08cb102d1d217c531457946711575802',1,'2016-02-22 06:21:17',NULL,'82','68'),('a46e37632fa6ca51a13fe39a1457946710814651','a68b412c4282555f15546cf61457946711521157',1,'2016-02-22 06:21:17',NULL,'82','64'),('a46e37632fa6ca51a13fe39a1457946710814651','a88a7902cb4ef697ba0b67591457946711757660',1,'2016-02-22 06:21:17',NULL,'82','77'),('a46e37632fa6ca51a13fe39a1457946710814651','aea92132c4cbeb263e6ac2bf1457946711416124',1,'2016-02-22 06:21:17',NULL,'82','38'),('a46e37632fa6ca51a13fe39a1457946710814651','b3d093ffde5f9d8d1530cd571471425433717413',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','bbb965ab0c80d6538cf2184b1457946711914870',1,'2016-02-22 06:21:17',NULL,'82','83'),('a46e37632fa6ca51a13fe39a1457946710814651','c75cb66ae28d8ebc6eded0021457946711593168',1,'2016-02-22 06:21:17',NULL,'82','69'),('a46e37632fa6ca51a13fe39a1457946710814651','cad4af87659897abb7e9254d1471425433717502',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','eb624dbe56eb6620ae62080c1457946711706493',1,'2016-02-22 06:21:17',NULL,'82','74'),('a46e37632fa6ca51a13fe39a1457946710814651','f369cb89fc627e668987007d1457946711717635',1,'2016-02-22 06:21:17',NULL,'82','75'),('a46e37632fa6ca51a13fe39a1457946710814651','f74efabef12ea619e30b79bd1457946711740706',1,'2016-02-22 06:21:17',NULL,'82','76'),('a46e37632fa6ca51a13fe39a1457946710814651','f95365c4461a3b1a0757d73d1471425433717446',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a46e37632fa6ca51a13fe39a1457946710814651','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-02-22 06:21:17',NULL,'82','70'),('a5abb1500bdeaef41e2edd591457946710814024','1abfdf237d062d04e592fa941471425433717475',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','49d180ecf56132819571bf391457946711554949',1,'2016-02-22 06:21:17',NULL,'407','67'),('a5abb1500bdeaef41e2edd591457946710814024','4b0379678f664340b010747a1471425433717529',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','4e103ffd9a1e40c6d18d4ccc1471425433716802',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','8722616204217eddb39e7df91457946711674031',1,'2016-02-22 06:21:17',NULL,'407','72'),('a5abb1500bdeaef41e2edd591457946710814024','9f14025af0065b30e47e23eb1457946711371910',1,'2016-02-22 06:21:17',NULL,'407','35'),('a5abb1500bdeaef41e2edd591457946710814024','aea92132c4cbeb263e6ac2bf1457946711416124',1,'2016-02-22 06:21:17',NULL,'407','38'),('a5abb1500bdeaef41e2edd591457946710814024','b3d093ffde5f9d8d1530cd571471425433717413',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','cad4af87659897abb7e9254d1471425433717502',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','f74efabef12ea619e30b79bd1457946711740706',1,'2016-02-22 06:21:17',NULL,'407','76'),('a5abb1500bdeaef41e2edd591457946710814024','f95365c4461a3b1a0757d73d1471425433717446',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('a5abb1500bdeaef41e2edd591457946710814024','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-04-12 12:49:47',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','1abfdf237d062d04e592fa941471425433717475',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','4b0379678f664340b010747a1471425433717529',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','4e103ffd9a1e40c6d18d4ccc1471425433716802',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','8722616204217eddb39e7df91457946711674031',1,'2016-05-24 12:50:17','2016-05-24 12:50:17',NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','9f14025af0065b30e47e23eb1457946711371910',1,'2016-05-24 12:50:17','2016-05-24 12:50:17',NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','b3d093ffde5f9d8d1530cd571471425433717413',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','cad4af87659897abb7e9254d1471425433717502',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','f95365c4461a3b1a0757d73d1471425433717446',1,'2016-08-17 12:17:14',NULL,NULL,NULL),('a73b320dc0d3a57c03f897eb1457946710813631','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-05-24 12:50:17','2016-05-24 12:50:17',NULL,NULL),('d26eae87829adde551bf4b851457946710812859','c6f3ac57944a531490cd39901457946711324884',1,'2016-02-22 06:21:17',NULL,'403','33'),('e6f47e008cc58b38596e6fdf1457946710814145','1abfdf237d062d04e592fa941471425433717475',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','48449a14a4ff7d79bb7a1b6f1457946711836148',1,'2016-02-22 06:21:17',NULL,'408','80'),('e6f47e008cc58b38596e6fdf1457946710814145','49d180ecf56132819571bf391457946711554949',1,'2016-02-22 06:21:17',NULL,'408','67'),('e6f47e008cc58b38596e6fdf1457946710814145','4b0379678f664340b010747a1471425433717529',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','4e103ffd9a1e40c6d18d4ccc1471425433716802',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','8722616204217eddb39e7df91457946711674031',1,'2016-02-22 06:21:17',NULL,'408','72'),('e6f47e008cc58b38596e6fdf1457946710814145','98a3ab7c340e8a033e7b37b61457946711800230',1,'2016-02-22 06:21:17',NULL,'408','79'),('e6f47e008cc58b38596e6fdf1457946710814145','9f14025af0065b30e47e23eb1457946711371910',1,'2016-02-22 06:21:17',NULL,'408','35'),('e6f47e008cc58b38596e6fdf1457946710814145','aea92132c4cbeb263e6ac2bf1457946711416124',1,'2016-02-22 06:21:17',NULL,'408','38'),('e6f47e008cc58b38596e6fdf1457946710814145','b3d093ffde5f9d8d1530cd571471425433717413',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','cad4af87659897abb7e9254d1471425433717502',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','f74efabef12ea619e30b79bd1457946711740706',1,'2016-02-22 06:21:17',NULL,'408','76'),('e6f47e008cc58b38596e6fdf1457946710814145','f95365c4461a3b1a0757d73d1471425433717446',1,'2016-08-17 12:17:13',NULL,NULL,NULL),('e6f47e008cc58b38596e6fdf1457946710814145','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-04-12 12:49:47',NULL,NULL,NULL),('f64f410744d9470ffe2d6b9e1457946710813933','8722616204217eddb39e7df91457946711674031',1,'2016-04-12 13:00:59','2016-04-12 13:00:59',NULL,NULL),('f64f410744d9470ffe2d6b9e1457946710813933','9f14025af0065b30e47e23eb1457946711371910',1,'2016-04-12 13:00:59','2016-04-12 13:00:59',NULL,NULL),('f64f410744d9470ffe2d6b9e1457946710813933','aea92132c4cbeb263e6ac2bf1457946711416124',1,'2016-04-12 13:00:59','2016-04-12 13:00:59',NULL,NULL),('f64f410744d9470ffe2d6b9e1457946710813933','ff5a1ae012afa5d4c889c50a1457946711630285',1,'2016-04-12 13:00:59','2016-04-12 13:00:59',NULL,NULL);
/*!40000 ALTER TABLE `rolePermissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmap`
--

DROP TABLE IF EXISTS `tmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmap` (
  `id` varchar(40) NOT NULL DEFAULT '',
  `store` varchar(32) NOT NULL DEFAULT 'nas',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmap`
--

LOCK TABLES `tmap` WRITE;
/*!40000 ALTER TABLE `tmap` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `typeProfiles`
--

DROP TABLE IF EXISTS `typeProfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `typeProfiles` (
  `id` varchar(40) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `alias` varchar(40) DEFAULT NULL,
  `priority` tinyint(4) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`),
  KEY `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `typeProfiles`
--

LOCK TABLES `typeProfiles` WRITE;
/*!40000 ALTER TABLE `typeProfiles` DISABLE KEYS */;
INSERT INTO `typeProfiles` VALUES ('219a6c10465bb8d85b4f266c1474881565085899','Group Manager','groupManager',2,NULL,NULL,NULL,NULL,NULL),('6e3b73f7585b1abe6cb2abdd1474881565085271','Account Owner','accountOwner',8,NULL,NULL,NULL,NULL,NULL),('b512d97e7cbf97c273e4db071474881565085919','User','user',1,NULL,NULL,NULL,NULL,NULL),('ddc397ae75db92c74be2e7341474881565085873','Account Administrator','accountAdmin',4,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `typeProfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` varchar(40) NOT NULL,
  `firstname` varchar(128) DEFAULT NULL,
  `lastname` varchar(128) DEFAULT NULL,
  `username` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `admin` tinyint(4) DEFAULT NULL,
  `inactive` datetime DEFAULT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `groupId` varchar(40) DEFAULT NULL,
  `mfaStep` enum('MFA_UNSET','MFA_EMAIL') NOT NULL DEFAULT 'MFA_UNSET',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `deletedby` (`deletedby`),
  KEY `modifiedby` (`modifiedby`),
  KEY `createdby` (`createdby`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`deletedby`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`modifiedby`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `user_ibfk_3` FOREIGN KEY (`createdby`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('063947fdeb68fb5843238f24adbe94ae48200db6','Netop','Admin1','admin@netop.com','admin@netop.com',1,NULL,NULL,NULL,'063947fdeb68fb5843238f24adbe94ae48200db6','2014-07-01 12:11:31','2016-09-28 12:53:43',NULL,NULL,'MFA_UNSET');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userGroup`
--

DROP TABLE IF EXISTS `userGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userGroup` (
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `deleted` datetime DEFAULT NULL,
  `userId` varchar(40) NOT NULL DEFAULT '',
  `groupId` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`userId`,`groupId`),
  KEY `userGroup_idx_groupId` (`groupId`),
  KEY `userGroup_idx_userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userGroup`
--

LOCK TABLES `userGroup` WRITE;
/*!40000 ALTER TABLE `userGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `userGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userPreferences`
--

DROP TABLE IF EXISTS `userPreferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userPreferences` (
  `userId` varchar(40) NOT NULL,
  `preferences` mediumtext,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userPreferences`
--

LOCK TABLES `userPreferences` WRITE;
/*!40000 ALTER TABLE `userPreferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `userPreferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userTypes`
--

DROP TABLE IF EXISTS `userTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `userTypes` (
  `userId` varchar(45) NOT NULL,
  `typeProfileId` varchar(40) NOT NULL,
  `deletedby` varchar(40) DEFAULT NULL,
  `createdby` varchar(40) DEFAULT NULL,
  `modifiedby` varchar(40) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`userId`,`typeProfileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userTypes`
--

LOCK TABLES `userTypes` WRITE;
/*!40000 ALTER TABLE `userTypes` DISABLE KEYS */;
INSERT INTO `userTypes` VALUES ('063947fdeb68fb5843238f24adbe94ae48200db6','b512d97e7cbf97c273e4db071474881565085919',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `userTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_auth`
--

DROP TABLE IF EXISTS `user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_auth` (
  `user_id` varchar(40) NOT NULL,
  `username` varchar(128) NOT NULL,
  `algorithm` varchar(32) NOT NULL,
  `params` text,
  `default` tinyint(1) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `inactive` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`username`,`algorithm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_auth`
--

LOCK TABLES `user_auth` WRITE;
/*!40000 ALTER TABLE `user_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-08 17:34:49
