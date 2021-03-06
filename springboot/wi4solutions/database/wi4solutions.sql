-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 03, 2019 at 08:17 AM
-- Server version: 5.7.25-0ubuntu0.16.04.2
-- PHP Version: 7.0.33-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wi4solutions`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`wi4solutions`@`localhost` PROCEDURE `get_call_report` (IN `from_date` DATE, `to_date` DATE)  BEGIN
DECLARE FAILED_CALLS BIGINT UNSIGNED DEFAULT 0;
DECLARE CONNECTED_CALLS BIGINT UNSIGNED DEFAULT 0;
DECLARE TOTAL_CALLS BIGINT DEFAULT 0; 
DECLARE TOTAL_DURATION BIGINT DEFAULT 0; 
DECLARE ASR BIGINT DEFAULT 0; 
DECLARE ACD BIGINT DEFAULT 0; 

SELECT COUNT(id), SUM(duration) INTO CONNECTED_CALLS, TOTAL_DURATION FROM wi4solutions.call_detail_record WHERE disposition = 'ANSWERED' 
AND duration > 0
AND DATE(calldate) BETWEEN from_date AND to_date;
SELECT COUNT(id) INTO TOTAL_CALLS FROM wi4solutions.call_detail_record WHERE DATE(calldate) BETWEEN from_date AND to_date;

SET ASR = (CONNECTED_CALLS / TOTAL_CALLS) * 100;

SET ACD = TOTAL_DURATION / CONNECTED_CALLS ;

SELECT CONNECTED_CALLS, TOTAL_CALLS, TOTAL_DURATION, ACD, ASR;
END$$

CREATE DEFINER=`wi4solutions`@`localhost` PROCEDURE `get_call_report_2` (IN `from_date` DATE, `to_date` DATE, OUT `FAILED_CALLS` BIGINT, OUT `CONNECTED_CALLS` BIGINT, OUT `TOTAL_CALLS` BIGINT, OUT `TOTAL_DURATION` BIGINT, OUT `ASR` DOUBLE, OUT `ACD` BIGINT)  BEGIN

SELECT COUNT(id), SUM(duration) INTO CONNECTED_CALLS, TOTAL_DURATION FROM wi4solutions.call_detail_record WHERE disposition = 'ANSWERED' 
AND duration > 0
AND DATE(calldate) BETWEEN from_date AND to_date;
SELECT COUNT(id) INTO TOTAL_CALLS FROM wi4solutions.call_detail_record WHERE DATE(calldate) BETWEEN from_date AND to_date;
SELECT CONNECTED_CALLS / TOTAL_CALLS * 100 INTO ASR;
SELECT TOTAL_DURATION / CONNECTED_CALLS INTO ACD;

END$$

--
-- Functions
--
CREATE DEFINER=`wi4solutions`@`localhost` FUNCTION `getDialData` (`number` VARCHAR(100)) RETURNS VARCHAR(100) CHARSET latin1 BEGIN
DECLARE dial VARCHAR(200) DEFAULT "";
SELECT CONCAT(preceding,SUBSTRING(number,p.digit_cut + 1),'@', g.name) INTO dial FROM dial_plan p INNER JOIN sip_peer g ON g.id = p.gateway_id 
WHERE SUBSTRING(number,1,LENGTH(prefix)) = p.prefix ORDER BY LENGTH(p.prefix) DESC LIMIT 1 ;	

RETURN dial;
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `call_detail_record`
--

CREATE TABLE `call_detail_record` (
  `id` bigint(20) NOT NULL,
  `calldate` datetime NOT NULL,
  `clid` varchar(80) NOT NULL DEFAULT '',
  `src` varchar(80) NOT NULL DEFAULT '',
  `dst` varchar(80) NOT NULL DEFAULT '',
  `dcontext` varchar(80) NOT NULL DEFAULT '',
  `channel` varchar(80) NOT NULL DEFAULT '',
  `dstchannel` varchar(80) NOT NULL DEFAULT '',
  `lastapp` varchar(80) NOT NULL DEFAULT '',
  `lastdata` varchar(80) NOT NULL DEFAULT '',
  `duration` int(11) NOT NULL DEFAULT '0',
  `billsec` int(11) NOT NULL DEFAULT '0',
  `disposition` varchar(45) NOT NULL DEFAULT '',
  `amaflags` int(11) NOT NULL DEFAULT '0',
  `accountcode` varchar(20) NOT NULL DEFAULT '',
  `uniqueid` varchar(32) NOT NULL DEFAULT '',
  `userfield` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `call_detail_record`
--

INSERT INTO `call_detail_record` (`id`, `calldate`, `clid`, `src`, `dst`, `dcontext`, `channel`, `dstchannel`, `lastapp`, `lastdata`, `duration`, `billsec`, `disposition`, `amaflags`, `accountcode`, `uniqueid`, `userfield`) VALUES
(1, '2018-12-23 19:11:27', '"+584241252039" <+584241252039>', '+584241252039', '323423423', 'incoming', 'SIP/+584241252039-00000000', '', 'Dial', 'SIP/', 0, 0, 'FAILED', 3, '', '1545606687.0', ''),
(2, '2018-12-23 19:12:15', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000001', '', 'Dial', 'SIP/', 0, 0, 'FAILED', 3, '', '1545606735.2', ''),
(3, '2018-12-23 19:19:02', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000002', 'SIP/200.73.192.254-00000003', 'Dial', 'SIP/00584241280510@200.73.192.254', 32, 0, 'NO ANSWER', 3, '', '1545607142.4', ''),
(4, '2018-12-23 19:21:24', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000004', '', 'Dial', 'SIP/00584241280510@Main_Gateway', 0, 0, 'CONGESTION', 3, '', '1545607284.7', ''),
(5, '2018-12-23 19:23:47', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000005', 'SIP/GOIP-00000006', 'Dial', 'SIP/00584241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545607427.9', ''),
(6, '2018-12-23 19:25:28', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000007', 'SIP/GOIP-00000008', 'Dial', 'SIP/05704241280510@GOIP', 27, 0, 'NO ANSWER', 3, '', '1545607528.12', ''),
(7, '2018-12-23 19:26:08', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000009', 'SIP/GOIP-0000000a', 'Dial', 'SIP/05704241280510@GOIP', 25, 0, 'NO ANSWER', 3, '', '1545607568.15', ''),
(8, '2018-12-23 19:29:11', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-0000000b', 'SIP/GOIP-0000000c', 'Dial', 'SIP/05602127350632@GOIP', 15, 0, 'CONGESTION', 3, '', '1545607751.18', ''),
(9, '2018-12-23 19:30:03', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-0000000d', 'SIP/GOIP-0000000e', 'Dial', 'SIP/05602127350632@GOIP', 13, 0, 'NO ANSWER', 3, '', '1545607803.21', ''),
(10, '2018-12-23 19:38:51', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-0000000f', 'SIP/GOIP-00000010', 'Dial', 'SIP/05602127350632@GOIP', 20, 0, 'CONGESTION', 3, '', '1545608331.24', ''),
(11, '2018-12-23 19:41:14', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000011', 'SIP/GOIP-00000012', 'Dial', 'SIP/05602127350632@GOIP', 22, 0, 'NO ANSWER', 3, '', '1545608474.27', ''),
(12, '2018-12-23 19:50:14', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000013', 'SIP/GOIP-00000014', 'Dial', 'SIP/05602127350632@GOIP', 18, 0, 'NO ANSWER', 3, '', '1545609014.30', ''),
(13, '2018-12-23 19:52:06', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000015', 'SIP/GOIP-00000016', 'Dial', 'SIP/02127350632@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609126.33', ''),
(14, '2018-12-23 19:53:13', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000017', 'SIP/GOIP-00000018', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609193.36', ''),
(15, '2018-12-23 19:53:32', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000019', 'SIP/GOIP-0000001a', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609212.39', ''),
(16, '2018-12-23 19:53:48', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-0000001b', 'SIP/GOIP-0000001c', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609228.42', ''),
(17, '2018-12-23 19:54:16', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-0000001d', 'SIP/GOIP-0000001e', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609256.45', ''),
(18, '2018-12-23 19:55:11', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-0000001f', 'SIP/GOIP-00000020', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545609311.48', ''),
(19, '2018-12-23 19:55:32', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000021', 'SIP/GOIP-00000022', 'Dial', 'SIP/04241280510@GOIP', 55, 0, 'NO ANSWER', 3, '', '1545609332.51', ''),
(20, '2018-12-23 19:56:37', '"+584241252039" <+584241252039>', '+584241252039', '4567584241280510', 'incoming', 'SIP/+584241252039-00000023', 'SIP/GOIP-00000024', 'Dial', 'SIP/04241280510@GOIP', 17, 0, 'NO ANSWER', 3, '', '1545609397.54', ''),
(21, '2018-12-23 19:57:20', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000025', 'SIP/GOIP-00000026', 'Dial', 'SIP/02127350632@GOIP', 50, 0, 'NO ANSWER', 3, '', '1545609440.57', ''),
(22, '2018-12-23 19:58:49', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000027', 'SIP/GOIP-00000028', 'Dial', 'SIP/02127350632@GOIP', 93, 0, 'BUSY', 3, '', '1545609529.60', ''),
(23, '2018-12-23 20:16:09', '"+584241252039" <+584241252039>', '+584241252039', '45675802127350632', 'incoming', 'SIP/+584241252039-00000029', 'SIP/GOIP-0000002a', 'Dial', 'SIP/02127350632@GOIP', 27, 0, 'NO ANSWER', 3, '', '1545610569.63', ''),
(24, '2018-12-23 20:18:16', '"+584241252039" <+584241252039>', '+584241252039', '202124092442', 'incoming', 'SIP/+584241252039-0000002b', 'SIP/GOIP-0000002c', 'Dial', 'SIP/02124092442@GOIP', 19, 0, 'NO ANSWER', 3, '', '1545610696.66', ''),
(25, '2018-12-23 20:20:26', '"+584241252039" <+584241252039>', '+584241252039', '202124092442', 'incoming', 'SIP/+584241252039-0000002d', 'SIP/GOIP-0000002e', 'Dial', 'SIP/02124092442@GOIP', 20, 0, 'CONGESTION', 3, '', '1545610826.69', ''),
(26, '2018-12-23 20:20:59', '"+584241252039" <+584241252039>', '+584241252039', '202124092442', 'incoming', 'SIP/+584241252039-0000002f', 'SIP/GOIP-00000030', 'Dial', 'SIP/02124092442@GOIP', 11, 0, 'CONGESTION', 3, '', '1545610859.72', ''),
(27, '2018-12-23 20:21:46', '"+584241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000031', 'SIP/GOIP-00000032', 'Dial', 'SIP/04241280510@GOIP', 28, 0, 'BUSY', 3, '', '1545610906.75', ''),
(28, '2018-12-23 20:25:49', '"+584241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000033', 'SIP/GOIP-00000034', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545611149.78', ''),
(29, '2018-12-23 20:26:00', '"+584241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000035', 'SIP/GOIP-00000036', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545611160.81', ''),
(30, '2018-12-23 20:26:52', '"+584241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000037', 'SIP/GOIP-00000038', 'Dial', 'SIP/04241280510@GOIP', 16, 0, 'NO ANSWER', 3, '', '1545611212.84', ''),
(31, '2018-12-23 20:27:43', '"+584241252039" <+584241252039>', '+584241252039', '202124092442', 'incoming', 'SIP/+584241252039-00000039', 'SIP/GOIP-0000003a', 'Dial', 'SIP/02124092442@GOIP', 30, 0, 'BUSY', 3, '', '1545611263.87', ''),
(32, '2018-12-23 20:37:45', '"+584241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000003b', 'SIP/GOIP-0000003c', 'Dial', 'SIP/02122423974@GOIP', 14, 0, 'CONGESTION', 3, '', '1545611865.90', ''),
(33, '2018-12-23 20:38:39', '"+584241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000003d', 'SIP/GOIP-0000003e', 'Dial', 'SIP/02122423974@GOIP', 29, 0, 'BUSY', 3, '', '1545611919.93', ''),
(34, '2018-12-23 20:39:34', '"+584241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000003f', 'SIP/GOIP-00000040', 'Dial', 'SIP/02122423974@GOIP', 12, 0, 'CONGESTION', 3, '', '1545611974.96', ''),
(35, '2018-12-23 21:25:28', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000041', 'SIP/GOIP-00000042', 'Dial', 'SIP/02122423974@GOIP', 24, 0, 'CONGESTION', 3, '', '1545614728.99', ''),
(36, '2018-12-23 21:33:57', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000043', 'SIP/GOIP-00000044', 'Dial', 'SIP/02122423974@GOIP', 12, 0, 'CONGESTION', 3, '', '1545615237.102', ''),
(37, '2018-12-23 21:35:00', '"04241252039" <+584241252039>', '+584241252039', '04241280510', 'incoming', 'SIP/+584241252039-00000045', '', 'Dial', 'SIP/', 0, 0, 'FAILED', 3, '', '1545615300.105', ''),
(38, '2018-12-23 21:35:41', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000046', 'SIP/GOIP-00000047', 'Dial', 'SIP/04241280510@GOIP', 12, 0, 'CONGESTION', 3, '', '1545615341.107', ''),
(39, '2018-12-23 21:41:19', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000048', 'SIP/GOIP-00000049', 'Dial', 'SIP/04241280510@GOIP', 10, 0, 'BUSY', 3, '', '1545615679.110', ''),
(40, '2018-12-23 22:00:55', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-0000004a', 'SIP/GOIP-0000004b', 'Dial', 'SIP/04241280510@GOIP', 24, 0, 'CONGESTION', 3, '', '1545616855.113', ''),
(41, '2018-12-23 22:01:40', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-0000004c', 'SIP/GOIP-0000004d', 'Dial', 'SIP/04241280510@GOIP', 24, 0, 'NO ANSWER', 3, '', '1545616900.116', ''),
(42, '2018-12-23 22:03:51', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-0000004e', 'SIP/GOIP-0000004f', 'Dial', 'SIP/04241280510@GOIP', 19, 0, 'BUSY', 3, '', '1545617031.119', ''),
(43, '2018-12-23 22:04:37', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000050', 'SIP/GOIP-00000051', 'Dial', 'SIP/04241280510@GOIP', 28, 0, 'BUSY', 3, '', '1545617077.122', ''),
(44, '2018-12-23 22:05:48', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000052', 'SIP/GOIP-00000053', 'Dial', 'SIP/04241280510@GOIP', 13, 0, 'CONGESTION', 3, '', '1545617148.125', ''),
(45, '2018-12-23 22:07:15', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-00000054', 'SIP/GOIP-00000055', 'Dial', 'SIP/04129520025@GOIP', 15, 0, 'CONGESTION', 3, '', '1545617235.128', ''),
(46, '2018-12-23 22:07:46', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-00000056', 'SIP/GOIP-00000057', 'Dial', 'SIP/04129520025@GOIP', 71, 0, 'NO ANSWER', 3, '', '1545617266.131', ''),
(47, '2018-12-23 22:09:12', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-00000058', 'SIP/GOIP-00000059', 'Dial', 'SIP/04129520025@GOIP', 30, 0, 'NO ANSWER', 3, '', '1545617352.134', ''),
(48, '2018-12-23 22:10:07', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-0000005a', 'SIP/GOIP-0000005b', 'Dial', 'SIP/04129520025@GOIP', 0, 0, 'CONGESTION', 3, '', '1545617407.137', ''),
(49, '2018-12-23 22:10:24', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-0000005c', 'SIP/GOIP-0000005d', 'Dial', 'SIP/04129520025@GOIP', 0, 0, 'CONGESTION', 3, '', '1545617424.140', ''),
(50, '2018-12-23 22:11:12', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-0000005e', 'SIP/GOIP-0000005f', 'Dial', 'SIP/04129520025@GOIP', 30, 0, 'BUSY', 3, '', '1545617472.143', ''),
(51, '2018-12-23 22:25:51', '"04241252039" <+584241252039>', '+584241252039', '024129520025', 'incoming', 'SIP/+584241252039-00000060', 'SIP/GOIP-00000061', 'Dial', 'SIP/04129520025@GOIP', 15, 0, 'BUSY', 3, '', '1545618351.146', ''),
(52, '2018-12-23 22:26:43', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000062', 'SIP/GOIP-00000063', 'Dial', 'SIP/04241280510@GOIP', 33, 0, 'BUSY', 3, '', '1545618403.149', ''),
(53, '2018-12-23 22:31:31', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000064', 'SIP/GOIP-00000065', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545618691.152', ''),
(54, '2018-12-23 22:31:55', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000066', 'SIP/GOIP-00000067', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545618715.155', ''),
(55, '2018-12-23 22:32:08', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000068', 'SIP/GOIP-00000069', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545618728.158', ''),
(56, '2018-12-23 22:32:56', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000006a', 'SIP/GOIP-0000006b', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545618776.161', ''),
(57, '2018-12-23 22:33:06', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000006c', 'SIP/GOIP-0000006d', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545618786.164', ''),
(58, '2018-12-23 22:34:15', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-0000006e', 'SIP/GOIP-0000006f', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545618855.167', ''),
(59, '2018-12-23 22:41:09', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000070', 'SIP/GOIP-00000071', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545619269.170', ''),
(60, '2018-12-23 22:42:24', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000072', 'SIP/GOIP-00000073', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545619344.173', ''),
(61, '2018-12-23 22:43:17', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000074', 'SIP/GOIP-00000075', 'Dial', 'SIP/02122423974@GOIP', 0, 0, 'NO ANSWER', 3, '', '1545619397.176', ''),
(62, '2018-12-23 22:53:13', '"04241252039" <+584241252039>', '+584241252039', '202122423974', 'incoming', 'SIP/+584241252039-00000076', 'SIP/GOIP-00000077', 'Dial', 'SIP/02122423974@GOIP', 6, 0, 'NO ANSWER', 3, '', '1545619993.179', ''),
(63, '2018-12-23 22:53:42', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000078', 'SIP/GOIP-00000079', 'Dial', 'SIP/04241280510@GOIP', 34, 0, 'NO ANSWER', 3, '', '1545620022.182', ''),
(64, '2018-12-23 22:55:34', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-0000007a', 'SIP/GOIP-0000007b', 'Dial', 'SIP/04241280510@GOIP', 0, 0, 'CONGESTION', 3, '', '1545620134.185', ''),
(65, '2018-12-23 22:56:02', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-0000007c', 'SIP/GOIP-0000007d', 'Dial', 'SIP/04241280510@GOIP', 15, 0, 'BUSY', 3, '', '1545620162.188', ''),
(66, '2018-12-23 22:57:19', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000000', 'SIP/GOIP-00000001', 'Dial', 'SIP/04241280510@GOIP', 21, 0, 'NO ANSWER', 3, '', '1545620239.0', ''),
(67, '2018-12-23 22:57:54', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000002', 'SIP/GOIP-00000003', 'Dial', 'SIP/04241280510@GOIP', 15, 0, 'BUSY', 3, '', '1545620274.3', ''),
(68, '2018-12-23 22:58:28', '"04241252039" <+584241252039>', '+584241252039', '024241280510', 'incoming', 'SIP/+584241252039-00000004', 'SIP/GOIP-00000005', 'Dial', 'SIP/04241280510@GOIP', 64, 0, 'NO ANSWER', 3, '', '1545620308.6', ''),
(69, '2018-12-23 22:59:52', '"04241252039" <+584241252039>', '+584241252039', '024128163578', 'incoming', 'SIP/+584241252039-00000006', 'SIP/GOIP-00000007', 'Dial', 'SIP/04128163578@GOIP', 18, 0, 'BUSY', 3, '', '1545620392.9', ''),
(70, '2018-12-23 23:00:26', '"04241252039" <+584241252039>', '+584241252039', '024128163578', 'incoming', 'SIP/+584241252039-00000008', 'SIP/GOIP-00000009', 'Dial', 'SIP/04128163578@GOIP', 84, 0, 'NO ANSWER', 3, '', '1545620426.12', ''),
(71, '2018-12-25 07:57:09', '"04241252039" <+584241252039>', '+584241252039', '024128163578', 'incoming', 'SIP/+584241252039-0000000a', 'SIP/GOIP-0000000b', 'Dial', 'SIP/04128163578@GOIP', 16, 0, 'NO ANSWER', 3, '', '1545739029.15', ''),
(72, '2018-12-25 07:58:16', '"04241252039" <+584241252039>', '+584241252039', '024128163578', 'incoming', 'SIP/+584241252039-0000000c', 'SIP/GOIP-0000000d', 'Dial', 'SIP/04128163578@GOIP', 39, 6, 'ANSWERED', 3, '', '1545739096.18', ''),
(73, '2018-12-25 07:59:55', '"04241252039" <+584241252039>', '+584241252039', '202127350632', 'incoming', 'SIP/+584241252039-0000000e', 'SIP/GOIP-0000000f', 'Dial', 'SIP/02127350632@GOIP', 12, 0, 'NO ANSWER', 3, '', '1545739195.21', ''),
(74, '2018-12-25 09:05:32', '"04241252039" <+584241252039>', '+584241252039', '202127350632', 'incoming', 'SIP/+584241252039-00000010', 'SIP/GOIP-00000011', 'Dial', 'SIP/02127350632@GOIP', 29, 22, 'ANSWERED', 3, '', '1545743132.24', '');

-- --------------------------------------------------------

--
-- Table structure for table `cdr`
--

CREATE TABLE `cdr` (
  `id` int(11) NOT NULL,
  `accountcode` int(10) DEFAULT NULL,
  `src` varchar(50) DEFAULT NULL,
  `dst` varchar(50) DEFAULT NULL,
  `dcontext` varchar(50) DEFAULT NULL,
  `origin` varchar(40) DEFAULT NULL,
  `did` varchar(40) DEFAULT NULL,
  `destination` varchar(40) DEFAULT NULL,
  `clid` varchar(50) DEFAULT NULL,
  `channel` varchar(50) DEFAULT NULL,
  `dstchannel` varchar(50) DEFAULT NULL,
  `lastapp` varchar(50) DEFAULT NULL,
  `lastdata` varchar(50) DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  `answer` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `duration` int(10) DEFAULT NULL,
  `billsec` int(10) DEFAULT NULL,
  `disposition` varchar(20) DEFAULT NULL,
  `userfield` varchar(20) NOT NULL DEFAULT 'PerMinuteCHarge',
  `uniqueid` varchar(50) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `DATABASECHANGELOG`
--

CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int(11) NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `DATABASECHANGELOG`
--

INSERT INTO `DATABASECHANGELOG` (`ID`, `AUTHOR`, `FILENAME`, `DATEEXECUTED`, `ORDEREXECUTED`, `EXECTYPE`, `MD5SUM`, `DESCRIPTION`, `COMMENTS`, `TAG`, `LIQUIBASE`, `CONTEXTS`, `LABELS`, `DEPLOYMENT_ID`) VALUES
('00000000000001', 'jhipster', 'config/liquibase/changelog/00000000000000_initial_schema.xml', '2018-11-27 08:21:06', 1, 'EXECUTED', '7:8eef49fe9846cf127a6c088e3d850cb0', 'createTable tableName=jhi_user; createTable tableName=jhi_authority; createTable tableName=jhi_user_authority; addPrimaryKey tableName=jhi_user_authority; addForeignKeyConstraint baseTableName=jhi_user_authority, constraintName=fk_authority_name, ...', '', NULL, '3.5.4', NULL, NULL, '3321237356'),
('20181126154019-1', 'jhipster', 'config/liquibase/changelog/20181126154019_added_entity_SipPeer.xml', '2018-11-27 08:21:07', 2, 'EXECUTED', '7:83e4cf315ec37d2263b7e731b996e1d6', 'createTable tableName=sip_peer', '', NULL, '3.5.4', NULL, NULL, '3321237356'),
('20181126191242-1', 'jhipster', 'config/liquibase/changelog/20181126191242_added_entity_DialPlan.xml', '2018-11-27 08:21:09', 3, 'EXECUTED', '7:0a7eaa93c2ae0e206be7132d4e092349', 'createTable tableName=dial_plan', '', NULL, '3.5.4', NULL, NULL, '3321237356'),
('20181126191242-2', 'jhipster', 'config/liquibase/changelog/20181126191242_added_entity_constraints_DialPlan.xml', '2018-11-27 08:21:13', 4, 'EXECUTED', '7:0cf895da5dc497251d5bbb6c82633eac', 'addForeignKeyConstraint baseTableName=dial_plan, constraintName=fk_dial_plan_sip_peer_id, referencedTableName=sip_peer', '', NULL, '3.5.4', NULL, NULL, '3321237356');

-- --------------------------------------------------------

--
-- Table structure for table `DATABASECHANGELOGLOCK`
--

CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int(11) NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `DATABASECHANGELOGLOCK`
--

INSERT INTO `DATABASECHANGELOGLOCK` (`ID`, `LOCKED`, `LOCKGRANTED`, `LOCKEDBY`) VALUES
(1, b'1', '2018-11-27 11:25:02', '192.168.1.108 (192.168.1.108)');

-- --------------------------------------------------------

--
-- Table structure for table `dial_plan`
--

CREATE TABLE `dial_plan` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `prefix` varchar(255) DEFAULT NULL,
  `digit_cut` varchar(255) DEFAULT NULL,
  `preceding` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `gateway_id` bigint(20) DEFAULT NULL,
  `jhi_limit` int(11) DEFAULT NULL,
  `status` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dial_plan`
