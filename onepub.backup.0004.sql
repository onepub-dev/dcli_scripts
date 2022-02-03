-- MariaDB dump 10.19  Distrib 10.5.13-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: onepub
-- ------------------------------------------------------
-- Server version	10.5.13-MariaDB-0ubuntu0.21.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `onepub`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `onepub` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `onepub`;

--
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACTIONENUM` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `ROLE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_action_GUID` (`GUID`),
  KEY `FK_action_ROLE_ID` (`ROLE_ID`),
  CONSTRAINT `FK_action_ROLE_ID` FOREIGN KEY (`ROLE_ID`) REFERENCES `role` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES (1,'packageEdit','2022-02-03 16:04:18','Edit Package','f231c92c-b723-4ada-b482-5a28bb4e77ab','packageEdit','2022-02-03 16:04:18',3),(2,'memberInviteList','2022-02-03 16:04:18','List member Invites','efa12dbd-6043-41ee-bdb3-f106fec5d6f3','memberInviteList','2022-02-03 16:04:18',3),(3,'memberInviteSend','2022-02-03 16:04:18','Send a member Invite','87e1eb38-5fbb-4635-9cbc-3141f8beaad6','memberInviteSend','2022-02-03 16:04:18',3),(4,'publisherDelete','2022-02-03 16:04:18','Delete a publisher','d6df7cbd-870a-4151-92d3-e6dfae2ca48a','publisherDelete','2022-02-03 16:04:18',3),(5,'packageUploadVersion','2022-02-03 16:04:18','Upload a new version package','f013f30d-88a3-4256-9570-6c94a5fec534','packageUploadVersion','2022-02-03 16:04:18',3),(6,'teamCreate','2022-02-03 16:04:18','Create a Team','3f3e2d21-97f4-4b7b-9127-214c13bc2687','teamCreate','2022-02-03 16:04:18',3),(7,'teamDelete','2022-02-03 16:04:18','Delete a Team','b7f4e1a5-ac8a-4c7f-9bf7-24fb5467a54a','teamDelete','2022-02-03 16:04:18',3),(8,'teamAddMultipleLeaders','2022-02-03 16:04:18','This is a licensing constraint controlling whether a	Team can have more than one	Team Leader','4fa25642-b07d-49b4-aed1-3ef2b372fe64','teamAddMultipleLeaders','2022-02-03 16:04:18',3),(9,'systemVariableEdit','2022-02-03 16:04:18','Edit System Variable','30f50a48-21d6-4092-bbed-507003872bb3','systemVariableEdit','2022-02-03 16:04:18',3),(10,'uploaderAdd','2022-02-03 16:04:18','Ability to designate a Member as	an uploader','6e227163-f1af-4ca4-a2e7-ae6cc4e2f3c6','uploaderAdd','2022-02-03 16:04:18',3),(11,'creditCardBill','2022-02-03 16:04:18','Bill a Credit Card','7877bf8e-3779-43be-aaee-4e59a6511e48','creditCardBill','2022-02-03 16:04:18',3),(12,'systemVariableCreate','2022-02-03 16:04:18','Create System Variable','be95a741-36ec-40f2-971e-30a8cccf1a7e','systemVariableCreate','2022-02-03 16:04:18',3),(13,'logList','2022-02-03 16:04:18','List logs','c105d8a9-d1c3-42a8-9395-b5d800a3ebda','logList','2022-02-03 16:04:18',3),(14,'packageCreate','2022-02-03 16:04:18','Create Package','320ec385-633f-4eb3-a004-de0499c877c7','packageCreate','2022-02-03 16:04:18',3),(15,'countryList','2022-02-03 16:04:18','List Countries','84075a91-a556-4b46-94d2-a45b2506c76d','countryList','2022-02-03 16:04:18',3),(16,'publisherCreate','2022-02-03 16:04:18','Create a Publisher','ec924e27-33a2-4c12-a1ed-66cc55a3b8bb','publisherCreate','2022-02-03 16:04:18',3),(17,'packageSearch','2022-02-03 16:04:18','Search Packages','0c502595-8b3e-40cc-9371-eb255eb13b08','packageSearch','2022-02-03 16:04:18',3),(18,'roleDelete','2022-02-03 16:04:18','Delete Roles','874102e7-acce-4054-9794-09b681ef31e2','roleDelete','2022-02-03 16:04:18',3),(19,'memberCreate','2022-02-03 16:04:18','Create a Member','9ce647d1-ed98-48d5-9a10-8763fdc13f1b','memberCreate','2022-02-03 16:04:18',3),(20,'packageDelete','2022-02-03 16:04:18','Delete a Package','8a36c0af-18a3-450d-922a-e494c0a72d95','packageDelete','2022-02-03 16:04:18',3),(21,'systemVariableList','2022-02-03 16:04:18','List System Variable','5f2bcd8c-6dc6-48fd-831c-56f712f4375b','systemVariableList','2022-02-03 16:04:18',3),(22,'memberInviteEdit','2022-02-03 16:04:18','Edit a member Invite','46e222e6-fb76-49fe-b719-3d55c505e290','memberInviteEdit','2022-02-03 16:04:18',3),(23,'uploaderList','2022-02-03 16:04:18','List the Members that	are uploaders','702f3995-99cc-4af3-b8c0-a142fe7077c5','uploaderList','2022-02-03 16:04:18',3),(24,'roleAssign','2022-02-03 16:04:18','Assign a Role to a Member','e4cbbe64-a182-4110-84e3-665bd08e964d','roleAssign','2022-02-03 16:04:18',3),(25,'roleCreate','2022-02-03 16:04:18','Create Roles','4596b836-45ea-42d3-bfea-92e50cefd726','roleCreate','2022-02-03 16:04:18',3),(26,'memberEdit','2022-02-03 16:04:18','Edit a Member','e413857f-a3f9-4572-ba23-d53491782121','memberEdit','2022-02-03 16:04:18',3),(27,'systemVariableDelete','2022-02-03 16:04:18','Delete System Variable','7cd6e766-d1d7-485a-8c69-29fa36a6a425','systemVariableDelete','2022-02-03 16:04:18',3),(28,'publisherList','2022-02-03 16:04:18','List publishers','09602190-1975-4cce-b64c-b1ffe73712bb','publisherList','2022-02-03 16:04:18',3),(29,'uploaderDelete','2022-02-03 16:04:18','Remove a Member as	an uploader.','36376200-ea4f-439c-9cf1-01faf9f90094','uploaderDelete','2022-02-03 16:04:18',3),(30,'creditCardDelete','2022-02-03 16:04:18','Delete a Credit Card','691b6f19-8fb8-4fde-b2df-5281b2d603ca','creditCardDelete','2022-02-03 16:04:18',3),(31,'publisherEdit','2022-02-03 16:04:18','Edit a publisher','c0b60492-836e-406c-bbf3-67356b12f3c6','publisherEdit','2022-02-03 16:04:18',3),(32,'teamEdit','2022-02-03 16:04:18','Edit a Team','6c9d7956-57b2-4fe3-8442-5fb910e9dd88','teamEdit','2022-02-03 16:04:18',3),(33,'downloadHistoryList','2022-02-03 16:04:18','List a packages download history','98d1fc08-bd88-46b7-8a9d-c8e79fe8f72c','downloadHistoryList','2022-02-03 16:04:18',3),(34,'memberInviteCreate','2022-02-03 16:04:18','Create a member Invite','f9da803f-ae58-4d5c-a6ef-b354163f41a4','memberInviteCreate','2022-02-03 16:04:18',3),(35,'roleEdit','2022-02-03 16:04:18','Edit Roles','141e495a-536b-4477-a204-eccdd3ac946d','roleEdit','2022-02-03 16:04:18',3),(36,'packageList','2022-02-03 16:04:18','List Packages','197f9e8d-11ab-4558-a4b9-b667e95eb8ee','packageList','2022-02-03 16:04:18',3),(37,'teamMembership','2022-02-03 16:04:18','Modify the	list of	members associated with a team','2fb9009b-2584-4b07-a57f-4504413b16dc','teamMembership','2022-02-03 16:04:18',3),(38,'memberDelete','2022-02-03 16:04:18','Delete a Member','e9e15391-3f48-46f6-bfd4-4a846a60fbab','memberDelete','2022-02-03 16:04:18',3),(39,'teamList','2022-02-03 16:04:18','List a Team','b713a285-8a11-4c5c-b87f-6c9bb7b40c11','teamList','2022-02-03 16:04:18',3),(40,'memberList','2022-02-03 16:04:18','List members','27f8d8f7-bce4-4ee5-b9ba-3491e3f92aaa','memberList','2022-02-03 16:04:18',3),(41,'memberInviteDelete','2022-02-03 16:04:18','Delete a member Invite','997a2efd-68d1-47ef-aee4-e7db6e6dff18','memberInviteDelete','2022-02-03 16:04:18',3),(42,'roleList','2022-02-03 16:04:18','List Roles','bd948313-0263-4b21-a363-9de3854f7928','roleList','2022-02-03 16:04:18',3),(43,'creditCardCreate','2022-02-03 16:04:18','Create a Credit Card','702cdfdc-3079-4fd4-b786-87b02d7b0947','creditCardCreate','2022-02-03 16:04:18',1),(44,'publisherList','2022-02-03 16:04:18','List publishers','55e9076d-c7ed-4a06-aceb-17a1331d1d2f','publisherList','2022-02-03 16:04:18',1),(45,'creditCardEdit','2022-02-03 16:04:18','Edit a Credit Card','48eb1e53-7dd8-44a8-aa21-df382db8c278','creditCardEdit','2022-02-03 16:04:18',1),(46,'memberInviteDelete','2022-02-03 16:04:18','Delete a member Invite','a5fa08ec-24a7-4d6a-892c-9facfb7a69d6','memberInviteDelete','2022-02-03 16:04:18',1),(47,'teamList','2022-02-03 16:04:18','List a Team','4bfc7404-e508-4a69-be3e-d42ccb75d4ad','teamList','2022-02-03 16:04:18',1),(48,'packageSearch','2022-02-03 16:04:18','Search Packages','b225c7cb-b8be-4c6a-9593-25dd408c743c','packageSearch','2022-02-03 16:04:18',1),(49,'uploaderAdd','2022-02-03 16:04:18','Ability to designate a Member as	an uploader','86f0c8ac-fb5d-4efd-bd27-5d4c5703c1db','uploaderAdd','2022-02-03 16:04:18',1),(50,'packageUploadVersion','2022-02-03 16:04:18','Upload a new version package','6658b1a3-32d1-430a-8a3d-7984ec16e007','packageUploadVersion','2022-02-03 16:04:18',1),(51,'teamEdit','2022-02-03 16:04:18','Edit a Team','ca595471-a556-4bae-b012-97beabec3c6d','teamEdit','2022-02-03 16:04:18',1),(52,'teamAddMultipleLeaders','2022-02-03 16:04:18','This is a licensing constraint controlling whether a	Team can have more than one	Team Leader','e4a89ee5-fe78-4826-b5d5-56657ceeab14','teamAddMultipleLeaders','2022-02-03 16:04:18',1),(53,'publisherEdit','2022-02-03 16:04:18','Edit a publisher','55e1001b-1aba-486b-a64f-03bfcbacee91','publisherEdit','2022-02-03 16:04:18',1),(54,'packageEdit','2022-02-03 16:04:18','Edit Package','b8c706f3-b9b4-4e01-93f4-493f1c4f6b6c','packageEdit','2022-02-03 16:04:18',1),(55,'memberEdit','2022-02-03 16:04:18','Edit a Member','2b5d4e6f-4e1d-46ef-9c2d-582b0ce74c3e','memberEdit','2022-02-03 16:04:18',1),(56,'packageCreate','2022-02-03 16:04:18','Create Package','5fa0d0bb-d7f7-4176-8c9b-1cff9fc6afd9','packageCreate','2022-02-03 16:04:18',1),(57,'uploaderList','2022-02-03 16:04:18','List the Members that	are uploaders','68820ed0-2b33-4bab-8778-5ee786b06607','uploaderList','2022-02-03 16:04:18',1),(58,'teamDelete','2022-02-03 16:04:18','Delete a Team','1bb08c05-6831-4a32-94f2-cc0d21d87e02','teamDelete','2022-02-03 16:04:18',1),(59,'memberInviteCreate','2022-02-03 16:04:18','Create a member Invite','7087d830-0807-4172-83cf-1d24c8aa24d7','memberInviteCreate','2022-02-03 16:04:18',1),(60,'packageList','2022-02-03 16:04:18','List Packages','f7e7277f-652a-4e0b-9954-f4d5e57db8dd','packageList','2022-02-03 16:04:18',1),(61,'uploaderDelete','2022-02-03 16:04:18','Remove a Member as	an uploader.','6ed26895-a3a5-4a39-a5ce-2f4c8b9633ec','uploaderDelete','2022-02-03 16:04:18',1),(62,'teamMembership','2022-02-03 16:04:18','Modify the	list of	members associated with a team','c3d4f1b5-1e19-4a26-a2e6-a4513b6836c9','teamMembership','2022-02-03 16:04:18',1),(63,'creditCardList','2022-02-03 16:04:18','List Credit Cards','ae76749c-722f-4b7b-aa0a-88dd9f107d7e','creditCardList','2022-02-03 16:04:18',1),(64,'memberInviteEdit','2022-02-03 16:04:18','Edit a member Invite','adc3480c-4cdb-41fe-8e8e-6fbcc5d62c5e','memberInviteEdit','2022-02-03 16:04:18',1),(65,'teamCreate','2022-02-03 16:04:18','Create a Team','ed800dcd-f5ad-4726-9e9b-5cccf39023b7','teamCreate','2022-02-03 16:04:18',1),(66,'packageDelete','2022-02-03 16:04:18','Delete a Package','07036e2b-ecc4-4cf2-acd2-9e1ec66e004b','packageDelete','2022-02-03 16:04:18',1),(67,'memberInviteSend','2022-02-03 16:04:18','Send a member Invite','eeda8af9-d45a-454d-b4fc-7c4b23f7535d','memberInviteSend','2022-02-03 16:04:18',1),(68,'publisherDelete','2022-02-03 16:04:18','Delete a publisher','7ca2b89a-dc0d-467d-a7dc-52b12269cbb2','publisherDelete','2022-02-03 16:04:18',1),(69,'publisherCreate','2022-02-03 16:04:18','Create a Publisher','b673c40f-6052-4514-8bab-e1dbab4fda42','publisherCreate','2022-02-03 16:04:18',1),(70,'billingHistoryList','2022-02-03 16:04:18','List the billing history','9125ca6b-dd48-4379-8526-e3c9adb11bc8','billingHistoryList','2022-02-03 16:04:18',1),(71,'packageSearch','2022-02-03 16:04:18','Search Packages','68d7e9da-b883-4a8b-84e2-e8f47737441f','packageSearch','2022-02-03 16:04:18',5),(72,'packageUploadVersion','2022-02-03 16:04:18','Upload a new version package','f26ba095-dbcc-449f-a1e8-90f190bff3a0','packageUploadVersion','2022-02-03 16:04:18',5),(73,'packageDelete','2022-02-03 16:04:18','Delete a Package','3edae249-4e39-4edd-b86a-5abb88409cdb','packageDelete','2022-02-03 16:04:18',5),(74,'packageEdit','2022-02-03 16:04:18','Edit Package','4627d50d-564d-42da-907f-85b8057c8510','packageEdit','2022-02-03 16:04:18',5),(75,'packageList','2022-02-03 16:04:18','List Packages','a11db773-a11a-4316-a763-e2cf868ee054','packageList','2022-02-03 16:04:18',5),(76,'downloadHistoryList','2022-02-03 16:04:18','List a packages download history','eac8b02a-bd4b-49a7-aee2-f01ec2e6b49b','downloadHistoryList','2022-02-03 16:04:18',5),(77,'packageCreate','2022-02-03 16:04:18','Create Package','c81f8968-90d2-43c6-96b4-2af0bbbd2552','packageCreate','2022-02-03 16:04:18',5),(78,'packageSearch','2022-02-03 16:04:18','Search Packages','ca61288e-d9de-45f9-b9e8-98e081b32bb0','packageSearch','2022-02-03 16:04:18',4),(79,'memberCreate','2022-02-03 16:04:18','Create a Member','bdc360f1-dd28-4feb-b596-3197056db732','memberCreate','2022-02-03 16:04:18',4),(80,'downloadHistoryList','2022-02-03 16:04:18','List a packages download history','1c9744db-472f-411b-9a33-380553ca33be','downloadHistoryList','2022-02-03 16:04:18',4),(81,'packageEdit','2022-02-03 16:04:18','Edit Package','d4ce0dd8-8087-443c-90a9-5ba6909cf263','packageEdit','2022-02-03 16:04:18',4),(82,'packageUploadVersion','2022-02-03 16:04:18','Upload a new version package','25088424-8b08-4b45-b2b8-3803bda55906','packageUploadVersion','2022-02-03 16:04:18',4),(83,'memberInviteEdit','2022-02-03 16:04:18','Edit a member Invite','07d4f33f-d416-4399-b242-7c0308fe6c5e','memberInviteEdit','2022-02-03 16:04:18',4),(84,'teamEdit','2022-02-03 16:04:18','Edit a Team','f8ec6032-e4fd-45f8-8189-524ef7cb0e63','teamEdit','2022-02-03 16:04:18',4),(85,'memberDelete','2022-02-03 16:04:18','Delete a Member','dd508f61-ba79-48ab-8a19-4ed4a550dfae','memberDelete','2022-02-03 16:04:18',4),(86,'teamMembership','2022-02-03 16:04:18','Modify the	list of	members associated with a team','57eb0caf-a8ee-4cd2-bf46-2c9e33675f84','teamMembership','2022-02-03 16:04:18',4),(87,'memberList','2022-02-03 16:04:18','List members','90c827d0-a36c-4639-a69c-9220bd8d5bc4','memberList','2022-02-03 16:04:18',4),(88,'packageList','2022-02-03 16:04:18','List Packages','40db5547-2262-4641-86a2-47ceb61e8425','packageList','2022-02-03 16:04:18',4),(89,'memberEdit','2022-02-03 16:04:18','Edit a Member','940ec59f-bf79-4856-808f-59240c396f39','memberEdit','2022-02-03 16:04:18',4),(90,'teamDelete','2022-02-03 16:04:18','Delete a Team','54bbd16a-728c-4cd5-ae1e-e359165134b1','teamDelete','2022-02-03 16:04:18',4),(91,'memberInviteSend','2022-02-03 16:04:18','Send a member Invite','123c14d9-d289-4776-b4a0-9d65d7c90940','memberInviteSend','2022-02-03 16:04:18',4),(92,'memberInviteCreate','2022-02-03 16:04:18','Create a member Invite','0f0dde91-9143-4fa7-8876-6b8444b67de4','memberInviteCreate','2022-02-03 16:04:18',4),(93,'memberInviteList','2022-02-03 16:04:18','List member Invites','89ec79c3-2ec8-44f0-8053-a4783f507c8e','memberInviteList','2022-02-03 16:04:18',4),(94,'teamAddMultipleLeaders','2022-02-03 16:04:18','This is a licensing constraint controlling whether a	Team can have more than one	Team Leader','c30d309d-4a2a-4fa9-ba69-bd7d06f3ca7e','teamAddMultipleLeaders','2022-02-03 16:04:18',4),(95,'teamList','2022-02-03 16:04:18','List a Team','087f6273-158c-4b4a-9322-fd7b0e23998b','teamList','2022-02-03 16:04:18',4),(96,'packageDelete','2022-02-03 16:04:18','Delete a Package','3bb93760-e2f3-47dd-b1c6-15f77176ff88','packageDelete','2022-02-03 16:04:18',4),(97,'memberInviteDelete','2022-02-03 16:04:18','Delete a member Invite','fffee408-8829-49ba-9a65-22f6e364c9f4','memberInviteDelete','2022-02-03 16:04:18',4),(98,'packageCreate','2022-02-03 16:04:18','Create Package','1796ad08-1341-4348-b31a-eefd410a8cc2','packageCreate','2022-02-03 16:04:18',4),(99,'packageSearch','2022-02-03 16:04:18','Search Packages','b90b2f6d-a384-4a4a-bb43-75890694e8f5','packageSearch','2022-02-03 16:04:18',2),(100,'memberInviteList','2022-02-03 16:04:18','List member Invites','0b685264-9644-48e2-b492-41a7ab0f73b8','memberInviteList','2022-02-03 16:04:18',2),(101,'memberInviteAccept','2022-02-03 16:04:18','Accept an Invite','25ea1334-01d8-433d-bb73-16c5df77fa98','memberInviteAccept','2022-02-03 16:04:18',2),(102,'downloadHistoryList','2022-02-03 16:04:18','List a packages download history','cf45aebd-91b7-4349-9069-eab203efb923','downloadHistoryList','2022-02-03 16:04:18',2);
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliLog`
--

