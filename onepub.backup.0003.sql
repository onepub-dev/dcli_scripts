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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `actionEnum` varchar(64) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(1024) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_action_name` (`name`),
  UNIQUE KEY `actionEnum_UNIQUE` (`actionEnum`)
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES (261,'billingHistoryList','List the billing history','List the billing history','2022-01-19 13:51:46','2022-01-19 13:51:46'),(262,'creditCardList','List Credit Cards','List Credit Cards','2022-01-19 13:51:46','2022-01-19 13:51:46'),(263,'creditCardCreate','Create a Credit Card','Create a Credit Card','2022-01-19 13:51:46','2022-01-19 13:51:46'),(264,'creditCardEdit','Edit a Credit Card','Edit a Credit Card','2022-01-19 13:51:46','2022-01-19 13:51:46'),(265,'creditCardDelete','Delete a Credit Card','Delete a Credit Card','2022-01-19 13:51:46','2022-01-19 13:51:46'),(266,'creditCardBill','Bill a Credit Card','Trigger a payment against a Credit Card','2022-01-19 13:51:46','2022-01-19 13:51:46'),(267,'downloadHistoryList','List a packages download history','List a packages download history','2022-01-19 13:51:46','2022-01-19 13:51:46'),(268,'memberList','List members','List members','2022-01-19 13:51:46','2022-01-19 13:51:46'),(269,'memberCreate','Create a Member','Create a Member','2022-01-19 13:51:46','2022-01-19 13:51:46'),(270,'memberEdit','Edit a Member','Edit a Member','2022-01-19 13:51:46','2022-01-19 13:51:46'),(271,'memberDelete','Delete a Member','Delete a Member','2022-01-19 13:51:46','2022-01-19 13:51:46'),(272,'memberInviteList','List member Invites','List member Invites','2022-01-19 13:51:46','2022-01-19 13:51:46'),(273,'memberInviteCreate','Create a member Invite','Create a member Invite','2022-01-19 13:51:46','2022-01-19 13:51:46'),(274,'memberInviteEdit','Edit a member Invite','Edit a member Invite','2022-01-19 13:51:46','2022-01-19 13:51:46'),(275,'memberInviteDelete','Delete a member Invite','Delete  a member Invite','2022-01-19 13:51:46','2022-01-19 13:51:46'),(276,'memberInviteSend','Send a member Invite','Send a member Invite','2022-01-19 13:51:46','2022-01-19 13:51:46'),(277,'memberInviteAccept','Accept an Invite','Accept an invite','2022-01-19 13:51:46','2022-01-19 13:51:46'),(278,'packageList','List Packages','List all packages.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(279,'packageCreate','Create Package','Create a new package via the UI or by uploading it.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(280,'packageEdit','Edit Package','Edit an existing package.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(281,'packageDelete','Delete a Package','Delete a package.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(282,'packageUploadVersion','Upload a new version package','Upload new version of an existing package.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(283,'publisherList','List publishers','List publishers','2022-01-19 13:51:46','2022-01-19 13:51:46'),(284,'publisherCreate','Create a Publisher','Create a publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(285,'publisherEdit','Edit a publisher','Edit a publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(286,'publisherDelete','Delete a publisher','Delete a publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(287,'roleList','List Roles','List Roles','2022-01-19 13:51:46','2022-01-19 13:51:46'),(288,'roleCreate','Create Roles','Create Roles','2022-01-19 13:51:46','2022-01-19 13:51:46'),(289,'roleEdit','Edit Roles','Edit Roles','2022-01-19 13:51:46','2022-01-19 13:51:46'),(290,'roleDelete','Delete Roles','Delete Roles','2022-01-19 13:51:46','2022-01-19 13:51:46'),(291,'roleAssign','Assign Role','Assign a Role to a Member','2022-01-19 13:51:46','2022-01-19 13:51:46'),(292,'teamList','List a Team','List a Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(293,'teamCreate','Create a Team','Create a Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(294,'teamEdit','Edit a Team','Edit a Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(295,'teamDelete','Delete a Team','Delete a Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(296,'teamMembership','Team Membership','Modify the list of members associated with a team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(297,'teamAddMultipleLeaders','Add more than one Team Leader','This is a licensing constraint controlling whether a Team can have more than one Team Leader','2022-01-19 13:51:46','2022-01-19 13:51:46'),(298,'uploaderAdd','Add uploader','Ability to designate a Member as an uploader','2022-01-19 13:51:46','2022-01-19 13:51:46'),(299,'uploaderDelete','Delete uploader','Remove a Member as an uploader.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(300,'uploaderList','List Uploaders','List the Members that are uploaders','2022-01-19 13:51:46','2022-01-19 13:51:46');
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billingHistory`
--

