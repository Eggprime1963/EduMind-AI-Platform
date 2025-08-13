-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: learning_management
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assignments`
--

USE learning_management;

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `lecture_id` int DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `due_date` datetime NOT NULL,
  `status` varchar(100) DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `lecture_id` (`lecture_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`),
  CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`lecture_id`) REFERENCES `lectures` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignments`
--

/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
INSERT INTO `assignments` VALUES (1,1,1,'Python Variables & Data Types','Create variables of different types and practice basic Python syntax. Print outputs to demonstrate understanding.','2025-07-31 23:59:00','pending'),(2,2,2,'Java Class Creation','Design a simple class with constructor, instance variables, and methods. Focus on object-oriented basics.','2025-07-31 23:59:00','pending'),(3,3,3,'C++ Memory Management','Implement dynamic memory allocation and deallocation using pointers. Handle edge cases and memory leaks.','2025-07-31 23:59:00','pending'),(4,4,4,'DOM Manipulation Project','Build an interactive webpage using JavaScript to manipulate HTML elements and handle user events.','2025-07-31 23:59:00','pending'),(5,5,5,'Rails MVC Implementation','Create a complete MVC structure for a blog application with models, views, and controllers.','2025-07-31 23:59:00','pending'),(6,6,6,'PHP Form Processing','Build a contact form that processes user input, validates data, and stores information in a database.','2025-07-31 23:59:00','pending'),(7,7,7,'Go Concurrency Challenge','Implement goroutines and channels to solve a concurrent programming problem with proper synchronization.','2025-07-31 23:59:00','pending'),(8,8,8,'iOS App Development','Create a basic iOS app with navigation, user interface elements, and data persistence using Core Data.','2025-07-31 23:59:00','pending'),(9,9,9,'Neural Network Implementation','Build a neural network from scratch using Python and NumPy. Train on a real dataset and evaluate performance.','2025-08-15 23:59:00','pending'),(10,10,10,'Rust Systems Programming','Implement a multi-threaded file processor demonstrating ownership, borrowing, and error handling in Rust.','2025-07-31 23:59:00','pending');
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;

--
-- Table structure for table `coursemetadata`
--

DROP TABLE IF EXISTS `coursemetadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coursemetadata` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `estimated_hours` int NOT NULL DEFAULT '0',
  `learning_outcomes` text,
  `prerequisites` text,
  `skill_level` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_e1o79kv0xbrn75unh2r8kknar` (`course_id`),
  CONSTRAINT `FKetteyt2vjjinwm4ybqvwfc953` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coursemetadata`
--

