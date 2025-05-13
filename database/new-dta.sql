-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: news_platform_db
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `news_posts`
--

DROP TABLE IF EXISTS `news_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `source_link` varchar(255) DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `video_path` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','verified','fake') DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `news_posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_posts`
--

LOCK TABLES `news_posts` WRITE;
/*!40000 ALTER TABLE `news_posts` DISABLE KEYS */;
INSERT INTO `news_posts` VALUES (1,6,'India Won Champions trophy 2025','Champions Trophy final: India rode on Rohit Sharma\'s captain\'s knock on the big day and an all-round effort from their spinners to beat New Zealand by four wickets. India were crowned the Champions of Champions for the third time in history','https://www.indiatoday.in/sports/cricket/story/champions-trophy-india-vs-new-zealand-final-rohit-sharma-crowned-champion-dubai-spinners-2691266-2025-03-09','uploads/1000062923.jpg',NULL,'2025-05-11 22:40:03','verified'),(2,2,'India-Pakistan tension has been put off ','\r\nAfter four days of military escalation, during which Indian and Pakistani forces attacked each other\'s military installations, they agreed on a ceasefire, which Trump said was reached after “a long night of talks” mediated by the US and other countries','',NULL,NULL,'2025-05-11 22:43:42','verified'),(4,6,'indaisbnd','fsfcxz xv','',NULL,NULL,'2025-05-12 00:03:31','fake'),(5,6,'USA claims India Pakistan is now made a ceasefire','A ceasefire between India and Pakistan appears to have held overnight into Sunday, after the two nations accused each other of \"violations\" just hours after a deal was reached.\r\n\r\nDays of cross-border military strikes had preceded the US-brokered deal, marking the worst military confrontation between the two rivals in decades.\r\n\r\nUS President Donald Trump praised India and Pakistan\'s leaders for agreeing the ceasefire in fresh comments on Sunday morning, saying millions of people could have died without it.','https://www.indiatoday.in/sports/cricket/story/champions-trophy-india-vs-new-zealand-final-rohit-sharma-crowned-champion-dubai-spinners-2691266-2025-03-09','uploads/1000072465.jpg','uploads/1000072207.mp4','2025-05-12 00:22:49','pending'),(6,5,'Meme','Hahaah','','uploads/1000072209.jpg',NULL,'2025-05-12 12:21:32','verified'),(11,7,'Virat Kohli announces retirement. ','Virat Kohli, one of India\'s most celebrated cricketers, has announced his retirement from Test cricket ahead of the upcoming England series. Kohli’s decision marks the end of an era in Indian cricket.\r\nKnown for his intensity, unmatched fitness, and relentless drive, Kohli leaves behind a remarkable legacy in the longest format of the game. The 36-year-old played 123 Tests, amassing 9,230 runs at an average of 48.7, including 30 centuries and 31 fifties.','https://timesofindia.indiatimes.com/sports/cricket/news/virat-kohli-retires-legendary-india-batter-bows-out-before-england-series/articleshow/121050649.cms','uploads/1000072543.jpg',NULL,'2025-05-12 13:45:27','verified');
/*!40000 ALTER TABLE `news_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'suraj','guru183@gmail.com','$2b$12$B.IzwhkVNlBrNQmJGtzxh.wEzBS14naicPkPK/1lAqRr5QlgXZTti','user',0),(3,'sam','vari123@outlook.com','$2b$12$bipItJthsXFod/PMFgHmYOhlSoEfbs38OR7CL2Nx1QQwzIIX44jGW','user',0),(5,'aakash','asa123@gmail.com','$2b$12$P6LHMNYUeJSmxgU5QurpgOkZCqEKG6Vy.XE6BIaG8zYhfyPFz31EG','user',0),(6,'Mohit','mohit2003@gmail.com','$2b$12$Uy8cGyK8kHLalnZdBwgSveRv4aNRxZ7wCwgrX2JBRHWgVlvHA1biK','admin',1),(7,'Riya','r-23@email.com','$2b$12$KCstvQAC/PieEhCWjIFjZeA2oaksZ3OVy/iwI70bpOdvDhawbhAbS','user',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-12 14:02:37
