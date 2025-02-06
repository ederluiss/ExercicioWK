-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: exerciciowk
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `Codigo` int NOT NULL AUTO_INCREMENT,
  `Descricao` varchar(100) NOT NULL,
  `PrecoVenda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`Codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Produto 1',10.00),(2,'Produto 2',20.00),(3,'Notebook Dell Inspiron',3599.90),(4,'Smartphone Samsung Galaxy S21',2499.99),(5,'Teclado Mecânico RGB',299.50),(6,'Mouse Gamer Logitech',199.90),(7,'Monitor LED 24\" Full HD',849.99),(8,'Impressora Multifuncional HP',699.90),(9,'Cadeira Gamer Ergonômica',1299.99),(10,'Tablet Samsung Galaxy Tab',1799.00),(11,'Fone de Ouvido Bluetooth JBL',349.90),(12,'Smartwatch Xiaomi Mi Band',199.99),(13,'HD Externo 1TB Seagate',499.90),(14,'Placa de Vídeo RTX 3060',2499.90),(15,'Processador Intel Core i7',1799.00),(16,'Memória RAM 16GB DDR4',599.90),(17,'SSD NVMe 512GB Kingston',449.99),(18,'Gabinete Gamer com LED',399.90),(19,'Fonte 750W 80 Plus Gold',649.99),(20,'Webcam Full HD Logitech',289.90),(21,'Controle Xbox Series X',399.99),(22,'Carregador Portátil 20.000mAh',229.90);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-06 18:03:37