/*!40000 ALTER TABLE `coursemetadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `coursemetadata` ENABLE KEYS */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `teacher_id` int DEFAULT NULL,
  `image` varchar(127) DEFAULT NULL,
  `difficulty` enum('beginner','intermediate','advanced') DEFAULT 'beginner',
  `category` varchar(50) DEFAULT NULL,
  `lecture_count` int DEFAULT '0',
  `price` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `idx_courses_difficulty` (`difficulty`),
  KEY `idx_courses_category` (`category`),
  CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'Python Basics','Introduction to Python programming',2,'image/python.png','beginner','Programming',12,0.00),(2,'Java Fundamentals','Core concepts of Java',4,'image/javaf.png','beginner','Programming',10,0.00),(3,'C++ Programming','Advanced C++ techniques',5,'image/c.png','intermediate','Programming',14,0.00),(4,'JavaScript Essentials','Basics of JavaScript',13,'image/js.png','beginner','Web Development',8,0.00),(5,'Ruby on Rails','Web development with Ruby',17,'image/ra.png','intermediate','Web Development',16,0.00),(6,'PHP Basics','Introduction to PHP',2,'image/php.png','beginner','Web Development',9,0.00),(7,'Go Programming','Learning Go language',4,'image/go.png','intermediate','Programming',11,0.00),(8,'Swift for iOS','iOS development with Swift',5,'image/swift.png','intermediate','Mobile Development',18,0.00),(9,'Advanced Machine Learning with Python','Master advanced ML algorithms, deep learning, and AI applications with hands-on projects. Expert-level course with premium content including neural networks, computer vision, and NLP.',13,'image/python.png','advanced','Machine Learning',25,299000.00),(10,'Rust Programming','Safe and concurrent Rust',17,'image/Rus.png','advanced','Programming',15,0.00);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `student_id` int NOT NULL,
  `course_id` int NOT NULL,
  `enrollment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(100) DEFAULT 'active',
  PRIMARY KEY (`student_id`,`course_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES (3,1,'2023-09-01 08:00:00','active'),(3,4,'2025-06-30 15:00:00','active'),(3,16,'2024-02-15 09:30:00','completed'),(6,1,'2023-09-02 09:00:00','completed'),(6,4,'2023-07-10 16:00:00','expired'),(6,10,'2023-01-10 08:30:00','active'),(8,1,'2024-01-15 10:00:00','active'),(8,5,'2024-08-15 17:00:00','active'),(12,2,'2024-02-10 11:00:00','active'),(12,6,'2025-09-20 18:00:00','completed'),(12,17,'2025-03-20 10:30:00','active'),(18,1,'2023-04-25 11:30:00','active'),(18,2,'2025-03-05 12:00:00','expired'),(18,7,'2023-10-25 19:00:00','active'),(19,2,'2024-05-30 12:30:00','expired'),(19,3,'2023-04-20 13:00:00','active'),(19,8,'2024-11-30 20:00:00','active'),(20,3,'2024-05-25 14:00:00','completed'),(20,4,'2025-06-05 13:30:00','active'),(21,1,'2025-07-22 01:19:30','active'),(21,2,'2025-07-22 06:15:53','active');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;

--
-- Table structure for table `lectures`
--

DROP TABLE IF EXISTS `lectures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lectures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `video_url` varchar(255) NOT NULL,
  `status` varchar(100) DEFAULT 'pending',
  `content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `lectures_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lectures`
--

/*!40000 ALTER TABLE `lectures` DISABLE KEYS */;
INSERT INTO `lectures` VALUES (1,1,'Introduction to Python','https://www.youtube.com/watch?v=kqtD5dpn9C8','active','Learn Python programming fundamentals including variables, data types, control structures, and functions. Perfect for beginners starting their programming journey.'),(2,2,'Java Basics','https://www.youtube.com/watch?v=RRubcjpTkks','active','Master Java programming basics including object-oriented programming concepts, classes, methods, and Java syntax fundamentals.'),(3,3,'C++ Overview','https://www.youtube.com/watch?v=ZzaPdXTrSb8','active','Comprehensive introduction to C++ programming covering syntax, memory management, pointers, and object-oriented programming principles.'),(4,4,'JavaScript Fundamentals','https://www.youtube.com/watch?v=W6NZfCO5SIk','active','Essential JavaScript concepts including DOM manipulation, event handling, functions, and modern ES6+ features for web development.'),(5,5,'Ruby on Rails Intro','https://www.youtube.com/watch?v=t_ispmWmdjY','active','Getting started with Ruby on Rails framework for rapid web application development including MVC architecture and Rails conventions.'),(6,6,'PHP Basics','https://www.youtube.com/watch?v=OK_JCtrrv-c','active','PHP programming fundamentals for web development including syntax, variables, functions, and database connectivity basics.'),(7,7,'Go Language Intro','https://www.youtube.com/watch?v=un6ZyFkqFKo','active','Introduction to Go programming language covering syntax, concurrency, and building efficient applications with Go.'),(8,8,'Swift for iOS','https://www.youtube.com/watch?v=8Xg7E9shq0U','active','Learn Swift programming language for iOS app development including Xcode, UI development, and iOS app architecture.'),(9,9,'Kotlin Basics','https://www.youtube.com/watch?v=F9UC9DY-vIU','active','Kotlin programming fundamentals for Android development including syntax, null safety, and interoperability with Java.'),(10,10,'Introduction to Machine Learning','https://www.youtube.com/watch?v=i_LwzRVP7bg','active','In this article, we will see more about ML and its core concepts.');
/*!40000 ALTER TABLE `lectures` ENABLE KEYS */;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vnp_TxnRef` varchar(255) NOT NULL,
  `vnp_Amount` bigint NOT NULL,
  `vnp_OrderInfo` text,
  `vnp_ResponseCode` varchar(10) DEFAULT NULL,
  `vnp_TransactionNo` varchar(255) DEFAULT NULL,
  `vnp_BankCode` varchar(20) DEFAULT NULL,
  `vnp_PayDate` varchar(20) DEFAULT NULL,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `payment_status` enum('PENDING','SUCCESS','FAILED','CANCELLED') DEFAULT 'PENDING',
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `vnp_TxnRef` (`vnp_TxnRef`),
  KEY `idx_payment_user` (`user_id`),
  KEY `idx_payment_course` (`course_id`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_payment_created` (`created_date`),
  CONSTRAINT `fk_payment_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Stores VNPay payment transactions for course enrollments';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assignment_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `submission_date` datetime DEFAULT NULL,
  `grade` double DEFAULT NULL,
  `lecture_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assignment_id` (`assignment_id`),
  KEY `student_id` (`student_id`),
  KEY `FKt9l6kbbdem7sw7e6fprs48kag` (`lecture_id`),
  CONSTRAINT `FKt9l6kbbdem7sw7e6fprs48kag` FOREIGN KEY (`lecture_id`) REFERENCES `lectures` (`id`),
  CONSTRAINT `submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`),
  CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submissions`