--

INSERT INTO `dial_plan` (`id`, `name`, `description`, `prefix`, `digit_cut`, `preceding`, `priority`, `gateway_id`, `jhi_limit`, `status`) VALUES
(2, 'Venezuela', 'Venezuela-Fijo', '20', '2', '0', 1, 2, 10, b'1'),
(3, 'Venezuela', 'Venezuela-Movil', '024', '2', '0', 1, 2, 10, b'1'),
(4, 'Nigerian', 'Main Route to Nigerian', '523234', '3', '00', 1, 2, 10, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `gateway`
--

CREATE TABLE `gateway` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `ipaddr` varchar(45) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `regseconds` int(11) DEFAULT NULL,
  `defaultuser` varchar(40) DEFAULT NULL,
  `fullcontact` varchar(80) DEFAULT NULL,
  `regserver` varchar(20) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` int(11) DEFAULT NULL,
  `host` varchar(40) DEFAULT NULL,
  `type` enum('friend','user','peer') DEFAULT NULL,
  `context` varchar(40) DEFAULT NULL,
  `permit` varchar(95) DEFAULT NULL,
  `deny` varchar(95) DEFAULT NULL,
  `secret` varchar(40) DEFAULT NULL,
  `md5secret` varchar(40) DEFAULT NULL,
  `remotesecret` varchar(40) DEFAULT NULL,
  `transport` enum('udp','tcp','tls','ws','wss','udp,tcp','tcp,udp') DEFAULT NULL,
  `dtmfmode` enum('rfc2833','info','shortinfo','inband','auto') DEFAULT NULL,
  `directmedia` enum('yes','no','nonat','update') DEFAULT NULL,
  `nat` varchar(29) DEFAULT NULL,
  `callgroup` varchar(40) DEFAULT NULL,
  `pickupgroup` varchar(40) DEFAULT NULL,
  `language` varchar(40) DEFAULT NULL,
  `disallow` varchar(200) DEFAULT NULL,
  `allow` varchar(200) DEFAULT NULL,
  `insecure` varchar(40) DEFAULT NULL,
  `trustrpid` enum('yes','no') DEFAULT NULL,
  `progressinband` enum('yes','no','never') DEFAULT NULL,
  `promiscredir` enum('yes','no') DEFAULT NULL,
  `useclientcode` enum('yes','no') DEFAULT NULL,
  `accountcode` varchar(40) DEFAULT NULL,
  `setvar` varchar(200) DEFAULT NULL,
  `callerid` varchar(40) DEFAULT NULL,
  `amaflags` varchar(40) DEFAULT NULL,
  `callcounter` enum('yes','no') DEFAULT NULL,
  `busylevel` int(11) DEFAULT NULL,
  `allowoverlap` enum('yes','no') DEFAULT NULL,
  `allowsubscribe` enum('yes','no') DEFAULT NULL,
  `videosupport` enum('yes','no') DEFAULT NULL,
  `maxcallbitrate` int(11) DEFAULT NULL,
  `rfc2833compensate` enum('yes','no') DEFAULT NULL,
  `mailbox` varchar(40) DEFAULT NULL,
  `session-timers` enum('accept','refuse','originate') DEFAULT NULL,
  `session-expires` int(11) DEFAULT NULL,
  `session-minse` int(11) DEFAULT NULL,
  `session-refresher` enum('uac','uas') DEFAULT NULL,
  `t38pt_usertpsource` varchar(40) DEFAULT NULL,
  `regexten` varchar(40) DEFAULT NULL,
  `fromdomain` varchar(40) DEFAULT NULL,
  `fromuser` varchar(40) DEFAULT NULL,
  `qualify` varchar(40) DEFAULT NULL,
  `defaultip` varchar(45) DEFAULT NULL,
  `rtptimeout` int(11) DEFAULT NULL,
  `rtpholdtimeout` int(11) DEFAULT NULL,
  `sendrpid` enum('yes','no') DEFAULT NULL,
  `outboundproxy` varchar(40) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `timert1` int(11) DEFAULT NULL,
  `timerb` int(11) DEFAULT NULL,
  `qualifyfreq` int(11) DEFAULT NULL,
  `constantssrc` enum('yes','no') DEFAULT NULL,
  `contactpermit` varchar(95) DEFAULT NULL,
  `contactdeny` varchar(95) DEFAULT NULL,
  `usereqphone` enum('yes','no') DEFAULT NULL,
  `textsupport` enum('yes','no') DEFAULT NULL,
  `faxdetect` enum('yes','no') DEFAULT NULL,
  `buggymwi` enum('yes','no') DEFAULT NULL,
  `auth` varchar(40) DEFAULT NULL,
  `fullname` varchar(40) DEFAULT NULL,
  `trunkname` varchar(40) DEFAULT NULL,
  `cid_number` varchar(40) DEFAULT NULL,
  `callingpres` enum('allowed_not_screened','allowed_passed_screen','allowed_failed_screen','allowed','prohib_not_screened','prohib_passed_screen','prohib_failed_screen','prohib') DEFAULT NULL,
  `mohinterpret` varchar(40) DEFAULT NULL,
  `mohsuggest` varchar(40) DEFAULT NULL,
  `parkinglot` varchar(40) DEFAULT NULL,
  `hasvoicemail` enum('yes','no') DEFAULT NULL,
  `subscribemwi` enum('yes','no') DEFAULT NULL,
  `vmexten` varchar(40) DEFAULT NULL,
  `autoframing` enum('yes','no') DEFAULT NULL,
  `rtpkeepalive` int(11) DEFAULT NULL,
  `call-limit` int(11) DEFAULT NULL,
  `g726nonstandard` enum('yes','no') DEFAULT NULL,
  `ignoresdpversion` enum('yes','no') DEFAULT NULL,
  `allowtransfer` enum('yes','no') DEFAULT NULL,
  `dynamic` enum('yes','no') DEFAULT NULL,
  `path` varchar(256) DEFAULT NULL,
  `supportpath` enum('yes','no') DEFAULT NULL,
  `cancallforward` varchar(80) DEFAULT NULL,
  `canreinvite` varchar(80) DEFAULT NULL,
  `jhi_deny` varchar(255) DEFAULT NULL,
  `jhi_type` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  `musiconhold` varchar(255) DEFAULT NULL,
  `restrictcid` enum('YES,NO') DEFAULT NULL,
  `subscribecontext` varchar(255) DEFAULT NULL,
  `sip_peer` bit(1) DEFAULT b'1',
  `status` bit(1) DEFAULT b'1',
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gateway`
--

INSERT INTO `gateway` (`id`, `name`, `ipaddr`, `port`, `regseconds`, `defaultuser`, `fullcontact`, `regserver`, `useragent`, `lastms`, `host`, `type`, `context`, `permit`, `deny`, `secret`, `md5secret`, `remotesecret`, `transport`, `dtmfmode`, `directmedia`, `nat`, `callgroup`, `pickupgroup`, `language`, `disallow`, `allow`, `insecure`, `trustrpid`, `progressinband`, `promiscredir`, `useclientcode`, `accountcode`, `setvar`, `callerid`, `amaflags`, `callcounter`, `busylevel`, `allowoverlap`, `allowsubscribe`, `videosupport`, `maxcallbitrate`, `rfc2833compensate`, `mailbox`, `session-timers`, `session-expires`, `session-minse`, `session-refresher`, `t38pt_usertpsource`, `regexten`, `fromdomain`, `fromuser`, `qualify`, `defaultip`, `rtptimeout`, `rtpholdtimeout`, `sendrpid`, `outboundproxy`, `callbackextension`, `timert1`, `timerb`, `qualifyfreq`, `constantssrc`, `contactpermit`, `contactdeny`, `usereqphone`, `textsupport`, `faxdetect`, `buggymwi`, `auth`, `fullname`, `trunkname`, `cid_number`, `callingpres`, `mohinterpret`, `mohsuggest`, `parkinglot`, `hasvoicemail`, `subscribemwi`, `vmexten`, `autoframing`, `rtpkeepalive`, `call-limit`, `g726nonstandard`, `ignoresdpversion`, `allowtransfer`, `dynamic`, `path`, `supportpath`, `cancallforward`, `canreinvite`, `jhi_deny`, `jhi_type`, `mask`, `musiconhold`, `restrictcid`, `subscribecontext`, `sip_peer`, `status`, `username`) VALUES
(2, 'Main_Gateway', NULL, NULL, NULL, '20073192254', NULL, NULL, NULL, NULL, '200.73.192.254', 'friend', 'outgoing', NULL, NULL, '1234', NULL, NULL, NULL, NULL, NULL, 'yes', NULL, NULL, NULL, NULL, 'g729,g721', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, b'1', b'1', '20073192254');

-- --------------------------------------------------------

--
-- Table structure for table `gateway_old`
--

CREATE TABLE `gateway_old` (
  `id` bigint(20) NOT NULL,
  `name` varchar(80) NOT NULL DEFAULT '',
  `host` varchar(31) NOT NULL DEFAULT '',
  `nat` varchar(20) NOT NULL DEFAULT 'force_rport',
  `type` enum('user','peer','friend') DEFAULT 'friend',
  `accountcode` varchar(20) DEFAULT NULL,
  `amaflags` varchar(13) DEFAULT NULL,
  `jhi_type` varchar(255) DEFAULT NULL,
  `jhi_deny` varchar(255) DEFAULT NULL,
  `call-limit` smallint(5) UNSIGNED DEFAULT NULL,
  `callgroup` varchar(10) DEFAULT NULL,
  `callerid` varchar(80) DEFAULT NULL,
  `cancallforward` char(3) DEFAULT 'yes',
  `canreinvite` char(3) DEFAULT 'yes',
  `context` varchar(80) DEFAULT NULL,
  `defaultip` varchar(15) DEFAULT NULL,
  `dtmfmode` varchar(7) DEFAULT NULL,
  `fromuser` varchar(80) DEFAULT NULL,
  `fromdomain` varchar(80) DEFAULT NULL,
  `insecure` varchar(4) DEFAULT NULL,
  `language` char(2) DEFAULT NULL,
  `mailbox` varchar(50) DEFAULT NULL,
  `md5secret` varchar(80) DEFAULT NULL,
  `deny` varchar(95) DEFAULT NULL,
  `permit` varchar(95) DEFAULT NULL,
  `mask` varchar(95) DEFAULT NULL,
  `musiconhold` varchar(100) DEFAULT NULL,
  `pickupgroup` varchar(10) DEFAULT NULL,
  `qualify` char(3) DEFAULT NULL,
  `regexten` varchar(80) DEFAULT NULL,
  `restrictcid` char(3) DEFAULT NULL,
  `rtptimeout` char(3) DEFAULT NULL,
  `rtpholdtimeout` char(3) DEFAULT NULL,
  `secret` varchar(80) DEFAULT NULL,
  `setvar` varchar(100) DEFAULT NULL,
  `disallow` varchar(100) DEFAULT 'all',
  `allow` varchar(100) DEFAULT 'g729;ilbc;gsm;ulaw;alaw',
  `fullcontact` varchar(80) DEFAULT NULL,
  `ipaddr` varchar(15) DEFAULT NULL,
  `port` smallint(5) UNSIGNED DEFAULT '0',
  `regserver` varchar(100) DEFAULT NULL,
  `regseconds` int(11) DEFAULT '0',
  `lastms` int(11) DEFAULT '0',
  `username` varchar(80) NOT NULL DEFAULT '',
  `defaultuser` varchar(80) DEFAULT NULL,
  `subscribecontext` varchar(80) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `status` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `gateway_old`
--

INSERT INTO `gateway_old` (`id`, `name`, `host`, `nat`, `type`, `accountcode`, `amaflags`, `jhi_type`, `jhi_deny`, `call-limit`, `callgroup`, `callerid`, `cancallforward`, `canreinvite`, `context`, `defaultip`, `dtmfmode`, `fromuser`, `fromdomain`, `insecure`, `language`, `mailbox`, `md5secret`, `deny`, `permit`, `mask`, `musiconhold`, `pickupgroup`, `qualify`, `regexten`, `restrictcid`, `rtptimeout`, `rtpholdtimeout`, `secret`, `setvar`, `disallow`, `allow`, `fullcontact`, `ipaddr`, `port`, `regserver`, `regseconds`, `lastms`, `username`, `defaultuser`, `subscribecontext`, `useragent`, `status`) VALUES
(2, 'Main_Gateway', '200.73.192.254', 'force_rport', 'peer', NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', NULL, NULL, 'g729,g711', NULL, NULL, NULL, NULL, NULL, NULL, '200.73.192.254', NULL, NULL, NULL, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `jhi_authority`
--

CREATE TABLE `jhi_authority` (
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jhi_authority`
--

INSERT INTO `jhi_authority` (`name`) VALUES
('ROLE_ADMIN'),
('ROLE_USER');

-- --------------------------------------------------------

--
-- Table structure for table `jhi_persistent_audit_event`
--

CREATE TABLE `jhi_persistent_audit_event` (
  `event_id` bigint(20) NOT NULL,
  `principal` varchar(50) NOT NULL,
  `event_date` timestamp NULL DEFAULT NULL,
  `event_type` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jhi_persistent_audit_event`
--

INSERT INTO `jhi_persistent_audit_event` (`event_id`, `principal`, `event_date`, `event_type`) VALUES
(1, 'admin', '2018-11-27 16:21:50', 'AUTHENTICATION_SUCCESS'),
(2, 'admin', '2018-11-27 22:58:52', 'AUTHENTICATION_SUCCESS'),
(3, 'admin', '2018-11-28 00:39:20', 'AUTHENTICATION_SUCCESS'),
(4, 'admin', '2018-11-28 05:10:23', 'AUTHENTICATION_SUCCESS'),
(5, 'admin', '2018-11-30 01:51:21', 'AUTHENTICATION_SUCCESS'),
(6, 'admin', '2018-11-30 05:36:40', 'AUTHENTICATION_SUCCESS'),
(7, 'admin', '2018-11-30 18:21:12', 'AUTHENTICATION_SUCCESS'),
(8, 'admin', '2018-11-30 18:22:35', 'AUTHENTICATION_SUCCESS'),
(9, 'user', '2018-11-30 18:32:09', 'AUTHENTICATION_SUCCESS'),
(10, 'admin', '2018-11-30 18:36:08', 'AUTHENTICATION_SUCCESS'),
(11, 'admin', '2018-12-03 13:39:35', 'AUTHENTICATION_SUCCESS'),
(12, 'admin', '2018-12-03 13:43:16', 'AUTHENTICATION_SUCCESS'),
(13, 'admin', '2018-12-03 17:38:34', 'AUTHENTICATION_SUCCESS'),
(14, 'admin', '2018-12-03 19:05:55', 'AUTHENTICATION_SUCCESS'),
(15, 'admin', '2018-12-04 19:07:32', 'AUTHENTICATION_SUCCESS'),
(16, 'admin', '2018-12-05 22:57:13', 'AUTHENTICATION_SUCCESS'),
(17, 'admin', '2018-12-06 01:11:05', 'AUTHENTICATION_SUCCESS'),
(18, 'admin', '2018-12-06 18:32:33', 'AUTHENTICATION_SUCCESS'),
(19, 'admin', '2018-12-06 19:22:13', 'AUTHENTICATION_SUCCESS'),
(20, 'admin', '2018-12-07 00:10:37', 'AUTHENTICATION_SUCCESS'),
(21, 'admin', '2018-12-07 00:10:38', 'AUTHENTICATION_SUCCESS'),
(22, 'admin', '2018-12-15 00:59:49', 'AUTHENTICATION_SUCCESS'),
(23, 'admin', '2018-12-15 01:36:54', 'AUTHENTICATION_SUCCESS'),
(24, 'admin', '2018-12-15 01:42:26', 'AUTHENTICATION_SUCCESS'),
(25, 'admin', '2018-12-15 19:45:43', 'AUTHENTICATION_SUCCESS'),
(26, 'admin', '2018-12-15 22:01:38', 'AUTHENTICATION_SUCCESS'),
(27, 'admin', '2018-12-15 22:29:23', 'AUTHENTICATION_SUCCESS'),
(28, 'admin', '2018-12-15 22:34:52', 'AUTHENTICATION_SUCCESS'),
(29, 'admin', '2018-12-15 22:35:22', 'AUTHENTICATION_SUCCESS'),
(30, 'admin', '2018-12-15 22:35:51', 'AUTHENTICATION_SUCCESS'),
(31, 'admin', '2018-12-15 22:39:46', 'AUTHENTICATION_SUCCESS'),
(32, 'admin', '2018-12-15 22:47:01', 'AUTHENTICATION_SUCCESS'),
(33, 'admin', '2018-12-15 22:58:34', 'AUTHENTICATION_SUCCESS'),
(34, 'admin', '2018-12-15 23:00:11', 'AUTHENTICATION_SUCCESS'),
(35, 'admin', '2018-12-16 17:54:02', 'AUTHENTICATION_SUCCESS'),
(36, 'admin', '2018-12-16 17:57:30', 'AUTHENTICATION_SUCCESS'),
(37, 'admin', '2018-12-16 18:01:55', 'AUTHENTICATION_SUCCESS'),
(38, 'admin', '2018-12-17 13:19:24', 'AUTHENTICATION_SUCCESS'),
(39, 'admin', '2018-12-17 13:25:03', 'AUTHENTICATION_SUCCESS'),
(40, 'admin', '2018-12-17 15:33:28', 'AUTHENTICATION_SUCCESS'),
(41, 'admin', '2018-12-18 03:26:25', 'AUTHENTICATION_SUCCESS'),
(42, 'admin', '2018-12-20 04:43:11', 'AUTHENTICATION_SUCCESS'),
(43, 'admin', '2018-12-20 04:47:17', 'AUTHENTICATION_SUCCESS'),
(44, 'admin', '2018-12-23 17:34:33', 'AUTHENTICATION_SUCCESS'),
(45, 'admin', '2018-12-25 17:19:51', 'AUTHENTICATION_SUCCESS'),
(46, 'admin', '2018-12-25 23:59:43', 'AUTHENTICATION_SUCCESS'),
(47, 'admin', '2018-12-26 00:51:25', 'AUTHENTICATION_SUCCESS'),
(48, 'admin', '2018-12-26 03:04:48', 'AUTHENTICATION_SUCCESS'),
(57, 'wrong-user', '2018-12-28 12:38:36', 'AUTHENTICATION_FAILURE'),
(58, 'user-jwt-controller-remember-me', '2018-12-28 12:38:36', 'AUTHENTICATION_SUCCESS'),
(59, 'user-jwt-controller', '2018-12-28 12:38:37', 'AUTHENTICATION_SUCCESS'),
(60, 'admin', '2018-12-28 19:32:06', 'AUTHENTICATION_FAILURE'),
(61, 'admin', '2018-12-28 19:51:08', 'AUTHENTICATION_SUCCESS'),
(62, 'admin', '2018-12-28 21:26:21', 'AUTHENTICATION_SUCCESS'),
(63, 'admin', '2018-12-29 02:00:59', 'AUTHENTICATION_SUCCESS'),
(64, 'admin', '2018-12-29 02:37:33', 'AUTHENTICATION_SUCCESS'),
(65, 'admin', '2018-12-30 02:15:57', 'AUTHENTICATION_SUCCESS'),
(66, 'admin', '2018-12-30 04:53:36', 'AUTHENTICATION_SUCCESS'),
(67, 'admin', '2019-01-01 22:20:19', 'AUTHENTICATION_FAILURE'),
(68, 'admin', '2019-01-01 22:20:20', 'AUTHENTICATION_FAILURE'),
(69, 'admin', '2019-01-02 03:24:55', 'AUTHENTICATION_SUCCESS'),
(70, 'admin', '2019-01-02 22:08:33', 'AUTHENTICATION_SUCCESS'),
(71, 'admin', '2019-01-03 07:05:56', 'AUTHENTICATION_SUCCESS'),
(72, 'admin', '2019-01-03 07:05:57', 'AUTHENTICATION_SUCCESS'),
(73, 'admin', '2019-01-03 07:25:45', 'AUTHENTICATION_SUCCESS'),
(74, 'admin', '2019-01-03 07:40:37', 'AUTHENTICATION_SUCCESS'),
(75, 'admin', '2019-01-03 07:41:56', 'AUTHENTICATION_SUCCESS'),
(76, 'admin', '2019-01-03 07:57:02', 'AUTHENTICATION_SUCCESS'),
(77, 'admin', '2019-01-03 08:12:05', 'AUTHENTICATION_SUCCESS'),
(78, 'admin', '2019-01-03 08:12:05', 'AUTHENTICATION_SUCCESS'),
(79, 'admin', '2019-01-04 21:34:29', 'AUTHENTICATION_SUCCESS'),
(80, 'admin', '2019-01-05 00:30:19', 'AUTHENTICATION_SUCCESS'),
(81, 'admin', '2019-01-05 02:32:08', 'AUTHENTICATION_SUCCESS'),
(82, 'admin', '2019-01-05 23:54:40', 'AUTHENTICATION_SUCCESS'),
(83, 'admin', '2019-01-07 05:03:15', 'AUTHENTICATION_SUCCESS'),
(84, 'admin', '2019-01-07 22:32:29', 'AUTHENTICATION_SUCCESS'),
(85, 'admin', '2019-01-08 01:46:49', 'AUTHENTICATION_SUCCESS'),
(86, 'admin', '2019-01-08 05:21:03', 'AUTHENTICATION_SUCCESS'),
(87, 'admin', '2019-01-08 18:22:42', 'AUTHENTICATION_SUCCESS'),
(88, 'admin', '2019-01-10 20:17:49', 'AUTHENTICATION_SUCCESS'),
(89, 'admin', '2019-01-12 00:59:51', 'AUTHENTICATION_SUCCESS'),
(90, 'admin', '2019-01-15 05:35:14', 'AUTHENTICATION_SUCCESS'),
(91, 'admin', '2019-01-17 06:01:53', 'AUTHENTICATION_SUCCESS'),
(92, 'admin', '2019-01-18 04:36:32', 'AUTHENTICATION_SUCCESS'),
(93, 'admin', '2019-01-19 18:55:31', 'AUTHENTICATION_SUCCESS'),
(94, 'admin', '2019-01-19 20:01:21', 'AUTHENTICATION_SUCCESS'),
(95, 'admin', '2019-01-19 21:06:36', 'AUTHENTICATION_SUCCESS'),
(96, 'admin', '2019-01-19 21:29:29', 'AUTHENTICATION_SUCCESS'),
(97, 'admin', '2019-01-20 19:54:04', 'AUTHENTICATION_SUCCESS'),
(98, 'admin', '2019-01-20 20:45:26', 'AUTHENTICATION_SUCCESS'),
(99, 'admin', '2019-01-20 20:47:14', 'AUTHENTICATION_SUCCESS'),
(100, 'admin', '2019-01-22 14:24:29', 'AUTHENTICATION_SUCCESS');

-- --------------------------------------------------------

--
-- Table structure for table `jhi_persistent_audit_evt_data`
--

CREATE TABLE `jhi_persistent_audit_evt_data` (
  `event_id` bigint(20) NOT NULL,
  `name` varchar(150) NOT NULL,
  `value` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jhi_persistent_audit_evt_data`
--

INSERT INTO `jhi_persistent_audit_evt_data` (`event_id`, `name`, `value`) VALUES
(57, 'message', 'Bad credentials'),
(57, 'type', 'org.springframework.security.authentication.BadCredentialsException'),
(60, 'message', 'Bad credentials'),
(60, 'type', 'org.springframework.security.authentication.BadCredentialsException'),
(67, 'message', 'Bad credentials'),
(67, 'type', 'org.springframework.security.authentication.BadCredentialsException'),
(68, 'message', 'Bad credentials'),
(68, 'type', 'org.springframework.security.authentication.BadCredentialsException');

-- --------------------------------------------------------

--
-- Table structure for table `jhi_user`
--

CREATE TABLE `jhi_user` (
  `id` bigint(20) NOT NULL,
  `login` varchar(50) NOT NULL,
  `password_hash` varchar(60) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `activated` bit(1) NOT NULL,
  `lang_key` varchar(6) DEFAULT NULL,
  `activation_key` varchar(20) DEFAULT NULL,
  `reset_key` varchar(20) DEFAULT NULL,
  `created_by` varchar(50) NOT NULL,
  `created_date` timestamp NULL DEFAULT NULL,
  `reset_date` timestamp NULL DEFAULT NULL,
  `last_modified_by` varchar(50) DEFAULT NULL,
  `last_modified_date` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jhi_user`
--

INSERT INTO `jhi_user` (`id`, `login`, `password_hash`, `first_name`, `last_name`, `email`, `image_url`, `activated`, `lang_key`, `activation_key`, `reset_key`, `created_by`, `created_date`, `reset_date`, `last_modified_by`, `last_modified_date`) VALUES
(1, 'system', '$2a$10$mE.qmcV0mFU5NcKh73TZx.z4ueI/.bDWbj0T1BYyqP481kGGarKLG', 'System', 'System', 'system@localhost', '', b'1', 'en', NULL, NULL, 'system', NULL, NULL, 'admin', '2018-11-28 00:59:03'),
(2, 'anonymoususer', '$2a$10$j8S5d7Sr7.8VTOYNviDPOeWX8KcYILUVJBsYV83Y5NtECayypx9lO', 'Anonymous', 'User', 'anonymous@localhost', '', b'1', 'en', NULL, NULL, 'system', NULL, NULL, 'system', NULL),
(3, 'admin', '$2a$10$OwcUnKrCggQ8ffdmTRnmOOh2tARKnxK.KNC2Xa2BVctTju3qrVY.G', 'Administrator', 'Administrator', 'nestor.e.s.m@gmail.com', '', b'1', 'en', NULL, NULL, 'system', NULL, NULL, 'anonymousUser', '2018-12-28 19:50:51'),
(4, 'user', '$2a$10$VEjxo0jq2YG9Rbk2HmX9S.k1uZBGYUHdUcid3g/vfiEl7lwWgOH/K', 'User', 'User', 'user@localhost', '', b'1', 'en', NULL, NULL, 'system', NULL, NULL, 'system', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jhi_user_authority`
--

CREATE TABLE `jhi_user_authority` (
  `user_id` bigint(20) NOT NULL,
  `authority_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `jhi_user_authority`
--

INSERT INTO `jhi_user_authority` (`user_id`, `authority_name`) VALUES
(1, 'ROLE_ADMIN'),
(3, 'ROLE_ADMIN'),
(1, 'ROLE_USER'),
(3, 'ROLE_USER'),
(4, 'ROLE_USER');

-- --------------------------------------------------------

--
-- Table structure for table `sip_peer`
--

CREATE TABLE `sip_peer` (
  `id` bigint(20) NOT NULL,
  `name` varchar(40) NOT NULL,
  `ipaddr` varchar(45) DEFAULT NULL,
  `port` varchar(11) DEFAULT NULL,
  `regseconds` int(11) DEFAULT NULL,
  `defaultuser` varchar(40) DEFAULT NULL,
  `regserver` varchar(20) DEFAULT NULL,
  `useragent` varchar(20) DEFAULT NULL,
  `lastms` int(11) DEFAULT NULL,
  `host` varchar(40) DEFAULT NULL,
  `type` enum('friend','user','peer') DEFAULT NULL,
  `context` varchar(40) DEFAULT NULL,
  `permit` varchar(95) DEFAULT NULL,
  `deny` varchar(95) DEFAULT NULL,
  `secret` varchar(40) DEFAULT NULL,
  `md5secret` varchar(40) DEFAULT NULL,
  `remotesecret` varchar(40) DEFAULT NULL,
  `transport` enum('udp','tcp','tls','ws','wss','udp,tcp','tcp,udp') DEFAULT NULL,
  `dtmfmode` enum('rfc2833','info','shortinfo','inband','auto') DEFAULT NULL,
  `directmedia` enum('yes','no','nonat','update') DEFAULT NULL,
  `nat` varchar(29) DEFAULT NULL,
  `callgroup` varchar(40) DEFAULT NULL,
  `pickupgroup` varchar(40) DEFAULT NULL,
  `language` varchar(40) DEFAULT NULL,
  `disallow` varchar(200) DEFAULT NULL,
  `allow` varchar(200) DEFAULT NULL,
  `insecure` varchar(40) DEFAULT NULL,
  `trustrpid` enum('yes','no') DEFAULT NULL,
  `progressinband` enum('yes','no','never') DEFAULT NULL,
  `promiscredir` enum('yes','no') DEFAULT NULL,
  `useclientcode` enum('yes','no') DEFAULT NULL,
  `accountcode` varchar(40) DEFAULT NULL,
  `setvar` varchar(200) DEFAULT NULL,
  `callerid` varchar(40) DEFAULT NULL,
  `amaflags` varchar(40) DEFAULT NULL,
  `callcounter` enum('yes','no') DEFAULT NULL,
  `busylevel` int(11) DEFAULT NULL,
  `allowoverlap` enum('yes','no') DEFAULT NULL,
  `allowsubscribe` enum('yes','no') DEFAULT NULL,
  `videosupport` enum('yes','no') DEFAULT NULL,
  `maxcallbitrate` int(11) DEFAULT NULL,
  `rfc2833compensate` enum('yes','no') DEFAULT NULL,
  `mailbox` varchar(40) DEFAULT NULL,
  `session-timers` enum('accept','refuse','originate') DEFAULT NULL,
  `session-expires` int(11) DEFAULT NULL,
  `session-minse` int(11) DEFAULT NULL,
  `session-refresher` enum('uac','uas') DEFAULT NULL,
  `t38pt_usertpsource` varchar(40) DEFAULT NULL,
  `regexten` varchar(40) DEFAULT NULL,
  `fromdomain` varchar(40) DEFAULT NULL,
  `fromuser` varchar(40) DEFAULT NULL,
  `qualify` varchar(40) DEFAULT NULL,
  `defaultip` varchar(45) DEFAULT NULL,
  `rtptimeout` int(11) DEFAULT NULL,
  `rtpholdtimeout` int(11) DEFAULT NULL,
  `sendrpid` enum('yes','no') DEFAULT NULL,
  `outboundproxy` varchar(40) DEFAULT NULL,
  `callbackextension` varchar(40) DEFAULT NULL,
  `timert1` int(11) DEFAULT NULL,
  `timerb` int(11) DEFAULT NULL,
  `qualifyfreq` int(11) DEFAULT NULL,
  `constantssrc` enum('yes','no') DEFAULT NULL,
  `contactpermit` varchar(95) DEFAULT NULL,
  `contactdeny` varchar(95) DEFAULT NULL,
  `usereqphone` enum('yes','no') DEFAULT NULL,
  `textsupport` enum('yes','no') DEFAULT NULL,
  `faxdetect` enum('yes','no') DEFAULT NULL,
  `buggymwi` enum('yes','no') DEFAULT NULL,
  `auth` varchar(40) DEFAULT NULL,
  `fullname` varchar(40) DEFAULT NULL,
  `trunkname` varchar(40) DEFAULT NULL,
  `cid_number` varchar(40) DEFAULT NULL,
  `callingpres` enum('allowed_not_screened','allowed_passed_screen','allowed_failed_screen','allowed','prohib_not_screened','prohib_passed_screen','prohib_failed_screen','prohib') DEFAULT NULL,
  `mohinterpret` varchar(40) DEFAULT NULL,
  `mohsuggest` varchar(40) DEFAULT NULL,
  `parkinglot` varchar(40) DEFAULT NULL,
  `hasvoicemail` enum('yes','no') DEFAULT NULL,
  `subscribemwi` enum('yes','no') DEFAULT NULL,
  `vmexten` varchar(40) DEFAULT NULL,
  `autoframing` enum('yes','no') DEFAULT NULL,
  `rtpkeepalive` int(11) DEFAULT NULL,
  `call-limit` int(11) DEFAULT NULL,
  `g726nonstandard` enum('yes','no') DEFAULT NULL,
  `ignoresdpversion` enum('yes','no') DEFAULT NULL,
  `allowtransfer` enum('yes','no') DEFAULT NULL,
  `dynamic` enum('yes','no') DEFAULT NULL,
  `path` varchar(256) DEFAULT NULL,
  `supportpath` enum('yes','no') DEFAULT NULL,
  `cancallforward` varchar(80) DEFAULT NULL,
  `canreinvite` varchar(80) DEFAULT NULL,
  `jhi_deny` varchar(255) DEFAULT NULL,
  `jhi_type` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  `musiconhold` varchar(255) DEFAULT NULL,
  `restrictcid` enum('YES,NO') DEFAULT NULL,
  `subscribecontext` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `status` bit(1) DEFAULT b'1',
  `peer_type` enum('CARRIER','GATEWAY') DEFAULT NULL,
  `rtcachefriends` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sip_peer`
--

INSERT INTO `sip_peer` (`id`, `name`, `ipaddr`, `port`, `regseconds`, `defaultuser`, `regserver`, `useragent`, `lastms`, `host`, `type`, `context`, `permit`, `deny`, `secret`, `md5secret`, `remotesecret`, `transport`, `dtmfmode`, `directmedia`, `nat`, `callgroup`, `pickupgroup`, `language`, `disallow`, `allow`, `insecure`, `trustrpid`, `progressinband`, `promiscredir`, `useclientcode`, `accountcode`, `setvar`, `callerid`, `amaflags`, `callcounter`, `busylevel`, `allowoverlap`, `allowsubscribe`, `videosupport`, `maxcallbitrate`, `rfc2833compensate`, `mailbox`, `session-timers`, `session-expires`, `session-minse`, `session-refresher`, `t38pt_usertpsource`, `regexten`, `fromdomain`, `fromuser`, `qualify`, `defaultip`, `rtptimeout`, `rtpholdtimeout`, `sendrpid`, `outboundproxy`, `callbackextension`, `timert1`, `timerb`, `qualifyfreq`, `constantssrc`, `contactpermit`, `contactdeny`, `usereqphone`, `textsupport`, `faxdetect`, `buggymwi`, `auth`, `fullname`, `trunkname`, `cid_number`, `callingpres`, `mohinterpret`, `mohsuggest`, `parkinglot`, `hasvoicemail`, `subscribemwi`, `vmexten`, `autoframing`, `rtpkeepalive`, `call-limit`, `g726nonstandard`, `ignoresdpversion`, `allowtransfer`, `dynamic`, `path`, `supportpath`, `cancallforward`, `canreinvite`, `jhi_deny`, `jhi_type`, `mask`, `musiconhold`, `restrictcid`, `subscribecontext`, `username`, `status`, `peer_type`, `rtcachefriends`) VALUES
(2, 'GOIP', '200.73.192.254', '32568', 1546959218, NULL, '', 'dble', 0, 'dynamic', 'friend', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'no', 'force_rport,comedia', NULL, NULL, NULL, NULL, 'ulaw,alaw', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'friend', NULL, NULL, NULL, NULL, 'GOIP', b'1', 'GATEWAY', NULL),
(3, 'VPN-Machine', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '41.221.168.170', 'peer', 'incoming', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'no', 'force_rport', NULL, NULL, NULL, NULL, 'g729,ulaw,alaw', 'port,invite', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'VPN-Machine', b'1', 'CARRIER', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sip_peer_old`
--

CREATE TABLE `sip_peer_old` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `host` varchar(255) DEFAULT NULL,
  `nat` varchar(255) DEFAULT NULL,
  `jhi_type` varchar(255) DEFAULT NULL,
  `accountcode` varchar(255) DEFAULT NULL,
  `amaflags` varchar(255) DEFAULT NULL,
  `call-limit` int(11) DEFAULT NULL,
  `callgroup` varchar(255) DEFAULT NULL,
  `callerid` varchar(255) DEFAULT NULL,
  `cancallforward` varchar(255) DEFAULT NULL,
  `canreinvite` varchar(255) DEFAULT NULL,
  `context` varchar(255) DEFAULT NULL,
  `defaultip` varchar(255) DEFAULT NULL,
  `dtmfmode` varchar(255) DEFAULT NULL,
  `fromuser` varchar(255) DEFAULT NULL,
  `fromdomain` varchar(255) DEFAULT NULL,
  `insecure` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `mailbox` varchar(255) DEFAULT NULL,
  `md5secret` varchar(255) DEFAULT NULL,
  `jhi_deny` varchar(255) DEFAULT NULL,
  `permit` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  `musiconhold` varchar(255) DEFAULT NULL,
  `pickupgroup` varchar(255) DEFAULT NULL,
  `qualify` varchar(255) DEFAULT NULL,
  `regexten` varchar(255) DEFAULT NULL,
  `restrictcid` varchar(255) DEFAULT NULL,
  `rtptimeout` varchar(255) DEFAULT NULL,
  `rtpholdtimeout` varchar(255) DEFAULT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `setvar` varchar(255) DEFAULT NULL,
  `disallow` varchar(255) DEFAULT NULL,
  `allow` varchar(255) DEFAULT NULL,
  `fullcontact` varchar(255) DEFAULT NULL,
  `ipaddr` varchar(255) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `regserver` varchar(255) DEFAULT NULL,
  `regseconds` int(11) DEFAULT NULL,
  `lastms` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `defaultuser` varchar(255) DEFAULT NULL,
  `subscribecontext` varchar(255) DEFAULT NULL,
  `useragent` varchar(255) DEFAULT NULL,
  `status` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sip_peer_old`
--

INSERT INTO `sip_peer_old` (`id`, `name`, `host`, `nat`, `jhi_type`, `accountcode`, `amaflags`, `call-limit`, `callgroup`, `callerid`, `cancallforward`, `canreinvite`, `context`, `defaultip`, `dtmfmode`, `fromuser`, `fromdomain`, `insecure`, `language`, `mailbox`, `md5secret`, `jhi_deny`, `permit`, `mask`, `musiconhold`, `pickupgroup`, `qualify`, `regexten`, `restrictcid`, `rtptimeout`, `rtpholdtimeout`, `secret`, `setvar`, `disallow`, `allow`, `fullcontact`, `ipaddr`, `port`, `regserver`, `regseconds`, `lastms`, `username`, `defaultuser`, `subscribecontext`, `useragent`, `status`) VALUES
(1, 'sangoma', '200.63.48.95', 'force_rport', NULL, NULL, NULL, 100, NULL, NULL, NULL, NULL, 'incoming', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1234', NULL, NULL, 'g729,g721', NULL, NULL, NULL, NULL, NULL, NULL, '200.63.48.95', NULL, NULL, NULL, b'1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `call_detail_record`
--
ALTER TABLE `call_detail_record`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `DATABASECHANGELOGLOCK`
--
ALTER TABLE `DATABASECHANGELOGLOCK`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `dial_plan`
--
ALTER TABLE `dial_plan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gateway_id` (`gateway_id`);

--
-- Indexes for table `gateway`
--
ALTER TABLE `gateway`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `gateway_name` (`name`),
  ADD KEY `gateway_name_host` (`name`,`host`),
  ADD KEY `gateway_ipaddr_port` (`ipaddr`,`port`),
  ADD KEY `gateway_host_port` (`host`,`port`);

--
-- Indexes for table `gateway_old`
--
ALTER TABLE `gateway_old`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `name_2` (`name`);

--
-- Indexes for table `jhi_authority`
--
ALTER TABLE `jhi_authority`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `jhi_persistent_audit_event`
--
ALTER TABLE `jhi_persistent_audit_event`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `idx_persistent_audit_event` (`principal`,`event_date`);

--
-- Indexes for table `jhi_persistent_audit_evt_data`
--
ALTER TABLE `jhi_persistent_audit_evt_data`
  ADD PRIMARY KEY (`event_id`,`name`),
  ADD KEY `idx_persistent_audit_evt_data` (`event_id`);

--
-- Indexes for table `jhi_user`
--
ALTER TABLE `jhi_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_user_login` (`login`),
  ADD UNIQUE KEY `ux_user_email` (`email`);

--
-- Indexes for table `jhi_user_authority`
--
ALTER TABLE `jhi_user_authority`
  ADD PRIMARY KEY (`user_id`,`authority_name`),
  ADD KEY `fk_authority_name` (`authority_name`);

--
-- Indexes for table `sip_peer`
--
ALTER TABLE `sip_peer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `sippeers_name` (`name`),
  ADD KEY `sippeers_name_host` (`name`,`host`),
  ADD KEY `sippeers_ipaddr_port` (`ipaddr`,`port`),
  ADD KEY `sippeers_host_port` (`host`,`port`);

--
-- Indexes for table `sip_peer_old`
--
ALTER TABLE `sip_peer_old`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `call_detail_record`
--
ALTER TABLE `call_detail_record`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;
--
-- AUTO_INCREMENT for table `dial_plan`
--
ALTER TABLE `dial_plan`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `gateway`
--
ALTER TABLE `gateway`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `gateway_old`
--
ALTER TABLE `gateway_old`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `jhi_persistent_audit_event`
--
ALTER TABLE `jhi_persistent_audit_event`
  MODIFY `event_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT for table `jhi_user`
--
ALTER TABLE `jhi_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `sip_peer`
--
ALTER TABLE `sip_peer`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `sip_peer_old`
--
ALTER TABLE `sip_peer_old`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `dial_plan`
--
ALTER TABLE `dial_plan`
  ADD CONSTRAINT `fk_dialplan_dateway` FOREIGN KEY (`gateway_id`) REFERENCES `sip_peer` (`id`);

--
-- Constraints for table `jhi_persistent_audit_evt_data`
--
ALTER TABLE `jhi_persistent_audit_evt_data`
  ADD CONSTRAINT `fk_evt_pers_audit_evt_data` FOREIGN KEY (`event_id`) REFERENCES `jhi_persistent_audit_event` (`event_id`);

--
-- Constraints for table `jhi_user_authority`
--
ALTER TABLE `jhi_user_authority`
  ADD CONSTRAINT `fk_authority_name` FOREIGN KEY (`authority_name`) REFERENCES `jhi_authority` (`name`),
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `jhi_user` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
