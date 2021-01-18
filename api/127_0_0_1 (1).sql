-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 18 Oca 2021, 21:20:58
-- Sunucu sürümü: 10.4.14-MariaDB
-- PHP Sürümü: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `arabalarim`
--
CREATE DATABASE IF NOT EXISTS `arabalarim` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `arabalarim`;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tbl_arabalarim`
--

CREATE TABLE `tbl_arabalarim` (
  `id` int(11) NOT NULL,
  `adsoyad` varchar(200) NOT NULL,
  `model` varchar(100) NOT NULL,
  `km` varchar(100) NOT NULL,
  `uretimyili` varchar(100) NOT NULL,
  `aracresim` varchar(200) NOT NULL,
  `muaynekagidi` varchar(100) NOT NULL,
  `sigorta_yenileme` date DEFAULT NULL,
  `muayne_yenileme` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `tbl_arabalarim`
--
ALTER TABLE `tbl_arabalarim`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `tbl_arabalarim`
--
ALTER TABLE `tbl_arabalarim`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