--

/*!40000 ALTER TABLE `submissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `submissions` ENABLE KEYS */;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `login_time` datetime NOT NULL,
  `logout_time` datetime DEFAULT NULL,
  `duration_minutes` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
INSERT INTO `user_activity` VALUES (1,4,'2025-07-13 00:28:44','2025-07-13 16:17:25',948),(2,4,'2025-07-13 00:28:47','2025-07-13 16:17:25',948),(3,4,'2025-07-13 00:51:07','2025-07-13 16:17:25',926),(4,4,'2025-07-13 00:51:09','2025-07-13 16:17:25',926),(5,4,'2025-07-13 01:01:59','2025-07-13 16:17:25',915),(6,4,'2025-07-13 01:02:02','2025-07-13 16:17:25',915),(7,5,'2025-07-13 01:19:45','2025-07-13 01:40:01',20),(8,5,'2025-07-13 01:19:46','2025-07-13 01:40:01',20),(9,4,'2025-07-13 01:30:56','2025-07-13 16:17:25',886),(10,4,'2025-07-13 01:30:58','2025-07-13 16:17:25',886),(11,5,'2025-07-13 01:37:36','2025-07-13 01:40:01',2),(12,5,'2025-07-13 01:37:38','2025-07-13 01:40:01',2),(13,5,'2025-07-13 01:40:29','2025-07-13 02:18:35',38),(14,5,'2025-07-13 01:40:31','2025-07-13 02:18:35',38),(15,5,'2025-07-13 01:49:17','2025-07-13 02:18:35',29),(16,5,'2025-07-13 02:12:49','2025-07-13 02:18:35',5),(17,5,'2025-07-13 02:16:30','2025-07-13 02:18:35',2),(18,5,'2025-07-13 02:18:42','2025-07-13 16:21:44',25),(19,4,'2025-07-13 16:17:11','2025-07-13 16:17:25',0),(20,5,'2025-07-13 16:17:31','2025-07-13 16:21:44',4),(21,4,'2025-07-13 16:22:03','2025-07-13 16:22:13',0),(22,6,'2025-07-13 16:23:06','2025-07-13 16:23:31',0),(23,4,'2025-07-13 16:25:20','2025-07-13 17:20:07',54),(24,4,'2025-07-13 17:10:53','2025-07-13 17:20:07',9),(25,4,'2025-07-13 17:19:31','2025-07-13 17:20:07',0),(26,2,'2025-07-13 17:30:58','2025-07-13 17:40:31',9),(27,4,'2025-07-13 17:40:45','2025-07-14 13:26:24',1185),(28,5,'2025-07-13 17:41:10','2025-07-14 11:23:45',1062),(29,5,'2025-07-13 18:01:44','2025-07-14 11:23:45',1042),(30,4,'2025-07-13 18:05:49','2025-07-14 13:26:24',1160),(31,4,'2025-07-13 18:12:09','2025-07-14 13:26:24',1154),(32,4,'2025-07-13 19:14:56','2025-07-14 13:26:24',1091),(33,4,'2025-07-13 19:28:30','2025-07-14 13:26:24',1077),(34,4,'2025-07-13 19:40:27','2025-07-14 13:26:24',1065),(35,5,'2025-07-14 11:22:53','2025-07-14 11:23:45',0),(36,5,'2025-07-14 12:11:29','2025-07-14 13:23:43',72),(37,5,'2025-07-14 12:18:34','2025-07-14 13:23:43',65),(38,5,'2025-07-14 13:21:40','2025-07-14 13:23:43',2),(39,5,'2025-07-14 13:23:41','2025-07-14 13:23:43',0),(40,4,'2025-07-14 13:26:18','2025-07-14 13:26:24',0),(41,4,'2025-07-14 13:27:39','2025-07-14 13:28:14',0),(42,5,'2025-07-14 13:49:10','2025-07-14 13:49:15',0),(43,4,'2025-07-14 13:50:34','2025-07-14 13:54:17',3),(44,5,'2025-07-14 13:53:36','2025-07-14 13:53:41',0),(45,4,'2025-07-14 13:53:48','2025-07-14 13:54:17',0),(46,5,'2025-07-14 13:55:05','2025-07-14 13:55:10',0),(47,4,'2025-07-14 13:55:16','2025-07-14 13:56:22',1),(48,5,'2025-07-14 13:56:28','2025-07-14 14:02:22',5),(49,5,'2025-07-14 14:05:08','2025-07-14 15:05:32',60),(50,6,'2025-07-14 14:07:49','2025-07-14 14:07:52',0),(51,4,'2025-07-14 14:23:29','2025-07-14 14:23:41',0),(52,6,'2025-07-14 14:33:42','2025-07-14 14:42:07',8),(53,5,'2025-07-14 14:42:14','2025-07-14 15:05:32',23),(54,2,'2025-07-14 14:43:00','2025-07-14 21:46:27',423),(55,6,'2025-07-14 15:01:29','2025-07-14 15:01:31',0),(56,5,'2025-07-14 15:01:38','2025-07-14 15:05:32',3),(57,5,'2025-07-14 15:05:29','2025-07-14 15:05:32',0),(58,6,'2025-07-14 20:28:07','2025-07-14 20:28:09',0),(59,6,'2025-07-14 20:28:24','2025-07-14 20:28:27',0),(60,17,'2025-07-14 20:41:26','2025-07-17 01:28:37',3167),(61,6,'2025-07-14 21:00:03','2025-07-14 21:23:33',23),(62,19,'2025-07-14 21:22:59','2025-07-14 21:23:02',0),(63,6,'2025-07-14 21:23:29','2025-07-14 21:23:33',0),(64,18,'2025-07-14 21:26:16','2025-07-14 21:26:21',0),(65,6,'2025-07-14 21:40:16','2025-07-14 21:40:28',0),(66,6,'2025-07-14 21:40:23','2025-07-14 21:40:28',0),(67,6,'2025-07-14 21:46:02','2025-07-14 21:46:05',0),(68,2,'2025-07-14 21:46:17','2025-07-14 21:46:27',0),(69,5,'2025-07-14 21:46:45','2025-07-14 21:50:25',3),(70,5,'2025-07-14 21:50:21','2025-07-14 21:50:25',0),(71,13,'2025-07-14 21:51:19','2025-07-17 01:23:02',3091),(72,5,'2025-07-14 21:55:19','2025-07-16 16:34:24',2559),(73,4,'2025-07-14 21:58:28','2025-07-16 16:28:17',2549),(74,4,'2025-07-14 22:06:58','2025-07-16 16:28:17',2541),(75,5,'2025-07-14 22:08:23','2025-07-16 16:34:24',2546),(76,4,'2025-07-14 22:24:37','2025-07-16 16:28:17',2523),(77,4,'2025-07-14 22:28:12','2025-07-16 16:28:17',2520),(78,5,'2025-07-14 22:31:20','2025-07-16 16:34:24',2523),(79,5,'2025-07-14 22:36:26','2025-07-16 16:34:24',2517),(80,4,'2025-07-14 22:52:06','2025-07-16 16:28:17',2496),(81,5,'2025-07-14 23:36:59','2025-07-16 16:34:24',2457),(82,5,'2025-07-14 23:58:26','2025-07-16 16:34:24',2435),(83,5,'2025-07-15 00:04:00','2025-07-16 16:34:24',2430),(84,4,'2025-07-15 14:55:32','2025-07-16 16:28:17',1532),(85,19,'2025-07-15 14:58:31',NULL,NULL),(86,5,'2025-07-15 15:27:56','2025-07-16 16:34:24',1506),(87,5,'2025-07-15 15:29:06','2025-07-16 16:34:24',1505),(88,5,'2025-07-15 22:12:23','2025-07-16 16:34:24',1102),(89,6,'2025-07-15 22:30:51','2025-07-15 22:31:00',0),(90,4,'2025-07-15 22:31:06','2025-07-16 16:28:17',1077),(91,4,'2025-07-15 22:44:35','2025-07-16 16:28:17',1063),(92,5,'2025-07-15 22:55:06','2025-07-16 16:34:24',1059),(93,5,'2025-07-15 23:03:00','2025-07-16 16:34:24',1051),(94,5,'2025-07-15 23:15:29','2025-07-16 16:34:24',1038),(95,5,'2025-07-15 23:19:33','2025-07-16 16:34:24',1034),(96,5,'2025-07-15 23:31:36','2025-07-16 16:34:24',1022),(97,5,'2025-07-15 23:49:12','2025-07-16 16:34:24',1005),(98,5,'2025-07-15 23:56:35','2025-07-16 16:34:24',997),(99,4,'2025-07-16 00:02:17','2025-07-16 16:28:17',986),(100,4,'2025-07-16 00:09:15','2025-07-16 16:28:17',979),(101,4,'2025-07-16 00:20:57','2025-07-16 16:28:17',967),(102,5,'2025-07-16 00:22:17','2025-07-16 16:34:24',972),(103,5,'2025-07-16 00:25:56','2025-07-16 16:34:24',968),(104,4,'2025-07-16 00:47:27','2025-07-16 16:28:17',940),(105,5,'2025-07-16 00:47:43','2025-07-16 16:34:24',946),(106,4,'2025-07-16 00:49:01','2025-07-16 16:28:17',939),(107,4,'2025-07-16 00:49:13','2025-07-16 16:28:17',939),(108,5,'2025-07-16 00:54:59','2025-07-16 16:34:24',939),(109,5,'2025-07-16 00:55:08','2025-07-16 16:34:24',939),(110,5,'2025-07-16 00:59:17','2025-07-16 16:34:24',935),(111,5,'2025-07-16 00:59:34','2025-07-16 16:34:24',934),(112,5,'2025-07-16 01:02:13','2025-07-16 16:34:24',932),(113,5,'2025-07-16 01:07:11','2025-07-16 16:34:24',927),(114,5,'2025-07-16 01:15:55','2025-07-16 16:34:24',918),(115,5,'2025-07-16 01:25:11','2025-07-16 16:34:24',909),(116,5,'2025-07-16 01:29:14','2025-07-16 16:34:24',905),(117,4,'2025-07-16 01:48:44','2025-07-16 16:28:17',879),(118,4,'2025-07-16 01:54:04','2025-07-16 16:28:17',874),(119,4,'2025-07-16 01:55:23','2025-07-16 16:28:17',872),(120,5,'2025-07-16 01:56:54','2025-07-16 16:34:24',877),(121,4,'2025-07-16 02:07:10','2025-07-16 16:28:17',861),(122,5,'2025-07-16 02:11:17','2025-07-16 16:34:24',863),(123,5,'2025-07-16 02:16:12','2025-07-16 16:34:24',858),(124,4,'2025-07-16 02:26:25','2025-07-16 16:28:17',841),(125,4,'2025-07-16 02:40:13','2025-07-16 16:28:17',828),(126,5,'2025-07-16 02:47:55','2025-07-16 16:34:24',826),(127,5,'2025-07-16 02:52:52','2025-07-16 16:34:24',821),(128,5,'2025-07-16 02:58:26','2025-07-16 16:34:24',815),(129,4,'2025-07-16 02:59:11','2025-07-16 16:28:17',809),(130,4,'2025-07-16 14:39:11','2025-07-16 16:28:17',109),(131,5,'2025-07-16 14:53:52','2025-07-16 16:34:24',100),(132,5,'2025-07-16 14:56:22','2025-07-16 16:34:24',98),(133,5,'2025-07-16 14:59:14','2025-07-16 16:34:24',95),(134,5,'2025-07-16 15:20:40','2025-07-16 16:34:24',73),(135,5,'2025-07-16 15:26:49','2025-07-16 16:34:24',67),(136,5,'2025-07-16 15:43:35','2025-07-16 16:34:24',50),(137,5,'2025-07-16 15:53:23','2025-07-16 16:34:24',41),(138,5,'2025-07-16 16:18:52','2025-07-16 16:34:24',15),(139,4,'2025-07-16 16:27:57','2025-07-16 16:28:17',0),(140,5,'2025-07-16 16:28:33','2025-07-16 16:34:24',5),(141,5,'2025-07-16 16:31:00','2025-07-16 16:34:24',3),(142,5,'2025-07-16 16:33:40','2025-07-16 16:34:24',0),(143,5,'2025-07-16 16:34:31','2025-07-16 17:48:06',73),(144,5,'2025-07-16 16:38:09','2025-07-16 17:48:06',69),(145,5,'2025-07-16 16:43:25','2025-07-16 17:48:06',64),(146,5,'2025-07-16 16:45:00','2025-07-16 17:48:06',63),(147,5,'2025-07-16 16:46:44','2025-07-16 17:48:06',61),(148,5,'2025-07-16 16:50:03','2025-07-16 17:48:06',58),(149,5,'2025-07-16 16:51:37','2025-07-16 17:48:06',56),(150,5,'2025-07-16 17:13:33','2025-07-16 17:48:06',34),(151,5,'2025-07-16 17:36:34','2025-07-16 17:48:06',11),(152,5,'2025-07-16 17:42:25','2025-07-16 17:48:06',5),(153,4,'2025-07-16 17:44:28','2025-07-16 17:47:40',3),(154,5,'2025-07-16 17:47:49','2025-07-16 17:48:06',0),(155,5,'2025-07-16 17:48:12','2025-07-17 01:17:09',448),(156,4,'2025-07-16 17:53:49','2025-07-16 17:53:53',0),(157,4,'2025-07-16 17:55:46','2025-07-17 01:19:47',444),(158,5,'2025-07-16 18:20:43','2025-07-17 01:17:09',416),(159,5,'2025-07-16 18:41:54','2025-07-17 01:17:09',395),(160,5,'2025-07-16 18:46:02','2025-07-17 01:17:09',391),(161,4,'2025-07-16 20:57:02','2025-07-17 01:19:47',262),(162,5,'2025-07-16 21:28:53','2025-07-17 01:17:09',228),(163,5,'2025-07-16 21:47:45','2025-07-17 01:17:09',209),(164,5,'2025-07-16 22:46:40','2025-07-17 01:17:09',150),(165,5,'2025-07-16 23:20:56','2025-07-17 01:17:09',116),(166,5,'2025-07-16 23:41:01','2025-07-17 01:17:09',96),(167,5,'2025-07-16 23:48:42','2025-07-17 01:17:09',88),(168,5,'2025-07-17 00:41:55','2025-07-17 01:17:09',35),(169,5,'2025-07-17 01:02:57','2025-07-17 01:17:09',14),(170,5,'2025-07-17 01:08:00','2025-07-17 01:17:09',9),(171,5,'2025-07-17 01:10:41','2025-07-17 01:17:09',6),(172,4,'2025-07-17 01:17:15','2025-07-17 01:19:47',2),(173,2,'2025-07-17 01:20:28','2025-07-17 01:21:34',1),(174,13,'2025-07-17 01:21:44','2025-07-17 01:23:02',1),(175,17,'2025-07-17 01:23:17','2025-07-17 01:28:37',5),(176,6,'2025-07-17 11:25:17','2025-07-17 11:25:39',0),(177,4,'2025-07-17 11:25:44','2025-07-18 14:22:59',1617),(178,4,'2025-07-17 13:08:49','2025-07-18 14:22:59',1514),(179,4,'2025-07-17 15:48:02','2025-07-18 14:22:59',1354),(180,4,'2025-07-17 16:28:39','2025-07-18 14:22:59',1314),(181,5,'2025-07-17 16:45:33',NULL,NULL),(182,4,'2025-07-18 14:17:57','2025-07-18 14:22:59',5),(183,2,'2025-07-18 14:30:08',NULL,NULL),(184,4,'2025-07-18 14:54:29',NULL,NULL);
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;