DROP TABLE IF EXISTS `cliLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliLog` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACTION` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DETAIL` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `MEMBER_ID` bigint(20) NOT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_cliLog_GUID` (`GUID`),
  KEY `idx_cliLog_member_action` (`PUBLISHER_ID`,`MEMBER_ID`,`ACTION`,`CREATEDAT`),
  KEY `FK_cliLog_MEMBER_ID` (`MEMBER_ID`),
  CONSTRAINT `FK_cliLog_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_cliLog_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliLog`
--

LOCK TABLES `cliLog` WRITE;
/*!40000 ALTER TABLE `cliLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `COUNTRYCODE` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`),
  UNIQUE KEY `INDEX_country_GUID` (`GUID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'61','2022-02-03 16:04:17','1a2691dc-19b4-4649-b013-b78c89f86da5','Australia','2022-02-03 16:04:17');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditCardHolder`
--

DROP TABLE IF EXISTS `creditCardHolder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creditCardHolder` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CCTOKEN` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DATEENTERED` date DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `EXPIRYDATE` date DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `LAST4DIGITS` varchar(255) DEFAULT NULL,
  `LASTBILLED` datetime DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `ADDEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `ISSUER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_creditCardHolder_GUID` (`GUID`),
  KEY `FK_creditCardHolder_ADDEDBYMEMBER_ID` (`ADDEDBYMEMBER_ID`),
  KEY `FK_creditCardHolder_ISSUER_ID` (`ISSUER_ID`),
  KEY `FK_creditCardHolder_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_creditCardHolder_ADDEDBYMEMBER_ID` FOREIGN KEY (`ADDEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_creditCardHolder_ISSUER_ID` FOREIGN KEY (`ISSUER_ID`) REFERENCES `creditCardIssuer` (`ID`),
  CONSTRAINT `FK_creditCardHolder_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditCardHolder`
--

LOCK TABLES `creditCardHolder` WRITE;
/*!40000 ALTER TABLE `creditCardHolder` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditCardHolder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditCardIssuer`
--

DROP TABLE IF EXISTS `creditCardIssuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creditCardIssuer` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `MERCHANTFEERATE` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`),
  UNIQUE KEY `INDEX_creditCardIssuer_GUID` (`GUID`),
  KEY `FK_creditCardIssuer_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_creditCardIssuer_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditCardIssuer`
--

LOCK TABLES `creditCardIssuer` WRITE;
/*!40000 ALTER TABLE `creditCardIssuer` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditCardIssuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dartPackage`
--

DROP TABLE IF EXISTS `dartPackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dartPackage` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DEACTIVATED` tinyint(1) DEFAULT 0,
  `DEACTIVATIONDATE` date DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `INTERNAL` tinyint(1) DEFAULT 0,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CREATORMEMBER_ID` bigint(20) DEFAULT NULL,
  `DEACTIVATEDBY_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_dartPackage_GUID` (`GUID`),
  KEY `FK_dartPackage_DEACTIVATEDBY_ID` (`DEACTIVATEDBY_ID`),
  KEY `FK_dartPackage_CREATORMEMBER_ID` (`CREATORMEMBER_ID`),
  KEY `FK_dartPackage_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_dartPackage_CREATORMEMBER_ID` FOREIGN KEY (`CREATORMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_dartPackage_DEACTIVATEDBY_ID` FOREIGN KEY (`DEACTIVATEDBY_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_dartPackage_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dartPackage`
--

LOCK TABLES `dartPackage` WRITE;
/*!40000 ALTER TABLE `dartPackage` DISABLE KEYS */;
/*!40000 ALTER TABLE `dartPackage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dartPackage_member`
--

DROP TABLE IF EXISTS `dartPackage_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dartPackage_member` (
  `DartPackage_ID` bigint(20) NOT NULL,
  `packageOwners_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DartPackage_ID`,`packageOwners_ID`),
  KEY `FK_dartPackage_member_packageOwners_ID` (`packageOwners_ID`),
  CONSTRAINT `FK_dartPackage_member_DartPackage_ID` FOREIGN KEY (`DartPackage_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_dartPackage_member_packageOwners_ID` FOREIGN KEY (`packageOwners_ID`) REFERENCES `member` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dartPackage_member`
--

LOCK TABLES `dartPackage_member` WRITE;
/*!40000 ALTER TABLE `dartPackage_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `dartPackage_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dartPackage_team`
--

DROP TABLE IF EXISTS `dartPackage_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dartPackage_team` (
  `DartPackage_ID` bigint(20) NOT NULL,
  `teamAssociations_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DartPackage_ID`,`teamAssociations_ID`),
  KEY `FK_dartPackage_team_teamAssociations_ID` (`teamAssociations_ID`),
  CONSTRAINT `FK_dartPackage_team_DartPackage_ID` FOREIGN KEY (`DartPackage_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_dartPackage_team_teamAssociations_ID` FOREIGN KEY (`teamAssociations_ID`) REFERENCES `team` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dartPackage_team`
--

LOCK TABLES `dartPackage_team` WRITE;
/*!40000 ALTER TABLE `dartPackage_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `dartPackage_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dartPackage_version`
--

DROP TABLE IF EXISTS `dartPackage_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dartPackage_version` (
  `DartPackage_ID` bigint(20) NOT NULL,
  `versions_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`DartPackage_ID`,`versions_ID`),
  KEY `FK_dartPackage_version_versions_ID` (`versions_ID`),
  CONSTRAINT `FK_dartPackage_version_DartPackage_ID` FOREIGN KEY (`DartPackage_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_dartPackage_version_versions_ID` FOREIGN KEY (`versions_ID`) REFERENCES `version` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dartPackage_version`
--

LOCK TABLES `dartPackage_version` WRITE;
/*!40000 ALTER TABLE `dartPackage_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `dartPackage_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadHistory`
--

DROP TABLE IF EXISTS `downloadHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadHistory` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DOWNLOADEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  `VERSION_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_downloadHistory_GUID` (`GUID`),
  KEY `FK_downloadHistory_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_downloadHistory_VERSION_ID` (`VERSION_ID`),
  KEY `FK_downloadHistory_MEMBER_ID` (`MEMBER_ID`),
  CONSTRAINT `FK_downloadHistory_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_downloadHistory_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`),
  CONSTRAINT `FK_downloadHistory_VERSION_ID` FOREIGN KEY (`VERSION_ID`) REFERENCES `version` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadHistory`
--

LOCK TABLES `downloadHistory` WRITE;
/*!40000 ALTER TABLE `downloadHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailVerification`
--

DROP TABLE IF EXISTS `emailVerification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailVerification` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATED` datetime DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DEVICE` varchar(255) DEFAULT NULL,
  `EMAILADDRESS` varchar(255) DEFAULT NULL,
  `EMAILGUID` varchar(255) DEFAULT NULL,
  `EXPIRES` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `INVITATIONGUID` varchar(255) DEFAULT NULL,
  `IPADDRESS` varchar(255) DEFAULT NULL,
  `LOCATION` varchar(255) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `VERIFIED` tinyint(1) DEFAULT 0,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_emailVerification_GUID` (`GUID`),
  KEY `FK_emailVerification_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_emailVerification_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailVerification`
--

LOCK TABLES `emailVerification` WRITE;
/*!40000 ALTER TABLE `emailVerification` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailVerification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `limitOption`
--

DROP TABLE IF EXISTS `limitOption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `limitOption` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `COST` bigint(20) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `QUANTITY` int(11) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_limitOption_GUID` (`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `limitOption`
--

LOCK TABLES `limitOption` WRITE;
/*!40000 ALTER TABLE `limitOption` DISABLE KEYS */;
/*!40000 ALTER TABLE `limitOption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACTION` varchar(255) DEFAULT NULL,
  `COMMENT` varchar(2048) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `LOGTIME` datetime DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_log_GUID` (`GUID`),
  KEY `FK_log_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_log_MEMBER_ID` (`MEMBER_ID`),
  CONSTRAINT `FK_log_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_log_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACCEPTEDTERMS` tinyint(1) DEFAULT 0,
  `CREATEDAT` datetime DEFAULT NULL,
  `DATEDELETED` datetime DEFAULT NULL,
  `DELETED` tinyint(1) DEFAULT 0,
  `EMAIL` varchar(255) DEFAULT NULL,
  `ENABLED` tinyint(1) DEFAULT 0,
  `FAILEDLOGINCOUNT` int(11) DEFAULT NULL,
  `FIRSTNAME` varchar(255) DEFAULT NULL,
  `FORGOTTENPASSWORDSECURITYTOKEN` varchar(255) DEFAULT NULL,
  `FORGOTTENPASSWORDTOKENEXPIRYDATE` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `LASTAPIACTION` datetime DEFAULT NULL,
  `OAUTHEXPIRYDATE` datetime DEFAULT NULL,
  `OAUTHTOKEN` varchar(2048) DEFAULT NULL,
  `ONEPUBTOKEN` varchar(64) DEFAULT NULL,
  `PASSWORD` varchar(255) DEFAULT NULL,
  `STARTDATE` date DEFAULT NULL,
  `SURNAME` varchar(255) DEFAULT NULL,
  `TERMSANDCONDITIONSURL` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `DELETEDBY_ID` bigint(20) DEFAULT NULL,
  `INVITE_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`),
  UNIQUE KEY `ONEPUBTOKEN` (`ONEPUBTOKEN`),
  UNIQUE KEY `INDEX_member_GUID` (`GUID`),
  KEY `FK_member_DELETEDBY_ID` (`DELETEDBY_ID`),
  KEY `FK_member_INVITE_ID` (`INVITE_ID`),
  KEY `FK_member_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_member_DELETEDBY_ID` FOREIGN KEY (`DELETEDBY_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_member_INVITE_ID` FOREIGN KEY (`INVITE_ID`) REFERENCES `memberInvite` (`ID`),
  CONSTRAINT `FK_member_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,0,'2022-02-03 16:05:33',NULL,0,'bsutton@noojee.com.au',1,0,'Brett',NULL,NULL,'706855a3-ba87-471e-8ed9-578b33a90797',NULL,NULL,NULL,NULL,NULL,'2022-02-03','Sutton',NULL,'2022-02-03 16:05:33',NULL,NULL,2);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `memberInvite`
--

DROP TABLE IF EXISTS `memberInvite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memberInvite` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACCEPTED` tinyint(1) DEFAULT 0,
  `CANCELLED` tinyint(1) DEFAULT 0,
  `CREATEDAT` datetime DEFAULT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  `EXPIRESDATE` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `INVITEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_memberInvite_GUID` (`GUID`),
  KEY `FK_memberInvite_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_memberInvite_INVITEDBYMEMBER_ID` (`INVITEDBYMEMBER_ID`),
  CONSTRAINT `FK_memberInvite_INVITEDBYMEMBER_ID` FOREIGN KEY (`INVITEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_memberInvite_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memberInvite`
--

LOCK TABLES `memberInvite` WRITE;
/*!40000 ALTER TABLE `memberInvite` DISABLE KEYS */;
/*!40000 ALTER TABLE `memberInvite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `memberRole`
--

DROP TABLE IF EXISTS `memberRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memberRole` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CREATEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  `ROLE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_memberRole_GUID` (`GUID`),
  KEY `FK_memberRole_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_memberRole_MEMBER_ID` (`MEMBER_ID`),
  KEY `FK_memberRole_CREATEDBYMEMBER_ID` (`CREATEDBYMEMBER_ID`),
  KEY `FK_memberRole_ROLE_ID` (`ROLE_ID`),
  CONSTRAINT `FK_memberRole_CREATEDBYMEMBER_ID` FOREIGN KEY (`CREATEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_memberRole_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_memberRole_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`),
  CONSTRAINT `FK_memberRole_ROLE_ID` FOREIGN KEY (`ROLE_ID`) REFERENCES `role` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memberRole`
--

LOCK TABLES `memberRole` WRITE;
/*!40000 ALTER TABLE `memberRole` DISABLE KEYS */;
INSERT INTO `memberRole` VALUES (1,'2022-02-03 16:05:33','baf3c738-ef4d-4255-85b8-b6201cffc8a6','2022-02-03 16:05:33',NULL,1,2,3),(2,'2022-02-03 16:05:33','5deb4b5c-3f73-4400-8e11-b43adc64ce79','2022-02-03 16:05:33',NULL,1,2,4),(3,'2022-02-03 16:05:33','61e9abec-cc63-4825-a08b-cbc322ae0890','2022-02-03 16:05:33',NULL,1,2,2),(4,'2022-02-03 16:05:33','8e90ee11-aed2-49b1-9c04-d9d0a6308a34','2022-02-03 16:05:33',NULL,1,2,1),(5,'2022-02-03 16:05:33','d89ab0f7-fe8b-4a89-b678-f6c88878e5e7','2022-02-03 16:05:33',NULL,1,2,5);
/*!40000 ALTER TABLE `memberRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_team`
--

DROP TABLE IF EXISTS `member_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_team` (
  `leaders_ID` bigint(20) NOT NULL,
  `leadership_ID` bigint(20) NOT NULL,
  `members_ID` bigint(20) NOT NULL,
  `membership_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`leaders_ID`,`leadership_ID`,`members_ID`,`membership_ID`),
  KEY `FK_member_team_leadership_ID` (`leadership_ID`),
  KEY `FK_member_team_members_ID` (`members_ID`),
  KEY `FK_member_team_membership_ID` (`membership_ID`),
  CONSTRAINT `FK_member_team_leaders_ID` FOREIGN KEY (`leaders_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_member_team_leadership_ID` FOREIGN KEY (`leadership_ID`) REFERENCES `team` (`ID`),
  CONSTRAINT `FK_member_team_members_ID` FOREIGN KEY (`members_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_member_team_membership_ID` FOREIGN KEY (`membership_ID`) REFERENCES `team` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_team`
--

LOCK TABLES `member_team` WRITE;
/*!40000 ALTER TABLE `member_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packageOwner`
--

DROP TABLE IF EXISTS `packageOwner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packageOwner` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `DARTPACKAGE_ID` bigint(20) DEFAULT NULL,
  `OWNERMEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_packageOwner_GUID` (`GUID`),
  KEY `FK_packageOwner_DARTPACKAGE_ID` (`DARTPACKAGE_ID`),
  KEY `FK_packageOwner_OWNERMEMBER_ID` (`OWNERMEMBER_ID`),
  KEY `FK_packageOwner_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_packageOwner_DARTPACKAGE_ID` FOREIGN KEY (`DARTPACKAGE_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_packageOwner_OWNERMEMBER_ID` FOREIGN KEY (`OWNERMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_packageOwner_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packageOwner`
--

LOCK TABLES `packageOwner` WRITE;
/*!40000 ALTER TABLE `packageOwner` DISABLE KEYS */;
/*!40000 ALTER TABLE `packageOwner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packageTeam`
--

DROP TABLE IF EXISTS `packageTeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packageTeam` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `DARTPACKAGE_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  `TEAM_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_packageTeam_GUID` (`GUID`),
  KEY `FK_packageTeam_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_packageTeam_DARTPACKAGE_ID` (`DARTPACKAGE_ID`),
  KEY `FK_packageTeam_TEAM_ID` (`TEAM_ID`),
  CONSTRAINT `FK_packageTeam_DARTPACKAGE_ID` FOREIGN KEY (`DARTPACKAGE_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_packageTeam_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`),
  CONSTRAINT `FK_packageTeam_TEAM_ID` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packageTeam`
--

LOCK TABLES `packageTeam` WRITE;
/*!40000 ALTER TABLE `packageTeam` DISABLE KEYS */;
/*!40000 ALTER TABLE `packageTeam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymentHistory`
--

DROP TABLE IF EXISTS `paymentHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paymentHistory` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `BILLINGCYCLE` int(11) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `ERROR` varchar(255) DEFAULT NULL,
  `ERRORCODE` varchar(255) DEFAULT NULL,
  `GSTPAID` bigint(20) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `MERCHANTFEE` bigint(20) DEFAULT NULL,
  `MERCHANTRATE` varchar(255) DEFAULT NULL,
  `PAYMENTDATETIME` datetime DEFAULT NULL,
  `PAYMENTOPTIONS` longblob DEFAULT NULL,
  `SOURCE` varchar(255) DEFAULT NULL,
  `SUBSCRIPTIONFEE` bigint(20) DEFAULT NULL,
  `SUCCESSFUL` tinyint(1) DEFAULT 0,
  `TIP` bigint(20) DEFAULT NULL,
  `TOTALPAID` bigint(20) DEFAULT NULL,
  `TRANSACTIONID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CARDUSED_ID` bigint(20) DEFAULT NULL,
  `PRICINGTIER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_paymentHistory_GUID` (`GUID`),
  KEY `FK_paymentHistory_PRICINGTIER_ID` (`PRICINGTIER_ID`),
  KEY `FK_paymentHistory_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_paymentHistory_CARDUSED_ID` (`CARDUSED_ID`),
  CONSTRAINT `FK_paymentHistory_CARDUSED_ID` FOREIGN KEY (`CARDUSED_ID`) REFERENCES `creditCardHolder` (`ID`),
  CONSTRAINT `FK_paymentHistory_PRICINGTIER_ID` FOREIGN KEY (`PRICINGTIER_ID`) REFERENCES `pricingTier` (`ID`),
  CONSTRAINT `FK_paymentHistory_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentHistory`
--

LOCK TABLES `paymentHistory` WRITE;
/*!40000 ALTER TABLE `paymentHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `paymentHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricingTier`
--

DROP TABLE IF EXISTS `pricingTier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricingTier` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ANNUALCHARGE` bigint(20) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `ENDDATE` date DEFAULT NULL,
  `EXCESSDOWNLOADPRICEGB` bigint(20) DEFAULT NULL,
  `EXCESSSTORAGEPRICEGB` bigint(20) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `MAXDOWNLOADSGB` int(11) DEFAULT NULL,
  `MAXMEMBERS` int(11) DEFAULT NULL,
  `MAXPACKAGESIZEMB` int(11) DEFAULT NULL,
  `MAXPACKAGES` int(11) DEFAULT NULL,
  `MAXSTORAGEGB` int(11) DEFAULT NULL,
  `MONTHLYCHARGE` bigint(20) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `STARTDATE` date DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `VISIBLE` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_pricingTier_GUID` (`GUID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTier`
--

LOCK TABLES `pricingTier` WRITE;
/*!40000 ALTER TABLE `pricingTier` DISABLE KEYS */;
INSERT INTO `pricingTier` VALUES (1,0,'2022-02-03 16:04:17',NULL,0,0,'646d1f6e-7375-452f-9fea-5362e9318b22',999999999,999999999,999999999,999999999,999999999,0,'system','2022-02-03','2022-02-03 16:04:17',0),(2,36000,'2022-02-03 16:04:17',NULL,100,100,'6c3b5414-f2d0-457e-8b37-8321e7a14b98',100,10000,20,20,5,3000,'enterprise','2022-02-03','2022-02-03 16:04:17',1),(3,12000,'2022-02-03 16:04:17',NULL,100,100,'a805663c-a425-4689-9ef3-495ee77ef743',5,10,1,5,5,1000,'pro','2022-02-03','2022-02-03 16:04:17',1),(4,24000,'2022-02-03 16:04:17',NULL,100,100,'52fdd6b5-1269-45b2-bbc5-9ce1f238b668',20,15,2,5,20,2000,'team','2022-02-03','2022-02-03 16:04:17',1);
/*!40000 ALTER TABLE `pricingTier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricingTierAction`
--

DROP TABLE IF EXISTS `pricingTierAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricingTierAction` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACTION` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `PRICINGTIER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_pricingTierAction_GUID` (`GUID`),
  KEY `FK_pricingTierAction_PRICINGTIER_ID` (`PRICINGTIER_ID`),
  CONSTRAINT `FK_pricingTierAction_PRICINGTIER_ID` FOREIGN KEY (`PRICINGTIER_ID`) REFERENCES `pricingTier` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=153 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTierAction`
--

LOCK TABLES `pricingTierAction` WRITE;
/*!40000 ALTER TABLE `pricingTierAction` DISABLE KEYS */;
INSERT INTO `pricingTierAction` VALUES (1,'notRequired','2022-02-03 16:04:17','1b3fbff8-3611-472f-b49f-ad6827b6030c','2022-02-03 16:04:17',3),(2,'notRequired','2022-02-03 16:04:17','2f52d6cf-430a-451a-b778-bef99604b861','2022-02-03 16:04:17',4),(3,'notRequired','2022-02-03 16:04:17','9d3c8cc8-3cda-49c3-aa17-576b0d94be35','2022-02-03 16:04:17',1),(4,'notRequired','2022-02-03 16:04:17','df774d86-b6fa-42ee-ae39-97835b96f3d3','2022-02-03 16:04:17',2),(5,'billingHistoryList','2022-02-03 16:04:17','beca3df5-4825-44eb-90b3-5d25adcb6d79','2022-02-03 16:04:17',3),(6,'billingHistoryList','2022-02-03 16:04:17','6544ff79-d4ee-489e-9a02-e060b7816bcf','2022-02-03 16:04:17',4),(7,'billingHistoryList','2022-02-03 16:04:17','fec2f4ba-ec12-441f-b30e-b523c8c1aaba','2022-02-03 16:04:17',1),(8,'billingHistoryList','2022-02-03 16:04:17','26603f31-33f8-4735-a766-a8585a4a59ae','2022-02-03 16:04:17',2),(9,'creditCardList','2022-02-03 16:04:17','e98f38ef-7262-4d05-a7d0-0b45ad525489','2022-02-03 16:04:17',3),(10,'creditCardList','2022-02-03 16:04:17','7d3a66f8-8dc7-4666-b17a-35864e9b632e','2022-02-03 16:04:17',4),(11,'creditCardList','2022-02-03 16:04:17','3f70e745-4c4a-4582-b62a-2159ea022b00','2022-02-03 16:04:17',1),(12,'creditCardList','2022-02-03 16:04:17','3bf70f58-5370-4c78-a644-9bd4df62e286','2022-02-03 16:04:17',2),(13,'creditCardCreate','2022-02-03 16:04:17','0a172bc0-6864-4ecd-9480-8007d54bbc35','2022-02-03 16:04:17',3),(14,'creditCardCreate','2022-02-03 16:04:17','16ce5e48-bc45-420e-9414-2beb62524c53','2022-02-03 16:04:17',4),(15,'creditCardCreate','2022-02-03 16:04:17','94b6fd78-6365-4647-8cad-cc2a5f33e75d','2022-02-03 16:04:17',1),(16,'creditCardCreate','2022-02-03 16:04:17','32fc935b-3681-4c09-b034-ea7172d93aa3','2022-02-03 16:04:17',2),(17,'creditCardEdit','2022-02-03 16:04:17','a17a901d-8163-4e4c-a209-2d003578f4c9','2022-02-03 16:04:17',3),(18,'creditCardEdit','2022-02-03 16:04:17','30a5fc25-c5d7-4220-9104-c2f859653bf9','2022-02-03 16:04:17',4),(19,'creditCardEdit','2022-02-03 16:04:17','19945692-dc2d-4ebf-9516-845ff4c9ee2a','2022-02-03 16:04:17',1),(20,'creditCardEdit','2022-02-03 16:04:17','f09bad7b-fc75-4b16-aaad-b72b00a2aea8','2022-02-03 16:04:17',2),(21,'creditCardDelete','2022-02-03 16:04:17','9ec40fbc-8364-4367-8a65-039c44197e41','2022-02-03 16:04:17',3),(22,'creditCardDelete','2022-02-03 16:04:17','e16f38f0-5fd6-4b6e-b53b-f219f603a8d7','2022-02-03 16:04:17',4),(23,'creditCardDelete','2022-02-03 16:04:17','4edd89cd-c946-4de6-9f12-d4d68aa22b33','2022-02-03 16:04:17',1),(24,'creditCardDelete','2022-02-03 16:04:17','b07d38ba-9ebd-4648-8416-9b1b86e6a6c3','2022-02-03 16:04:17',2),(25,'creditCardBill','2022-02-03 16:04:17','5337ddac-10d8-4839-a482-2b9b0129c675','2022-02-03 16:04:17',3),(26,'creditCardBill','2022-02-03 16:04:17','a70a2b9a-bf5a-46df-8a2e-d054b6165872','2022-02-03 16:04:17',4),(27,'creditCardBill','2022-02-03 16:04:17','f8f0f276-4282-4564-9859-a6c01183001c','2022-02-03 16:04:17',1),(28,'creditCardBill','2022-02-03 16:04:17','751caaac-eb8b-4537-b0be-0128d9ecc89f','2022-02-03 16:04:17',2),(29,'countryList','2022-02-03 16:04:17','638e8eb8-022e-49ce-bd52-48a607d87d0e','2022-02-03 16:04:17',1),(30,'countryCreate','2022-02-03 16:04:17','88e60fa5-b8e6-41c8-8fcb-ba4abcac62bc','2022-02-03 16:04:17',1),(31,'countryEdit','2022-02-03 16:04:17','e28f6c4a-0412-4b47-aa6d-892970cbc04c','2022-02-03 16:04:17',1),(32,'countryDelete','2022-02-03 16:04:17','c4ecd899-5beb-472a-a590-bbe2c2076dda','2022-02-03 16:04:17',1),(33,'downloadHistoryList','2022-02-03 16:04:17','a151258b-8252-421d-b1dd-b78fc40757f7','2022-02-03 16:04:17',4),(34,'downloadHistoryList','2022-02-03 16:04:17','14acbdcf-b6d2-4749-8041-a6bf17d5e2e5','2022-02-03 16:04:17',1),(35,'downloadHistoryList','2022-02-03 16:04:17','445a1396-bb73-4e64-899d-c7ddb71f1507','2022-02-03 16:04:17',2),(36,'forgottenPasswordSend','2022-02-03 16:04:17','f710150b-d868-43ec-9b57-9b72c58f5c1a','2022-02-03 16:04:17',3),(37,'forgottenPasswordSend','2022-02-03 16:04:17','2d04012c-0d8a-4e00-9780-0e065cf67480','2022-02-03 16:04:17',4),(38,'forgottenPasswordSend','2022-02-03 16:04:17','1195690c-fe4f-4d99-b017-442bef6957c0','2022-02-03 16:04:17',1),(39,'forgottenPasswordSend','2022-02-03 16:04:17','2bec44f8-8691-4fe4-8fec-1e77c22b077f','2022-02-03 16:04:17',2),(40,'logList','2022-02-03 16:04:17','906bc222-839a-4513-92ee-9a0f2b09bcfb','2022-02-03 16:04:17',1),(41,'memberList','2022-02-03 16:04:17','89bdde84-ebaf-43b3-9291-82cf775b7b10','2022-02-03 16:04:17',3),(42,'memberList','2022-02-03 16:04:17','9fe457e9-aa77-4e6f-a370-b35482e93f0f','2022-02-03 16:04:17',4),(43,'memberList','2022-02-03 16:04:17','7d6ac632-3908-473f-92b3-3e2f499e8fb5','2022-02-03 16:04:17',1),(44,'memberList','2022-02-03 16:04:17','278ff503-ddeb-4639-a53d-f30a134e27e1','2022-02-03 16:04:17',2),(45,'memberCreate','2022-02-03 16:04:17','e8a52b0e-c350-4829-b9b9-881f00cc0bd8','2022-02-03 16:04:17',3),(46,'memberCreate','2022-02-03 16:04:17','8e1cdd6f-d775-418a-8d0c-c06e4f5f1d09','2022-02-03 16:04:17',4),(47,'memberCreate','2022-02-03 16:04:17','46ad8c3f-1af5-426d-960b-ccccbafc478c','2022-02-03 16:04:17',1),(48,'memberCreate','2022-02-03 16:04:17','d7ef3064-51e7-4846-b7fc-03e7a4819f8a','2022-02-03 16:04:17',2),(49,'memberEdit','2022-02-03 16:04:17','b1988747-9541-4a18-8da4-caaf850de6a5','2022-02-03 16:04:17',3),(50,'memberEdit','2022-02-03 16:04:17','ff82684a-beb2-48ae-9c6e-32f844d57fca','2022-02-03 16:04:17',4),(51,'memberEdit','2022-02-03 16:04:17','ed8aacac-6a22-428d-b8cf-43a0fb7bd6cd','2022-02-03 16:04:17',1),(52,'memberEdit','2022-02-03 16:04:17','43f5d34d-3f07-409a-944f-c47860c726bb','2022-02-03 16:04:17',2),(53,'memberDelete','2022-02-03 16:04:17','d574019d-e252-4cd8-af9f-0b99d6622d58','2022-02-03 16:04:17',3),(54,'memberDelete','2022-02-03 16:04:17','9006035e-4b56-49ab-b59e-23bd3e51cd1f','2022-02-03 16:04:17',4),(55,'memberDelete','2022-02-03 16:04:17','94a16a30-5df6-43f0-bb5a-6885fce55331','2022-02-03 16:04:17',1),(56,'memberDelete','2022-02-03 16:04:17','eec468f6-2d39-4d0b-8e1f-4d6bf99bbc36','2022-02-03 16:04:17',2),(57,'memberInviteList','2022-02-03 16:04:17','19899d5e-0521-421d-b48d-74e3cdac2b05','2022-02-03 16:04:17',3),(58,'memberInviteList','2022-02-03 16:04:17','81353af3-a1c8-4319-9ea7-0a165732306b','2022-02-03 16:04:17',4),(59,'memberInviteList','2022-02-03 16:04:17','f9e7fb3d-853d-4872-b897-ecc77cbbae3e','2022-02-03 16:04:17',1),(60,'memberInviteList','2022-02-03 16:04:17','3db8471f-c151-417c-a83d-f9dc3498fe93','2022-02-03 16:04:17',2),(61,'memberInviteCreate','2022-02-03 16:04:17','ec47f7b2-f97c-4add-b007-fdf87a7475b8','2022-02-03 16:04:17',3),(62,'memberInviteCreate','2022-02-03 16:04:17','5d685578-70d9-41d7-81db-59ad8bd3589b','2022-02-03 16:04:17',4),(63,'memberInviteCreate','2022-02-03 16:04:17','4d77ca68-339c-4d2c-9174-1dd154d37aa9','2022-02-03 16:04:17',1),(64,'memberInviteCreate','2022-02-03 16:04:17','09cdfef4-f335-452b-ba95-681f4f84d2b0','2022-02-03 16:04:17',2),(65,'memberInviteEdit','2022-02-03 16:04:17','08542859-3970-4c32-86b3-83b5e3c99421','2022-02-03 16:04:17',3),(66,'memberInviteEdit','2022-02-03 16:04:17','d1c31f3e-2a66-4e9c-ae02-2a2dace454c2','2022-02-03 16:04:17',4),(67,'memberInviteEdit','2022-02-03 16:04:17','3622f415-fd3f-469b-ad83-a6a449386bee','2022-02-03 16:04:17',1),(68,'memberInviteEdit','2022-02-03 16:04:17','950b9b1d-12f1-41c9-b0fe-d804181edbab','2022-02-03 16:04:17',2),(69,'memberInviteDelete','2022-02-03 16:04:17','d5eae677-4a98-4509-8019-a40c670eec50','2022-02-03 16:04:17',3),(70,'memberInviteDelete','2022-02-03 16:04:17','ee883e5e-051e-459b-9bc1-2084ed89fd58','2022-02-03 16:04:17',4),(71,'memberInviteDelete','2022-02-03 16:04:17','b8aaaef0-a004-41d0-9990-3872eaeb6605','2022-02-03 16:04:17',1),(72,'memberInviteDelete','2022-02-03 16:04:17','f3186ceb-3c6b-4fff-ac60-420dd0d80f7a','2022-02-03 16:04:17',2),(73,'memberInviteSend','2022-02-03 16:04:17','57fbb0d5-411d-414a-9aed-342bf6fb38b6','2022-02-03 16:04:17',3),(74,'memberInviteSend','2022-02-03 16:04:17','a75c7efd-c1c2-41b4-95fd-8ffbabdf080c','2022-02-03 16:04:17',4),(75,'memberInviteSend','2022-02-03 16:04:17','c2d85d49-52e6-4d97-9880-a49322688022','2022-02-03 16:04:17',1),(76,'memberInviteSend','2022-02-03 16:04:17','a5be488a-2c56-41e5-9959-fc80225aa95c','2022-02-03 16:04:17',2),(77,'memberInviteAccept','2022-02-03 16:04:17','443536e0-42a8-45fd-80f6-8c17a5db6b2c','2022-02-03 16:04:17',3),(78,'memberInviteAccept','2022-02-03 16:04:17','9c555580-a483-43e6-b9d8-6345e1258e83','2022-02-03 16:04:17',4),(79,'memberInviteAccept','2022-02-03 16:04:17','e89b543d-e443-4563-9d33-ccdc0c53e227','2022-02-03 16:04:17',1),(80,'memberInviteAccept','2022-02-03 16:04:17','ee0b8e86-4667-4c79-9643-d571dc771700','2022-02-03 16:04:17',2),(81,'packageList','2022-02-03 16:04:17','d1a9cb7e-b0cc-49b0-a248-6d4bc34b8271','2022-02-03 16:04:17',3),(82,'packageList','2022-02-03 16:04:17','97689915-9b05-40dc-8a10-977bd2b76611','2022-02-03 16:04:17',4),(83,'packageList','2022-02-03 16:04:17','68cbac05-31ce-4c23-bef9-84c227cc5e96','2022-02-03 16:04:17',1),(84,'packageList','2022-02-03 16:04:17','573f1bd6-a553-4894-b12c-eea54957b907','2022-02-03 16:04:17',2),(85,'packageSearch','2022-02-03 16:04:17','9c33e24f-37ce-43a8-addc-4cdacb4abf16','2022-02-03 16:04:17',3),(86,'packageSearch','2022-02-03 16:04:17','005a4374-e5fe-42b9-83ec-dadaad19f729','2022-02-03 16:04:17',4),(87,'packageSearch','2022-02-03 16:04:17','85b0fa77-b341-4c9f-b116-20c281db73ff','2022-02-03 16:04:17',1),(88,'packageSearch','2022-02-03 16:04:17','cc37893a-6b67-4850-8e3b-e711d9611480','2022-02-03 16:04:17',2),(89,'packageCreate','2022-02-03 16:04:17','194fa6b6-89ad-49d9-8839-a0866af5cc5a','2022-02-03 16:04:17',3),(90,'packageCreate','2022-02-03 16:04:17','8b48dcf0-e4ce-4581-88d0-e2371d4ab40d','2022-02-03 16:04:17',4),(91,'packageCreate','2022-02-03 16:04:17','61e10ce2-7850-4551-928f-e20afdaacbc5','2022-02-03 16:04:17',1),(92,'packageCreate','2022-02-03 16:04:17','8ddedd29-a3bb-440f-b761-283edeaf3ec0','2022-02-03 16:04:17',2),(93,'packageEdit','2022-02-03 16:04:17','b5b5e086-66de-4497-82b6-e3fe7cf2d2f7','2022-02-03 16:04:17',3),(94,'packageEdit','2022-02-03 16:04:17','b411ba02-9f5c-4c50-af69-638e92000146','2022-02-03 16:04:17',4),(95,'packageEdit','2022-02-03 16:04:17','0f1e4058-2d33-485e-86f8-5caaeb76973c','2022-02-03 16:04:17',1),(96,'packageEdit','2022-02-03 16:04:17','033d95e1-eef2-45b9-83d1-5bbe2513cc5a','2022-02-03 16:04:17',2),(97,'packageDelete','2022-02-03 16:04:17','ec73ac97-2058-4187-a996-dc0c96de5365','2022-02-03 16:04:17',3),(98,'packageDelete','2022-02-03 16:04:18','be9caa53-23ef-45f1-a9f9-a35fd28e799e','2022-02-03 16:04:18',4),(99,'packageDelete','2022-02-03 16:04:18','c330b52b-c6b9-4f02-963e-cf727a97e4cb','2022-02-03 16:04:18',1),(100,'packageDelete','2022-02-03 16:04:18','dfd2f2f2-5b4a-4b5c-97c0-b2f13603618e','2022-02-03 16:04:18',2),(101,'packageUploadVersion','2022-02-03 16:04:18','9dbfef16-a920-4548-bc6b-33ad1c550d29','2022-02-03 16:04:18',3),(102,'packageUploadVersion','2022-02-03 16:04:18','fe26ed6c-359c-4325-99be-2cfb5b600f25','2022-02-03 16:04:18',4),(103,'packageUploadVersion','2022-02-03 16:04:18','3f49ab52-641c-4fe8-80aa-f377de2694b7','2022-02-03 16:04:18',1),(104,'packageUploadVersion','2022-02-03 16:04:18','e1be0a47-4364-4df8-a043-d25b9e57e747','2022-02-03 16:04:18',2),(105,'publisherList','2022-02-03 16:04:18','69dedf35-d263-4e4a-9558-3afbd02f53bb','2022-02-03 16:04:18',3),(106,'publisherList','2022-02-03 16:04:18','13a41716-82b9-4bf5-9c37-973b57637c81','2022-02-03 16:04:18',4),(107,'publisherList','2022-02-03 16:04:18','9d7c5652-f1a0-441d-8212-3efcaec141b8','2022-02-03 16:04:18',1),(108,'publisherList','2022-02-03 16:04:18','a516ace9-77f3-4ffc-8c66-685fda797f9a','2022-02-03 16:04:18',2),(109,'publisherCreate','2022-02-03 16:04:18','0cd54f7c-2b52-42a8-ac7b-96d5238b657e','2022-02-03 16:04:18',1),(110,'publisherEdit','2022-02-03 16:04:18','50683326-aed3-4214-ac4b-ccf43c55d0df','2022-02-03 16:04:18',3),(111,'publisherEdit','2022-02-03 16:04:18','6e02dde2-dad9-48d1-acb3-ec5d232ef921','2022-02-03 16:04:18',4),(112,'publisherEdit','2022-02-03 16:04:18','934c8fdd-57f3-441a-9aa0-2ec25b953ac7','2022-02-03 16:04:18',1),(113,'publisherEdit','2022-02-03 16:04:18','245dd15d-9477-4aa2-99c9-550d86503f75','2022-02-03 16:04:18',2),(114,'publisherDelete','2022-02-03 16:04:18','e1ee51c8-7d4e-48e8-97c8-1fcff89e1f08','2022-02-03 16:04:18',1),(115,'roleList','2022-02-03 16:04:18','d5601eee-814e-4b8d-87ad-b934b2d6fa8e','2022-02-03 16:04:18',1),(116,'roleCreate','2022-02-03 16:04:18','c71a5597-501c-408b-8ff8-8bd29af2f56a','2022-02-03 16:04:18',1),(117,'roleEdit','2022-02-03 16:04:18','31cb1d45-d4be-483e-bcde-1f76aa1c7f39','2022-02-03 16:04:18',1),(118,'roleDelete','2022-02-03 16:04:18','187a6dab-abaa-4734-a0f7-e679803d15df','2022-02-03 16:04:18',1),(119,'roleAssign','2022-02-03 16:04:18','88b5fd4d-23c2-4bae-b83d-a3dc6e03d6b8','2022-02-03 16:04:18',3),(120,'roleAssign','2022-02-03 16:04:18','2f432049-a233-470f-9a83-99550a223ea9','2022-02-03 16:04:18',4),(121,'roleAssign','2022-02-03 16:04:18','727e5692-cb35-4a03-aa9c-e00457f351ba','2022-02-03 16:04:18',1),(122,'roleAssign','2022-02-03 16:04:18','1e19d748-af82-4f85-8a7e-92d27daa6b22','2022-02-03 16:04:18',2),(123,'systemVariableList','2022-02-03 16:04:18','e5e7a2df-0828-4170-8ae0-7a51201b7ac5','2022-02-03 16:04:18',1),(124,'systemVariableCreate','2022-02-03 16:04:18','0c29aa2c-26ad-4097-b1cb-d19190315fc6','2022-02-03 16:04:18',1),(125,'systemVariableEdit','2022-02-03 16:04:18','84666e99-cdb2-4df7-8438-59fb0c7f2693','2022-02-03 16:04:18',1),(126,'systemVariableDelete','2022-02-03 16:04:18','cc7c17df-aafb-487e-b9b4-0f32e03fe562','2022-02-03 16:04:18',1),(127,'teamList','2022-02-03 16:04:18','fa686fab-8609-4e54-9002-7a6710380670','2022-02-03 16:04:18',4),(128,'teamList','2022-02-03 16:04:18','694a82ad-26e3-484f-9133-b1839752f8c1','2022-02-03 16:04:18',1),(129,'teamList','2022-02-03 16:04:18','90faecde-abcb-4576-af8c-4ac58393978f','2022-02-03 16:04:18',2),(130,'teamCreate','2022-02-03 16:04:18','916b633f-b97f-4418-bcec-355e06b6c2f5','2022-02-03 16:04:18',4),(131,'teamCreate','2022-02-03 16:04:18','e229b76c-eadf-487a-ae0f-4a86bcb1984a','2022-02-03 16:04:18',1),(132,'teamCreate','2022-02-03 16:04:18','cbdbbada-8f13-4825-82b5-49a00d2bc41b','2022-02-03 16:04:18',2),(133,'teamEdit','2022-02-03 16:04:18','e731fc99-0dab-4a73-b94d-430e06baa9f3','2022-02-03 16:04:18',4),(134,'teamEdit','2022-02-03 16:04:18','fed87ffc-28d3-4e48-9f2c-81c9000641bb','2022-02-03 16:04:18',1),(135,'teamEdit','2022-02-03 16:04:18','b6e2792f-67cf-4ffe-9fcb-f3e2ae7e3f06','2022-02-03 16:04:18',2),(136,'teamDelete','2022-02-03 16:04:18','52978d95-d1aa-4818-a8b3-a6acdbc3ff15','2022-02-03 16:04:18',4),(137,'teamDelete','2022-02-03 16:04:18','3043de2d-badf-4075-ac3b-c537e7d64539','2022-02-03 16:04:18',1),(138,'teamDelete','2022-02-03 16:04:18','32787827-959a-4724-9b33-6f187d1f9697','2022-02-03 16:04:18',2),(139,'teamMembership','2022-02-03 16:04:18','aa52f9df-7b5a-4457-b408-746a1c8d97cc','2022-02-03 16:04:18',4),(140,'teamMembership','2022-02-03 16:04:18','81d2a659-c973-4710-b1ee-89c952b88b35','2022-02-03 16:04:18',1),(141,'teamMembership','2022-02-03 16:04:18','9510e071-4b44-4f66-a1d5-179461b0d79d','2022-02-03 16:04:18',2),(142,'teamAddMultipleLeaders','2022-02-03 16:04:18','d45a27df-7f5f-4fde-abc1-8539d3461557','2022-02-03 16:04:18',1),(143,'teamAddMultipleLeaders','2022-02-03 16:04:18','0967a697-8df0-4edb-9544-3ea1aa7baa0e','2022-02-03 16:04:18',2),(144,'uploaderAdd','2022-02-03 16:04:18','15bfe995-d9fc-41ea-9131-655b043159e6','2022-02-03 16:04:18',4),(145,'uploaderAdd','2022-02-03 16:04:18','3050296c-02e8-47b8-9e31-e358489298f9','2022-02-03 16:04:18',1),(146,'uploaderAdd','2022-02-03 16:04:18','887b27ef-578f-4596-9585-119e54a1a78e','2022-02-03 16:04:18',2),(147,'uploaderDelete','2022-02-03 16:04:18','676ff366-2d98-497a-b1d5-a00ae546a597','2022-02-03 16:04:18',4),(148,'uploaderDelete','2022-02-03 16:04:18','e9fddc4d-e613-40b3-ad7a-f8e09ccc8ef2','2022-02-03 16:04:18',1),(149,'uploaderDelete','2022-02-03 16:04:18','a7810590-edcd-46cf-867e-29c35bac1d16','2022-02-03 16:04:18',2),(150,'uploaderList','2022-02-03 16:04:18','c5103eca-6eb3-417d-87ff-41bbee13abd5','2022-02-03 16:04:18',4),(151,'uploaderList','2022-02-03 16:04:18','78b3be52-c1f1-4f4f-a301-53fe7bf4dc35','2022-02-03 16:04:18',1),(152,'uploaderList','2022-02-03 16:04:18','7c7247f7-64cc-4f42-ac01-6ba7c7f925db','2022-02-03 16:04:18',2);
/*!40000 ALTER TABLE `pricingTierAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ACCOUNTEMAIL` varchar(255) DEFAULT NULL,
  `BILLINGCYCLE` int(11) DEFAULT NULL,
  `BILLINGENDDATE` date DEFAULT NULL,
  `BILLINGSTARTDATE` date DEFAULT NULL,
  `CONTACTEMAIL` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `DOMAINSUFFIX` varchar(255) DEFAULT NULL,
  `GST` tinyint(1) DEFAULT 0,
  `GUID` varchar(255) DEFAULT NULL,
  `ISONEPUB` tinyint(1) DEFAULT 0,
  `NAME` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `TIP` bigint(20) DEFAULT NULL,
  `TIPTYPE` int(11) DEFAULT NULL,
  `TRIALENDDATE` date DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `COUNTRY_ID` bigint(20) DEFAULT NULL,
  `OWNER_ID` bigint(20) DEFAULT NULL,
  `PRICINGTIER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_publisher_GUID` (`GUID`),
  KEY `FK_publisher_OWNER_ID` (`OWNER_ID`),
  KEY `FK_publisher_PRICINGTIER_ID` (`PRICINGTIER_ID`),
  KEY `FK_publisher_COUNTRY_ID` (`COUNTRY_ID`),
  CONSTRAINT `FK_publisher_COUNTRY_ID` FOREIGN KEY (`COUNTRY_ID`) REFERENCES `country` (`ID`),
  CONSTRAINT `FK_publisher_OWNER_ID` FOREIGN KEY (`OWNER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_publisher_PRICINGTIER_ID` FOREIGN KEY (`PRICINGTIER_ID`) REFERENCES `pricingTier` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (1,'support@onepub.dev',0,NULL,'2022-02-03','support@onepub.dev','2022-02-03 16:04:18','_',1,'6e92cb40-df41-4bcc-a26b-7d4e9dc5a0f2',0,'__System__','live',3000,0,'2022-02-03','2022-02-03 16:04:18',1,NULL,2),(2,NULL,NULL,NULL,'2022-02-03',NULL,'2022-02-03 16:05:33',NULL,0,'1f9e6633-6e5e-486a-b2e1-450cbe074fa3',0,'bsutton@noojee.com.au','inTrial',NULL,NULL,NULL,'2022-02-03 16:05:33',NULL,NULL,NULL);
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CITY` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `STATE` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `AREACODE` varchar(255) DEFAULT NULL,
  `HUMANNAME` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `COUNTRY_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_region_GUID` (`GUID`),
  UNIQUE KEY `UNQ_region_0` (`NAME`,`AREACODE`),
  KEY `FK_region_COUNTRY_ID` (`COUNTRY_ID`),
  CONSTRAINT `FK_region_COUNTRY_ID` FOREIGN KEY (`COUNTRY_ID`) REFERENCES `country` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region`
--

LOCK TABLES `region` WRITE;
/*!40000 ALTER TABLE `region` DISABLE KEYS */;
INSERT INTO `region` VALUES (1,'Darwin','2022-02-03 16:04:17','b3295cb1-c265-494f-bf5d-25de2f7cc38f','Northern Territory','2022-02-03 16:04:17','08','Darwin','Australia/Darwin',1),(2,'Sydney','2022-02-03 16:04:17','271df775-17c9-4acf-9494-cd9603e4a04d','New South Wales','2022-02-03 16:04:17','02','Sydney','Australia/Sydney',1),(3,'Brisbane','2022-02-03 16:04:17','9344ae75-2bc4-48ad-91e0-a43249f8d23f','Queensland','2022-02-03 16:04:17','07','Brisbane','Australia/Brisbane',1),(4,'Adelaide','2022-02-03 16:04:17','331d7186-099a-431e-abc6-3434f7d9dbba','South Australia','2022-02-03 16:04:17','08','Adelaide','Australia/Adelaide',1),(5,'Hobart','2022-02-03 16:04:17','39c661ff-fc21-4655-b51d-f5a0567ae538','Tasmania','2022-02-03 16:04:17','03','Hobart','Australia/Hobart',1),(6,'Melbourne','2022-02-03 16:04:17','49004168-6b06-4fed-b00d-bea80243083f','Victoria','2022-02-03 16:04:17','03','Melbourne','Australia/Melbourne',1),(7,'Perth','2022-02-03 16:04:17','aca102d9-945b-4739-85a5-f9090359972b','Western Australia','2022-02-03 16:04:17','08','Perth','Australia/Perth',1);
/*!40000 ALTER TABLE `region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_role_GUID` (`GUID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'2022-02-03 16:04:18','Publisher Administrator','ef8bd730-06fa-4483-aca8-dc8ad418783d','Administator','2022-02-03 16:04:18'),(2,'2022-02-03 16:04:18','A user of the system.','4fa3789c-5701-463f-a962-f93e604e7aa7','Member','2022-02-03 16:04:18'),(3,'2022-02-03 16:04:18','Onepub.dev support Administrator','daacfbe4-5925-4f80-ab0d-c3737aeab0b3','SystemAdministator','2022-02-03 16:04:18'),(4,'2022-02-03 16:04:18','Publisher Team Administrator','0380e226-8a88-4322-9cae-9fb8e65fa2a0','TeamLeader','2022-02-03 16:04:18'),(5,'2022-02-03 16:04:18','Able to upload new verions of packages they own.','3724b439-8b27-4630-8877-237c4d27f28e','Uploader','2022-02-03 16:04:18');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `RANAVAILABLEDIDS` datetime DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_schedule_GUID` (`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scope`
--

DROP TABLE IF EXISTS `scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scope` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `SCOPEENUM` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `ROLE_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_scope_GUID` (`GUID`),
  KEY `FK_scope_ROLE_ID` (`ROLE_ID`),
  CONSTRAINT `FK_scope_ROLE_ID` FOREIGN KEY (`ROLE_ID`) REFERENCES `role` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scope`
--

LOCK TABLES `scope` WRITE;
/*!40000 ALTER TABLE `scope` DISABLE KEYS */;
INSERT INTO `scope` VALUES (1,'2022-02-03 16:04:18','system','35d5b3bc-ff0a-44d5-a04c-d3a748873d43','system','system','2022-02-03 16:04:18',3),(2,'2022-02-03 16:04:18','team','1a4d0113-6bbf-4271-87e7-ca0ce6492e26','team','team','2022-02-03 16:04:18',1),(3,'2022-02-03 16:04:18','publisher','8c50155e-bb9d-48e4-9ba8-fcd5447db2a8','publisher','publisher','2022-02-03 16:04:18',1),(4,'2022-02-03 16:04:18','owned','30c66804-cb11-4bd9-b7a4-b450b8e60318','owned','owned','2022-02-03 16:04:18',5),(5,'2022-02-03 16:04:18','team','c70518f2-f21e-4138-b5f6-4032ac41e661','team','team','2022-02-03 16:04:18',4),(6,'2022-02-03 16:04:18','owned','6bff59fe-da8e-4eb6-90e1-c7d1ea98c792','owned','owned','2022-02-03 16:04:18',2);
/*!40000 ALTER TABLE `scope` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessionHistory`
--

DROP TABLE IF EXISTS `sessionHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessionHistory` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `END` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `START` datetime DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_sessionHistory_GUID` (`GUID`),
  KEY `FK_sessionHistory_MEMBER_ID` (`MEMBER_ID`),
  KEY `FK_sessionHistory_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_sessionHistory_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_sessionHistory_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessionHistory`
--

LOCK TABLES `sessionHistory` WRITE;
/*!40000 ALTER TABLE `sessionHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessionHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic`
--

DROP TABLE IF EXISTS `statistic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DOWNLOADS` int(11) DEFAULT NULL,
  `FORDATE` date DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_statistic_GUID` (`GUID`),
  KEY `FK_statistic_PUBLISHER_ID` (`PUBLISHER_ID`),
  CONSTRAINT `FK_statistic_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic`
--

LOCK TABLES `statistic` WRITE;
/*!40000 ALTER TABLE `statistic` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `systemVarable`
--

DROP TABLE IF EXISTS `systemVarable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `systemVarable` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CASESENSITIVE` tinyint(1) DEFAULT 0,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `MODIFIED` datetime DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `VALUE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NAME` (`NAME`),
  UNIQUE KEY `INDEX_systemVarable_GUID` (`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `systemVarable`
--

LOCK TABLES `systemVarable` WRITE;
/*!40000 ALTER TABLE `systemVarable` DISABLE KEYS */;
/*!40000 ALTER TABLE `systemVarable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DATEDELETED` date DEFAULT NULL,
  `DEFAULTTEAM` tinyint(1) DEFAULT 0,
  `DELETED` tinyint(1) DEFAULT 0,
  `ENABLED` tinyint(1) DEFAULT 0,
  `GUID` varchar(255) DEFAULT NULL,
  `INCLUDEALLMEMBERS` tinyint(1) DEFAULT 0,
  `NAME` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CREATEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `DELETEDBY_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_team_GUID` (`GUID`),
  UNIQUE KEY `UNQ_team_0` (`PUBLISHER_ID`,`NAME`),
  KEY `FK_team_DELETEDBY_ID` (`DELETEDBY_ID`),
  KEY `FK_team_CREATEDBYMEMBER_ID` (`CREATEDBYMEMBER_ID`),
  CONSTRAINT `FK_team_CREATEDBYMEMBER_ID` FOREIGN KEY (`CREATEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_team_DELETEDBY_ID` FOREIGN KEY (`DELETEDBY_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_team_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teamLeader`
--

DROP TABLE IF EXISTS `teamLeader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teamLeader` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CREATEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  `TEAM_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_teamLeader_GUID` (`GUID`),
  KEY `FK_teamLeader_CREATEDBYMEMBER_ID` (`CREATEDBYMEMBER_ID`),
  KEY `FK_teamLeader_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_teamLeader_TEAM_ID` (`TEAM_ID`),
  KEY `FK_teamLeader_MEMBER_ID` (`MEMBER_ID`),
  CONSTRAINT `FK_teamLeader_CREATEDBYMEMBER_ID` FOREIGN KEY (`CREATEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_teamLeader_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_teamLeader_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`),
  CONSTRAINT `FK_teamLeader_TEAM_ID` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teamLeader`
--

LOCK TABLES `teamLeader` WRITE;
/*!40000 ALTER TABLE `teamLeader` DISABLE KEYS */;
/*!40000 ALTER TABLE `teamLeader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teamMember`
--

DROP TABLE IF EXISTS `teamMember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teamMember` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `CREATEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `MEMBER_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  `TEAM_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_teamMember_GUID` (`GUID`),
  KEY `FK_teamMember_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_teamMember_CREATEDBYMEMBER_ID` (`CREATEDBYMEMBER_ID`),
  KEY `FK_teamMember_MEMBER_ID` (`MEMBER_ID`),
  KEY `FK_teamMember_TEAM_ID` (`TEAM_ID`),
  CONSTRAINT `FK_teamMember_CREATEDBYMEMBER_ID` FOREIGN KEY (`CREATEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_teamMember_MEMBER_ID` FOREIGN KEY (`MEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_teamMember_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`),
  CONSTRAINT `FK_teamMember_TEAM_ID` FOREIGN KEY (`TEAM_ID`) REFERENCES `team` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teamMember`
--

LOCK TABLES `teamMember` WRITE;
/*!40000 ALTER TABLE `teamMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `teamMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tutorial`
--

DROP TABLE IF EXISTS `tutorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutorial` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `BODY` longtext DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `CREATIONDATE` date DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `HTMLBODY` longtext DEFAULT NULL,
  `SUBJECT` varchar(255) DEFAULT NULL,
  `SUMMARY` varchar(255) DEFAULT NULL,
  `TYPE` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `URLTOVIDEOMEDIA` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SUBJECT` (`SUBJECT`),
  UNIQUE KEY `INDEX_tutorial_GUID` (`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tutorial`
--

LOCK TABLES `tutorial` WRITE;
/*!40000 ALTER TABLE `tutorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `tutorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tutorialWasViewed`
--

DROP TABLE IF EXISTS `tutorialWasViewed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tutorialWasViewed` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CREATEDAT` datetime DEFAULT NULL,
  `DATEVIEWED` date DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `tutorial_id` bigint(20) DEFAULT NULL,
  `USER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_tutorialWasViewed_GUID` (`GUID`),
  KEY `FK_tutorialWasViewed_USER_ID` (`USER_ID`),
  KEY `FK_tutorialWasViewed_tutorial_id` (`tutorial_id`),
  CONSTRAINT `FK_tutorialWasViewed_USER_ID` FOREIGN KEY (`USER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_tutorialWasViewed_tutorial_id` FOREIGN KEY (`tutorial_id`) REFERENCES `tutorial` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tutorialWasViewed`
--

LOCK TABLES `tutorialWasViewed` WRITE;
/*!40000 ALTER TABLE `tutorialWasViewed` DISABLE KEYS */;
/*!40000 ALTER TABLE `tutorialWasViewed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `CHANGELOG` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `GUID` varchar(255) DEFAULT NULL,
  `PUBSPECASJSON` varchar(255) DEFAULT NULL,
  `PUBSPECASYAML` varchar(255) DEFAULT NULL,
  `README` varchar(255) DEFAULT NULL,
  `UPDATEDAT` datetime DEFAULT NULL,
  `VERSION` varchar(255) DEFAULT NULL,
  `CREATEDBYMEMBER_ID` bigint(20) DEFAULT NULL,
  `DARTPACKAGE_ID` bigint(20) DEFAULT NULL,
  `PUBLISHER_ID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `INDEX_version_GUID` (`GUID`),
  KEY `FK_version_PUBLISHER_ID` (`PUBLISHER_ID`),
  KEY `FK_version_CREATEDBYMEMBER_ID` (`CREATEDBYMEMBER_ID`),
  KEY `FK_version_DARTPACKAGE_ID` (`DARTPACKAGE_ID`),
  CONSTRAINT `FK_version_CREATEDBYMEMBER_ID` FOREIGN KEY (`CREATEDBYMEMBER_ID`) REFERENCES `member` (`ID`),
  CONSTRAINT `FK_version_DARTPACKAGE_ID` FOREIGN KEY (`DARTPACKAGE_ID`) REFERENCES `dartPackage` (`ID`),
  CONSTRAINT `FK_version_PUBLISHER_ID` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `publisher` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version`
--

LOCK TABLES `version` WRITE;
/*!40000 ALTER TABLE `version` DISABLE KEYS */;
/*!40000 ALTER TABLE `version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version_downloadHistory`
--

DROP TABLE IF EXISTS `version_downloadHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version_downloadHistory` (
  `Version_ID` bigint(20) NOT NULL,
  `downloadHistory_ID` bigint(20) NOT NULL,
  PRIMARY KEY (`Version_ID`,`downloadHistory_ID`),
  KEY `FK_version_downloadHistory_downloadHistory_ID` (`downloadHistory_ID`),
  CONSTRAINT `FK_version_downloadHistory_Version_ID` FOREIGN KEY (`Version_ID`) REFERENCES `version` (`ID`),
  CONSTRAINT `FK_version_downloadHistory_downloadHistory_ID` FOREIGN KEY (`downloadHistory_ID`) REFERENCES `downloadHistory` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version_downloadHistory`
--

LOCK TABLES `version_downloadHistory` WRITE;
/*!40000 ALTER TABLE `version_downloadHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `version_downloadHistory` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-03 16:20:41
