-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 13-05-2025 a las 20:54:58
-- Versión del servidor: 8.0.42-0ubuntu0.24.04.1
-- Versión de PHP: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `BDFacipago`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Cuenta`
--

CREATE TABLE `Cuenta` (
  `id_cuenta` int NOT NULL,
  `numero_cuenta` char(14) NOT NULL,
  `saldo` decimal(10,2) DEFAULT '0.00',
  `id_usuario` int NOT NULL,
  `id_estado` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Volcado de datos para la tabla `Cuenta`
--

INSERT INTO `Cuenta` (`id_cuenta`, `numero_cuenta`, `saldo`, `id_usuario`, `id_estado`, `fecha_creacion`) VALUES
(1, '38577356374907', 3640.00, 1, 1, '2025-05-12 18:25:11'),
(2, '59372594365923', 100.00, 2, 1, '2025-05-13 00:35:50'),
(3, '67372099757924', 0.00, 3, 1, '2025-05-13 03:28:13'),
(4, '07060616680299', 650.00, 4, 1, '2025-05-13 03:31:45'),
(5, '78501371211140', 101090.00, 5, 1, '2025-05-13 03:32:43'),
(6, '61266478087763', 0.00, 6, 1, '2025-05-13 03:45:39'),
(7, '22009889027279', 990.00, 7, 1, '2025-05-13 03:45:59'),
(8, '97470107902580', 2400.00, 8, 1, '2025-05-13 03:50:39'),
(9, '08694472033865', 0.00, 9, 1, '2025-05-13 04:12:44'),
(10, '84478270172836', 0.00, 10, 1, '2025-05-13 13:15:25'),
(11, '83965279509570', 0.00, 11, 1, '2025-05-13 14:33:22'),
(12, '03975802403846', 0.00, 12, 1, '2025-05-13 15:16:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Estado_Cuenta`
--