DROP TABLE IF EXISTS `billingHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billingHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `creditCardDetailsId` int(11) NOT NULL,
  `dateBilled` datetime NOT NULL,
  `amountBilled` int(11) DEFAULT NULL,
  `pricingTierId` int(11) NOT NULL,
  `billingCycle` enum('annual','monthly') NOT NULL,
  `tip` int(11) NOT NULL,
  `transactionFee` int(11) NOT NULL,
  `gst` int(11) NOT NULL,
  `successful` tinyint(4) NOT NULL,
  `error` varchar(2048) DEFAULT NULL,
  `errorCode` varchar(45) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_billingHistory_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_billingHistory_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billingHistory`
--

LOCK TABLES `billingHistory` WRITE;
/*!40000 ALTER TABLE `billingHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `billingHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditCardDetails`
--

DROP TABLE IF EXISTS `creditCardDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creditCardDetails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `ccToken` varchar(256) NOT NULL,
  `expiryDate` date NOT NULL,
  `ordinal` int(11) NOT NULL,
  `addedByMemberId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_creditCardDetails_addedBy_idx` (`addedByMemberId`),
  KEY `fk_creditCardDetails_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_creditCardDetails_addedBy` FOREIGN KEY (`addedByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_creditCardDetails_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditCardDetails`
--

LOCK TABLES `creditCardDetails` WRITE;
/*!40000 ALTER TABLE `creditCardDetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditCardDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloadHistory`
--

DROP TABLE IF EXISTS `downloadHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `downloadHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `versionId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `when` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_downloadHistory_version_idx` (`versionId`),
  KEY `fk_downloadHistory_member_idx` (`memberId`),
  KEY `idx_downloadHistory_when` (`when`),
  KEY `fk_downloadHistory_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_downloadHistory_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_downloadHistory_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_downloadHistory_version` FOREIGN KEY (`versionId`) REFERENCES `version` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadHistory`
--

LOCK TABLES `downloadHistory` WRITE;
/*!40000 ALTER TABLE `downloadHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `email` varchar(320) NOT NULL,
  `inviteId` int(11) DEFAULT NULL,
  `onepubToken` varchar(256) DEFAULT NULL,
  `oauthCredentials` varchar(8192) DEFAULT NULL,
  `oauthExpiryDate` datetime DEFAULT NULL,
  `startDate` date NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `lastApiAction` datetime DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_email_unq` (`email`),
  KEY `fk_member_publisher_idx` (`publisherId`),
  KEY `fk_member_invite_idx` (`inviteId`),
  CONSTRAINT `fk_member_invite` FOREIGN KEY (`inviteId`) REFERENCES `memberInvite` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_member_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22984 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (22983,9516,'member@noojee.com.au',NULL,'voniee04RNhUCoA3SmzBHSchhMXouZ0g9wpLw5B6ZA4ODDNLLTY1x6VpIGypJa0vOu4Fevdlw0a6c4zJCZAA5KhiaTTD1zsSvhsjRor8EQK6kBpCciniu23DkcXIIBgq',NULL,'2022-01-19 16:23:07','2022-01-19',1,NULL,'2022-01-19 15:23:07','2022-01-19 15:23:07');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `memberInvite`
--

DROP TABLE IF EXISTS `memberInvite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memberInvite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `email` varchar(320) NOT NULL,
  `invitedByMemberId` int(11) NOT NULL,
  `expires` datetime NOT NULL,
  `accepted` tinyint(4) DEFAULT 0,
  `cancelled` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_memberInvite_invitedBy_idx` (`invitedByMemberId`),
  KEY `fk_memberInvite_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_memberInvite_invitedBy` FOREIGN KEY (`invitedByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberInvite_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `roleId` int(11) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_memberRole_publisher_idx` (`publisherId`),
  KEY `fk_memberRole_member_idx` (`createdByMemberId`),
  KEY `fk_memberRole_member_idx1` (`memberId`),
  KEY `fk_memberRole_role_idx` (`roleId`),
  CONSTRAINT `fk_memberRole_createdBy` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_role` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memberRole`
--

LOCK TABLES `memberRole` WRITE;
/*!40000 ALTER TABLE `memberRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `memberRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `package`
--

DROP TABLE IF EXISTS `package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `creatorMemberId` int(11) NOT NULL,
  `private` tinyint(4) NOT NULL,
  `deactivated` tinyint(4) NOT NULL DEFAULT 0,
  `deactivationDate` date DEFAULT NULL,
  `deactivatedById` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idxPackage_name_unique` (`name`),
  KEY `fk_package_owner_idx` (`creatorMemberId`),
  KEY `fk_package_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_package_creator` FOREIGN KEY (`creatorMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_package_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package`
--

LOCK TABLES `package` WRITE;
/*!40000 ALTER TABLE `package` DISABLE KEYS */;
/*!40000 ALTER TABLE `package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packageTeam`
--

DROP TABLE IF EXISTS `packageTeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packageTeam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `teamId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_teamPackage_team_idx` (`teamId`),
  KEY `fk_teamPackage_package_idx` (`packageId`),
  KEY `fk_packageTeam_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_packageTeam_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamPackage_package` FOREIGN KEY (`packageId`) REFERENCES `package` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamPackage_team` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packageTeam`
--

LOCK TABLES `packageTeam` WRITE;
/*!40000 ALTER TABLE `packageTeam` DISABLE KEYS */;
/*!40000 ALTER TABLE `packageTeam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roleId` int(11) NOT NULL,
  `actionId` int(11) NOT NULL,
  `scope` enum('System','Publisher','Team','Owned') NOT NULL,
  `description` varchar(128) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_permission_role_action_scope` (`roleId`,`actionId`,`scope`),
  KEY `fk_permission_role_idx` (`roleId`),
  KEY `fk_permission_action_idx` (`actionId`),
  CONSTRAINT `fk_permission_action` FOREIGN KEY (`actionId`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permission_role` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (435,163,261,'System','Role can perform BillingHistoryList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(436,164,261,'Publisher','Role can perform BillingHistoryList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(437,163,262,'System','Role can perform CreditCardList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(438,164,262,'Publisher','Role can perform CreditCardList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(439,163,263,'System','Role can perform CreditCardCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(440,164,263,'Publisher','Role can perform CreditCardCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(441,163,264,'System','Role can perform CreditCardEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(442,164,264,'Publisher','Role can perform CreditCardEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(443,163,265,'System','Role can perform CreditCardDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(444,164,265,'Publisher','Role can perform CreditCardDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(445,163,266,'System','Role can perform CreditCardBill on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(446,164,266,'Publisher','Role can perform CreditCardBill on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(447,163,267,'System','Role can perform DownloadHistoryList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(448,164,267,'Publisher','Role can perform DownloadHistoryList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(449,165,267,'Team','Role can perform DownloadHistoryList on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(450,166,267,'Owned','Role can perform DownloadHistoryList on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(451,167,267,'Owned','Role can perform DownloadHistoryList on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(452,163,268,'System','Role can perform MemberList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(453,164,268,'Publisher','Role can perform MemberList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(454,165,268,'Team','Role can perform MemberList on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(455,163,269,'System','Role can perform MemberCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(456,164,269,'Publisher','Role can perform MemberCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(457,165,269,'Team','Role can perform MemberCreate on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(458,163,270,'System','Role can perform MemberEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(459,164,270,'Publisher','Role can perform MemberEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(460,165,270,'Team','Role can perform MemberEdit on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(461,163,271,'System','Role can perform MemberDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(462,164,271,'Publisher','Role can perform MemberDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(463,165,271,'Team','Role can perform MemberDelete on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(464,163,272,'System','Role can perform MemberInviteList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(465,164,272,'Publisher','Role can perform MemberInviteList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(466,165,272,'Team','Role can perform MemberInviteList on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(467,167,272,'Owned','Role can perform MemberInviteList on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(468,163,273,'System','Role can perform MemberInviteCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(469,164,273,'Publisher','Role can perform MemberInviteCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(470,165,273,'Team','Role can perform MemberInviteCreate on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(471,163,274,'System','Role can perform MemberInviteEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(472,164,274,'Publisher','Role can perform MemberInviteEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(473,165,274,'Team','Role can perform MemberInviteEdit on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(474,163,275,'System','Role can perform MemberInviteDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(475,164,275,'Publisher','Role can perform MemberInviteDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(476,165,275,'Team','Role can perform MemberInviteDelete on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(477,163,276,'System','Role can perform MemberInviteSend on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(478,164,276,'Publisher','Role can perform MemberInviteSend on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(479,165,276,'Team','Role can perform MemberInviteSend on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(480,167,277,'Owned','Role can perform MemberInviteAccept on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(481,163,278,'System','Role can perform PackageList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(482,164,278,'Publisher','Role can perform PackageList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(483,165,278,'Team','Role can perform PackageList on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(484,166,278,'Owned','Role can perform PackageList on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(485,167,278,'Owned','A Member can list packages they are associated via their Teams','2022-01-19 13:51:46','2022-01-19 13:51:46'),(486,163,279,'System','Role can perform PackageCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(487,164,279,'Publisher','Role can perform PackageCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(488,165,279,'Team','Role can perform PackageCreate on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(489,166,279,'Owned','Role can perform PackageCreate on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(490,163,280,'System','Role can perform PackageEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(491,164,280,'Publisher','Role can perform PackageEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(492,165,280,'Team','Role can perform PackageEdit on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(493,166,280,'Owned','Role can perform PackageEdit on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(494,163,281,'System','Role can perform PackageDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(495,164,281,'Publisher','Role can perform PackageDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(496,165,281,'Team','Role can perform PackageDelete on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(497,166,281,'Owned','Role can perform PackageDelete on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(498,163,282,'System','Role can perform PackageUploadVersion on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(499,164,282,'Publisher','Role can perform PackageUploadVersion on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(500,165,282,'Team','Role can perform PackageUploadVersion on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(501,166,282,'Owned','Role can perform PackageUploadVersion on Owned','2022-01-19 13:51:46','2022-01-19 13:51:46'),(502,163,283,'System','Role can perform PublisherList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(503,164,283,'Publisher','Role can perform PublisherList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(504,163,284,'System','Role can perform PublisherCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(505,164,284,'Publisher','Role can perform PublisherCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(506,163,285,'System','Role can perform PublisherEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(507,164,285,'Publisher','Role can perform PublisherEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(508,163,286,'System','Role can perform PublisherDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(509,164,286,'Publisher','Role can perform PublisherDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(510,163,287,'System','Role can perform RoleList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(511,163,288,'System','Role can perform RoleCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(512,163,289,'System','Role can perform RoleEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(513,163,290,'System','Role can perform RoleDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(514,163,291,'System','Role can perform RoleAssign on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(515,163,292,'System','Role can perform TeamList on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(516,164,292,'Publisher','Role can perform TeamList on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(517,165,292,'Team','Role can perform TeamList on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(518,163,293,'System','Role can perform TeamCreate on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(519,164,293,'Publisher','Role can perform TeamCreate on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(520,163,294,'System','Role can perform TeamEdit on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(521,164,294,'Publisher','Role can perform TeamEdit on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(522,165,294,'Team','Role can perform TeamEdit on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(523,163,295,'System','Role can perform TeamDelete on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(524,164,295,'Publisher','Role can perform TeamDelete on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(525,165,295,'Team','Role can perform TeamDelete on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(526,163,296,'System','Role can perform TeamMembership on System','2022-01-19 13:51:46','2022-01-19 13:51:46'),(527,164,296,'Publisher','Role can perform TeamMembership on Publisher','2022-01-19 13:51:46','2022-01-19 13:51:46'),(528,165,296,'Team','Role can perform TeamMembership on Team','2022-01-19 13:51:46','2022-01-19 13:51:46'),(529,163,297,'System','Role can perform TeamAddMultipleLeaders on System','2022-01-19 13:51:47','2022-01-19 13:51:47'),(530,164,297,'Publisher','Role can perform TeamAddMultipleLeaders on Publisher','2022-01-19 13:51:47','2022-01-19 13:51:47'),(531,165,297,'Team','Role can perform TeamAddMultipleLeaders on Team','2022-01-19 13:51:47','2022-01-19 13:51:47'),(532,163,298,'System','Role can perform UploaderAdd on System','2022-01-19 13:51:47','2022-01-19 13:51:47'),(533,164,298,'Publisher','Role can perform UploaderAdd on Publisher','2022-01-19 13:51:47','2022-01-19 13:51:47'),(534,163,299,'System','Role can perform UploaderDelete on System','2022-01-19 13:51:47','2022-01-19 13:51:47'),(535,164,299,'Publisher','Role can perform UploaderDelete on Publisher','2022-01-19 13:51:47','2022-01-19 13:51:47'),(536,163,300,'System','Role can perform UploaderList on System','2022-01-19 13:51:47','2022-01-19 13:51:47'),(537,164,300,'Publisher','Role can perform UploaderList on Publisher','2022-01-19 13:51:47','2022-01-19 13:51:47');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricingTier`
--

DROP TABLE IF EXISTS `pricingTier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricingTier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  `monthlyCharge` int(11) NOT NULL,
  `annualCharge` int(11) NOT NULL,
  `maxMembers` int(11) NOT NULL,
  `maxPackages` int(11) NOT NULL,
  `maxPackageSizeMB` int(11) NOT NULL,
  `maxStorageGB` int(11) NOT NULL,
  `maxDownloadsGB` int(11) NOT NULL,
  `excessStoragePriceGB` int(11) NOT NULL,
  `excessDownloadPriceGB` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTier`
--

LOCK TABLES `pricingTier` WRITE;
/*!40000 ALTER TABLE `pricingTier` DISABLE KEYS */;
INSERT INTO `pricingTier` VALUES (16,'Pro','2022-01-19',NULL,1000,12000,1,5,10,5,5,100,100,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(17,'Team','2022-01-19',NULL,2000,24000,2,20,15,5,20,100,100,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(18,'Enterprise','2022-01-19',NULL,3000,36000,20,10000,100,20,5,100,100,'2022-01-19 13:51:46','2022-01-19 13:51:46');
/*!40000 ALTER TABLE `pricingTier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricingTierAction`
--

DROP TABLE IF EXISTS `pricingTierAction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricingTierAction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pricingTierId` int(11) NOT NULL,
  `actionId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pricingTierAction_action_idx` (`actionId`),
  KEY `fk_pricingTierAction_pricingTier_idx` (`pricingTierId`),
  CONSTRAINT `fk_pricingTierAction_Action` FOREIGN KEY (`actionId`) REFERENCES `action` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pricingTierAction_pricingTier` FOREIGN KEY (`pricingTierId`) REFERENCES `pricingTier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTierAction`
--

LOCK TABLES `pricingTierAction` WRITE;
/*!40000 ALTER TABLE `pricingTierAction` DISABLE KEYS */;
INSERT INTO `pricingTierAction` VALUES (1,16,261,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(2,17,261,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(3,18,261,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(4,16,262,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(5,17,262,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(6,18,262,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(7,16,263,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(8,17,263,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(9,18,263,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(10,16,264,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(11,17,264,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(12,18,264,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(13,16,265,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(14,17,265,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(15,18,265,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(16,16,266,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(17,17,266,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(18,18,266,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(19,16,267,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(20,17,267,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(21,18,267,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(22,16,268,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(23,17,268,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(24,18,268,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(25,16,269,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(26,17,269,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(27,18,269,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(28,16,270,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(29,17,270,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(30,18,270,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(31,16,271,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(32,17,271,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(33,18,271,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(34,16,272,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(35,17,272,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(36,18,272,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(37,16,273,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(38,17,273,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(39,18,273,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(40,16,274,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(41,17,274,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(42,18,274,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(43,16,275,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(44,17,275,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(45,18,275,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(46,16,276,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(47,17,276,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(48,18,276,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(49,16,277,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(50,17,277,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(51,18,277,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(52,16,278,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(53,17,278,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(54,18,278,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(55,16,279,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(56,17,279,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(57,18,279,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(58,16,280,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(59,17,280,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(60,18,280,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(61,16,281,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(62,17,281,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(63,18,281,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(64,16,282,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(65,17,282,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(66,18,282,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(67,16,283,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(68,17,283,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(69,18,283,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(70,16,284,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(71,17,284,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(72,18,284,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(73,16,285,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(74,17,285,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(75,18,285,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(76,16,286,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(77,17,286,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(78,18,286,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(79,16,287,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(80,17,287,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(81,18,287,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(82,16,288,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(83,17,288,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(84,18,288,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(85,16,289,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(86,17,289,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(87,18,289,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(88,16,290,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(89,17,290,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(90,18,290,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(91,16,291,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(92,17,291,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(93,18,291,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(94,16,292,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(95,17,292,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(96,18,292,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(97,16,293,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(98,17,293,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(99,18,293,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(100,16,294,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(101,17,294,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(102,18,294,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(103,16,295,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(104,17,295,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(105,18,295,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(106,16,296,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(107,17,296,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(108,18,296,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(109,16,297,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(110,17,297,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(111,18,297,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(112,16,298,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(113,17,298,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(114,18,298,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(115,16,299,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(116,17,299,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(117,18,299,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(118,16,300,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(119,17,300,'2022-01-19 13:51:46','2022-01-19 13:51:46'),(120,18,300,'2022-01-19 13:51:46','2022-01-19 13:51:46');
/*!40000 ALTER TABLE `pricingTierAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publisher` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `domainSuffix` varchar(8) NOT NULL,
  `status` enum('inTrial','live','inArrears','cancelled') NOT NULL,
  `memberOwnerId` int(11) DEFAULT NULL,
  `trialEndDate` date DEFAULT NULL,
  `pricingTierId` int(11) NOT NULL,
  `contactEmail` varchar(256) NOT NULL,
  `accountEmail` varchar(320) DEFAULT NULL,
  `billingAnniversary` date NOT NULL,
  `billingEndDate` date DEFAULT NULL,
  `billingCycle` enum('month','year') NOT NULL DEFAULT 'month',
  `tip` int(11) NOT NULL,
  `tipType` enum('fixed','per member','none') NOT NULL DEFAULT 'fixed',
  `gst` tinyint(4) NOT NULL DEFAULT 0,
  `country` varchar(128) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  KEY `fk_publisher_owner_idx` (`memberOwnerId`,`id`),
  KEY `fk_publisher_pricingTier_idx` (`pricingTierId`),
  CONSTRAINT `fk_publisher_member` FOREIGN KEY (`memberOwnerId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_publisher_pricingTier` FOREIGN KEY (`pricingTierId`) REFERENCES `pricingTier` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9517 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES (9516,'noojee.com.au','a','inTrial',NULL,'2022-02-18',16,'member@noojee.com.au','accounts@noojee.com.au','2022-01-19',NULL,'month',500,'fixed',1,'Australia','2022-01-19 15:23:07','2022-01-19 15:23:07');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (163,'System Administator','Onepub.dev support Administrator','2022-01-19 13:51:46','2022-01-19 13:51:46'),(164,'Administator','Publisher Administrator','2022-01-19 13:51:46','2022-01-19 13:51:46'),(165,'Team Leader','Publisher Team Administrator','2022-01-19 13:51:46','2022-01-19 13:51:46'),(166,'Uploader','Able to upload new verions of packages they own.','2022-01-19 13:51:46','2022-01-19 13:51:46'),(167,'Member','A user of the system.','2022-01-19 13:51:46','2022-01-19 13:51:46');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessionHistory`
--

DROP TABLE IF EXISTS `sessionHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessionHistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `start` datetime NOT NULL,
  `end` datetime DEFAULT NULL,
  `type` enum('cli','web') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sessionHistory_publisher_idx` (`publisherId`),
  KEY `fk_sessionHistory_member_idx` (`memberId`),
  CONSTRAINT `fk_sessionHistory_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sessionHistory_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` varchar(45) NOT NULL,
  `forDate` date NOT NULL,
  `downloads` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `forDate_UNIQUE` (`forDate`,`publisherId`),
  KEY `fk_statistic_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_statistic_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`name`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic`
--

LOCK TABLES `statistic` WRITE;
/*!40000 ALTER TABLE `statistic` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system`
--

DROP TABLE IF EXISTS `system`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(45) NOT NULL,
  `value` varchar(256) NOT NULL,
  `type` enum('date','datetime','int','string','decimal') NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system`
--

LOCK TABLES `system` WRITE;
/*!40000 ALTER TABLE `system` DISABLE KEYS */;
/*!40000 ALTER TABLE `system` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `publisherId` int(11) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT 1,
  `defaultTeam` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_team_createdBy_idx` (`createdByMemberId`),
  KEY `fk_team_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_team_createdBy` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4;
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `teamId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_teamLeader_leader_idx` (`memberId`),
  KEY `fk_teamLeader_createdBy_idx` (`createdByMemberId`),
  KEY `fk_teamLeader_team_idx` (`teamId`),
  KEY `fk_teamLeader_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_teamLeader_createdBy` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamLeader_leader` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamLeader_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamLeader_team` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `teamId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_teamMember_createdBy_idx` (`createdByMemberId`),
  KEY `fk_teamMember_member_idx` (`memberId`),
  KEY `fk_teamMember_team_idx` (`teamId`),
  KEY `fk_teamMember_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_teamMember_createdBy` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMember_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMember_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamMember_team` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teamMember`
--

LOCK TABLES `teamMember` WRITE;
/*!40000 ALTER TABLE `teamMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `teamMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uploader`
--

DROP TABLE IF EXISTS `uploader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uploader` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `uploaderMemberId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_packageOwner_package_idx` (`packageId`),
  KEY `fk_packageOwner_publisher_idx` (`publisherId`),
  KEY `fk_packageOwner_member_idx` (`uploaderMemberId`),
  CONSTRAINT `fk_packageOwner_package` FOREIGN KEY (`packageId`) REFERENCES `package` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_packageOwner_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_uploader_uploader` FOREIGN KEY (`uploaderMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uploader`
--

LOCK TABLES `uploader` WRITE;
/*!40000 ALTER TABLE `uploader` DISABLE KEYS */;
/*!40000 ALTER TABLE `uploader` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `version` varchar(64) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `pubspecJson` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `pubspecContent` mediumtext NOT NULL,
  `readme` mediumtext DEFAULT NULL,
  `changelog` mediumtext DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idxVersion_PackageVersion` (`packageId`,`version`),
  KEY `fk_uploaderMember_idx` (`createdByMemberId`),
  KEY `fk_version_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_version_package` FOREIGN KEY (`packageId`) REFERENCES `package` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_version_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_version_uploader` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `version`
--

LOCK TABLES `version` WRITE;
/*!40000 ALTER TABLE `version` DISABLE KEYS */;
/*!40000 ALTER TABLE `version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-19 16:58:20