--
-- Table structure for table `useractivity`
--

DROP TABLE IF EXISTS `useractivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `useractivity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `duration_minutes` bigint DEFAULT NULL,
  `login_time` datetime(6) DEFAULT NULL,
  `logout_time` datetime(6) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKskd5j2i17tkl22j8asxxs23py` (`user_id`),
  CONSTRAINT `FKskd5j2i17tkl22j8asxxs23py` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useractivity`
--

/*!40000 ALTER TABLE `useractivity` DISABLE KEYS */;
/*!40000 ALTER TABLE `useractivity` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` varchar(255) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `date_of_birth` datetime(6) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `school` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `google_id` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','admin@example.com','admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'teacher1','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','teacher1@example.com','teacher',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,'student1','$2a$10$3zHz9B..F4T7Y3b2fG7q5e6J7Qz4z2b5q8L9W4m2T8F7Y3N4M6K2','student1@example.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'lvd27012004@gmail.com','','lvd27012004@gmail.com','teacher','104275197933380558868',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,'datlvde180983','','datlvde180983@fpt.edu.vn','teacher','109653592243158745281',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,'user01','$2a$10$Qc2iIzqZo/2W/LGUoEqPfuoCrIWwbbS2schBVAmMB/iPT8eCh/sPa','a@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,'a','123','dat@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'hoang','$2a$10$nZid.RsJg8vO5uPk994.Cuu0UUWRJbjPNcD0JWGctyJFTomq2NR12','hoang@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(12,'user09','$2a$10$lvGrGyqK2Ka0KtrwqxWI7O4wbNrP0YDBv6nppWLyXPCT2MJM8Wur2','wirenvahd@hotmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,'asd','$2a$10$nkMdcCVtDjlOZiKmBLMvzuHNWbHlQUsZY/gfMufIMC8ebmJkgMtU6','asdasd@gmail.com','teacher',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,'huy','$2a$10$Nvt9/PLxdO4y6poyHAQLIeOrOcrK7cH5Zfa5t.ou/OzNDcRqXh7v.','huy@gmail.com','teacher',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(18,'dat','$2a$10$VXkeStchcyxu57JLG2YVcuUcX8BIsQOQS5yYeODh3wLLiOScclAw6','123a@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,'user02','$2a$10$AqvSAr1TtuMYP/H6dtAYn./dQ5eNQtDc3SpPVpmt0P2vbsUo/KTwS','user02@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,'user05','$2a$10$s7SS1DJ3prb37QAyGMcLJuC793SKz.YjslDzeV.hL918OOOtk/6Lq','user05@gmail.com','student',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,'nguyenstudy0504','','nguyenstudy0504@gmail.com','student','114732364465780705066','Đặng','Phương Khôi Nguyên',NULL,NULL,NULL,NULL,NULL),(22,'sonicprime1963','','sonicprime1963@gmail.com','teacher','113123192854012385974','James','Đặng',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Dumping routines for database 'learning_management'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-23 15:04:05
