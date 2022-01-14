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
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloadHistory`
--

LOCK TABLES `downloadHistory` WRITE;
/*!40000 ALTER TABLE `downloadHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloadHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feature`
--

DROP TABLE IF EXISTS `feature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feature` (
  `id` int(11) NOT NULL,
  `featureEnum` varchar(64) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_feature_name` (`name`),
  UNIQUE KEY `featureEnum_UNIQUE` (`featureEnum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feature`
--

LOCK TABLES `feature` WRITE;
/*!40000 ALTER TABLE `feature` DISABLE KEYS */;
/*!40000 ALTER TABLE `feature` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=21924 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
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
  `id` int(11) NOT NULL,
  `publisherId` int(11) NOT NULL,
  `memberId` int(11) NOT NULL,
  `roleId` int(11) NOT NULL,
  `createdByMemberId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_memberRole_publisher_idx` (`publisherId`),
  KEY `fk_memberRole_role_idx` (`roleId`),
  KEY `fk_memberRole_member_idx` (`createdByMemberId`),
  KEY `fk_memberRole_member_idx1` (`memberId`),
  CONSTRAINT `fk_memberRole_createdBy` FOREIGN KEY (`createdByMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_memberRole_role` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
) ENGINE=InnoDB AUTO_INCREMENT=516 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `package`
--

LOCK TABLES `package` WRITE;
/*!40000 ALTER TABLE `package` DISABLE KEYS */;
/*!40000 ALTER TABLE `package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packageOwner`
--

DROP TABLE IF EXISTS `packageOwner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packageOwner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `publisherId` int(11) NOT NULL,
  `ownerMemberId` int(11) NOT NULL,
  `packageId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_packageOwner_package_idx` (`packageId`),
  KEY `fk_packageOwner_publisher_idx` (`publisherId`),
  KEY `fk_packageOwner_member_idx` (`ownerMemberId`),
  CONSTRAINT `fk_packageOwner_member` FOREIGN KEY (`ownerMemberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_packageOwner_package` FOREIGN KEY (`packageId`) REFERENCES `package` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_packageOwner_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4;
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `packageId` int(11) NOT NULL,
  `teamId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_teamPackage_team_idx` (`teamId`),
  KEY `fk_teamPackage_package_idx` (`packageId`),
  CONSTRAINT `fk_teamPackage_package` FOREIGN KEY (`packageId`) REFERENCES `package` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_teamPackage_team` FOREIGN KEY (`teamId`) REFERENCES `team` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `id` int(11) NOT NULL,
  `publisherId` int(11) NOT NULL,
  `roleId` int(11) NOT NULL,
  `featureId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_permission_feature_idx` (`featureId`),
  KEY `fk_permission_role_idx` (`roleId`),
  KEY `fk_permission_publisher_idx` (`publisherId`),
  CONSTRAINT `fk_permission_feature` FOREIGN KEY (`featureId`) REFERENCES `feature` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permission_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_permission_role` FOREIGN KEY (`roleId`) REFERENCES `role` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
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
  `pricingTierTypeId` int(11) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date DEFAULT NULL,
  `monthlyCharge` int(11) NOT NULL,
  `annualCharge` int(11) NOT NULL,
  `maxPackageSizeGB` int(11) NOT NULL,
  `maxStorageGB` int(11) NOT NULL,
  `maxDownloadsGB` int(11) NOT NULL,
  `excessStoragePriceGB` int(11) NOT NULL,
  `excessDownloadPriceGB` decimal(5,2) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pricingTier_type_idx` (`pricingTierTypeId`),
  CONSTRAINT `fk_pricingTier_type` FOREIGN KEY (`pricingTierTypeId`) REFERENCES `pricingTierType` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTier`
--

LOCK TABLES `pricingTier` WRITE;
/*!40000 ALTER TABLE `pricingTier` DISABLE KEYS */;
/*!40000 ALTER TABLE `pricingTier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pricingTierType`
--

DROP TABLE IF EXISTS `pricingTierType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricingTierType` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_Pricing_Tier_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricingTierType`
--

LOCK TABLES `pricingTierType` WRITE;
/*!40000 ALTER TABLE `pricingTierType` DISABLE KEYS */;
/*!40000 ALTER TABLE `pricingTierType` ENABLE KEYS */;
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
  `pricingTier` enum('pro','team','enterprise','public') NOT NULL,
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
  CONSTRAINT `fk_publisher_member` FOREIGN KEY (`memberOwnerId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7437 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
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
  `end` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sessionHistory_publisher_idx` (`publisherId`),
  KEY `fk_sessionHistory_member_idx` (`memberId`),
  CONSTRAINT `fk_sessionHistory_member` FOREIGN KEY (`memberId`) REFERENCES `member` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sessionHistory_publisher` FOREIGN KEY (`publisherId`) REFERENCES `publisher` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4;
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
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teamMember`
--

LOCK TABLES `teamMember` WRITE;
/*!40000 ALTER TABLE `teamMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `teamMember` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=444 DEFAULT CHARSET=latin1;
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

-- Dump completed on 2022-01-14 15:51:53