CREATE TABLE `Estado_Cuenta` (
  `id_estado` int NOT NULL,
  `estado` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Estado_Cuenta`
--

INSERT INTO `Estado_Cuenta` (`id_estado`, `estado`) VALUES
(1, 'Activa'),
(2, 'Suspendida'),
(3, 'Cerrada'),
(4, 'Bloqueada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Metodo_Pago`
--

CREATE TABLE `Metodo_Pago` (
  `id_metodo` int NOT NULL,
  `metodo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Metodo_Pago`
--

INSERT INTO `Metodo_Pago` (`id_metodo`, `metodo`) VALUES
(1, 'Izipay'),
(2, 'Yape');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Movimiento`
--

CREATE TABLE `Movimiento` (
  `id_movimiento` int NOT NULL,
  `reporte_id` int NOT NULL,
  `transferencia_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Recarga`
--

CREATE TABLE `Recarga` (
  `id_recarga` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_cuenta` int NOT NULL,
  `id_metodo` int NOT NULL
) ;

--
-- Volcado de datos para la tabla `Recarga`
--

INSERT INTO `Recarga` (`id_recarga`, `monto`, `fecha`, `id_cuenta`, `id_metodo`) VALUES
(1, 100.00, '2025-05-13 00:36:38', 2, 1),
(2, 10.00, '2025-05-13 03:34:08', 5, 2),
(3, 100.00, '2025-05-13 03:34:53', 5, 1),
(4, 500.00, '2025-05-13 03:47:23', 4, 1),
(5, 100000.00, '2025-05-13 03:50:10', 5, 1),
(6, 120.00, '2025-05-13 03:50:12', 4, 2),
(7, 2000.00, '2025-05-13 03:51:07', 8, 2),
(8, 1000.00, '2025-05-13 05:29:09', 7, 1),
(9, 1000.00, '2025-05-13 05:35:23', 5, 1),
(10, 40.00, '2025-05-13 13:29:25', 1, 2),
(11, 4000.00, '2025-05-13 13:29:59', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Reporte`
--

CREATE TABLE `Reporte` (
  `id_reporte` int NOT NULL,
  `fecha_generacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` enum('diario','mensual','anual') NOT NULL,
  `descripcion` text,
  `id_usuario` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Transferencia`
--

CREATE TABLE `Transferencia` (
  `id_transferencia` int NOT NULL,
  `cuenta_origen` char(14) NOT NULL,
  `cuenta_destino` char(14) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `mensaje` varchar(255) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Volcado de datos para la tabla `Transferencia`
--

INSERT INTO `Transferencia` (`id_transferencia`, `cuenta_origen`, `cuenta_destino`, `monto`, `mensaje`, `fecha`) VALUES
(1, '78501371211140', '07060616680299', 10.00, 'drwerw', '2025-05-13 03:36:00'),
(2, '07060616680299', '78501371211140', 10.00, 'Del servicio', '2025-05-13 03:40:24'),
(3, '78501371211140', '07060616680299', 20.00, 'ctmr', '2025-05-13 03:48:12'),
(4, '22009889027279', '07060616680299', 10.00, '', '2025-05-13 05:29:24'),
(5, '38577356374907', '97470107902580', 400.00, '464', '2025-05-13 13:33:19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Usuario`
--

CREATE TABLE `Usuario` (
  `id_usuario` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contraseña` varchar(60) NOT NULL,
  `dni` char(8) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Usuario`
--

INSERT INTO `Usuario` (`id_usuario`, `nombre`, `apellido`, `correo`, `contraseña`, `dni`, `telefono`, `fecha_nacimiento`, `fecha_creacion`) VALUES
(1, 'CRISTHOFER LEONARDO', 'QUISPE MAMANI', 'arturo200512@hotmail.com', '$2a$10$a/VV1pzQ9rSNhSfRRBno3eSIsfbc7VatXmGlPHftNYaGNMpqU5oGi', '75132958', '', '2004-01-22', '2025-05-12 18:25:10'),
(2, 'BRADY JUAN CARLOS', 'GOMEZ AGUILAR', 'ejemplo@gmail.com', '$2a$10$Y8uwX8lBfh67kJo7lL47ruC5pEyT3xnuCNMLntogNtN5lZXTh9P/y', '73636263', '944546446', '2004-02-23', '2025-05-13 00:35:50'),
(3, 'HAROLD PABLO', 'SULCA VASQUEZ', 'haroldsulca@gmail.com', '$2a$10$coZ1tkVC/wNyjY3HmWHag.YzrvaaVTRHz33Z6tXyUNfNLEDouSZNW', '74625676', '1231312', '2005-06-28', '2025-05-13 03:28:13'),
(4, 'JEAN CARLOS', 'HILARIO PALACIOS', 'chilariopalacios@gmail.com', '$2a$10$.jG3erN1q6OoyIKEwwz24.vz58VUgfBH1aeLuSN3bDQ9QoGr/icBG', '75628800', '906468003', '2002-02-23', '2025-05-13 03:31:45'),
(5, 'NEYLA', 'MARINA SANCHEZ', 'harold@gmail.com', '$2a$10$xcB1pb9287c0YGyLD7mjcOG9w2A2fPRgumc7LSclUzRkuz6VebR0e', '45353534', '', '1988-10-02', '2025-05-13 03:32:43'),
(6, 'ROXANA PILAR', 'ROMAN GUERRERO', 'pepito2012@gmail.com', '$2a$10$Kj/8aBjOFAT9QiaV74Fz/.egfUfgq8TH19osfc47BZ.6NdLS5aQ5S', '76482037', '', '1997-09-26', '2025-05-13 03:45:39'),
(7, 'BRYAN DAVID', 'SALAZAR ESPINOZA', 'bryan@gmail.com', '$2a$10$MHkcXdzGqGyLTCGwVLqJcu8R53N1TTlawl38nUc999sdJkFFBrkHa', '73877522', '', '2002-09-20', '2025-05-13 03:45:59'),
(8, 'MIGUEL ANGEL', 'PALACIN PINO', 'Miguel@hotmail.com', '$2a$10$uhJ0nsitqll8GfeUi0C08OtEQCToOk0FuPnn1HV9f4hcr9m0L8zOG', '70570731', '934567835', '2001-11-26', '2025-05-13 03:50:39'),
(9, 'SEBASTIAN DAVID', 'VERA SEGOVIA', 'maria@example.com', '$2a$10$oPHPjad2TynYJIEnPa3OGOIYKbnMfJ3vrcZowvWyDn1GeuinvDg1u', '75132955', '', '2005-05-13', '2025-05-13 04:12:44'),
(10, 'MANUEL DAGOBERTO', 'JUAN DE DIOS MENDEZ', 'maria12@example.com', '$2a$10$BE.fZraTiO.ogrSJkbbbX.LOuN82oVtwgLB59CcwdhOLIgCjXmA9m', '75132943', '', '1998-12-26', '2025-05-13 13:15:25'),
(11, 'BRIGHITTE ARIANA', 'VILLEGAS MARTINEZ', 'canchita@gmail.com', '$2a$10$nxQRw04vDQer/zPNfzCqUu8fIbFdXkXrwba0243Kt45c/qEGnEK4O', '76554443', '', '2005-08-06', '2025-05-13 14:33:22'),
(12, 'ALEX DAVID', 'BANCES SANTISTEBAN', 'prueba2@gmail.com', '$2a$10$ynBL4F5C4GlM.A4tVDZ24uR3CW0uaSbXEuKuVRN9ArTJLhtb6E/Gm', '75463555', '', '2003-10-02', '2025-05-13 15:16:27');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Cuenta`
--
ALTER TABLE `Cuenta`
  ADD PRIMARY KEY (`id_cuenta`),
  ADD UNIQUE KEY `numero_cuenta` (`numero_cuenta`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_estado` (`id_estado`),
  ADD KEY `id_usuario_2` (`id_usuario`);

--
-- Indices de la tabla `Estado_Cuenta`
--
ALTER TABLE `Estado_Cuenta`
  ADD PRIMARY KEY (`id_estado`);

--
-- Indices de la tabla `Metodo_Pago`
--
ALTER TABLE `Metodo_Pago`
  ADD PRIMARY KEY (`id_metodo`);

--
-- Indices de la tabla `Movimiento`
--
ALTER TABLE `Movimiento`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `reporte_id` (`reporte_id`),
  ADD KEY `transferencia_id` (`transferencia_id`);

--
-- Indices de la tabla `Recarga`
--
ALTER TABLE `Recarga`
  ADD PRIMARY KEY (`id_recarga`),
  ADD KEY `id_cuenta` (`id_cuenta`),
  ADD KEY `id_metodo` (`id_metodo`);

--
-- Indices de la tabla `Reporte`
--
ALTER TABLE `Reporte`
  ADD PRIMARY KEY (`id_reporte`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `Transferencia`
--
ALTER TABLE `Transferencia`
  ADD PRIMARY KEY (`id_transferencia`),
  ADD KEY `cuenta_origen` (`cuenta_origen`),
  ADD KEY `cuenta_destino` (`cuenta_destino`);

--
-- Indices de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Cuenta`
--
ALTER TABLE `Cuenta`
  MODIFY `id_cuenta` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Estado_Cuenta`
--
ALTER TABLE `Estado_Cuenta`
  MODIFY `id_estado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `Metodo_Pago`
--
ALTER TABLE `Metodo_Pago`
  MODIFY `id_metodo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `Movimiento`
--
ALTER TABLE `Movimiento`
  MODIFY `id_movimiento` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Recarga`
--
ALTER TABLE `Recarga`
  MODIFY `id_recarga` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Reporte`
--
ALTER TABLE `Reporte`
  MODIFY `id_reporte` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Transferencia`
--
ALTER TABLE `Transferencia`
  MODIFY `id_transferencia` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Cuenta`
--
ALTER TABLE `Cuenta`
  ADD CONSTRAINT `Cuenta_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario` (`id_usuario`),
  ADD CONSTRAINT `Cuenta_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `Estado_Cuenta` (`id_estado`);

--
-- Filtros para la tabla `Movimiento`
--
ALTER TABLE `Movimiento`
  ADD CONSTRAINT `Movimiento_ibfk_1` FOREIGN KEY (`reporte_id`) REFERENCES `Reporte` (`id_reporte`),
  ADD CONSTRAINT `Movimiento_ibfk_2` FOREIGN KEY (`transferencia_id`) REFERENCES `Transferencia` (`id_transferencia`);

--
-- Filtros para la tabla `Recarga`
--
ALTER TABLE `Recarga`
  ADD CONSTRAINT `Recarga_ibfk_1` FOREIGN KEY (`id_cuenta`) REFERENCES `Cuenta` (`id_cuenta`),
  ADD CONSTRAINT `Recarga_ibfk_2` FOREIGN KEY (`id_metodo`) REFERENCES `Metodo_Pago` (`id_metodo`);

--
-- Filtros para la tabla `Reporte`
--
ALTER TABLE `Reporte`
  ADD CONSTRAINT `Reporte_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuario` (`id_usuario`);

--
-- Filtros para la tabla `Transferencia`
--
ALTER TABLE `Transferencia`
  ADD CONSTRAINT `Transferencia_ibfk_1` FOREIGN KEY (`cuenta_origen`) REFERENCES `Cuenta` (`numero_cuenta`),
  ADD CONSTRAINT `Transferencia_ibfk_2` FOREIGN KEY (`cuenta_destino`) REFERENCES `Cuenta` (`numero_cuenta`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
