-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-12-2024 a las 15:01:48
-- Versión del servidor: 11.6.2-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `backend_mattrix`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add Colegio', 7, 'add_colegio'),
(26, 'Can change Colegio', 7, 'change_colegio'),
(27, 'Can delete Colegio', 7, 'delete_colegio'),
(28, 'Can view Colegio', 7, 'view_colegio'),
(29, 'Can add historical Colegio', 8, 'add_historicalcolegio'),
(30, 'Can change historical Colegio', 8, 'change_historicalcolegio'),
(31, 'Can delete historical Colegio', 8, 'delete_historicalcolegio'),
(32, 'Can view historical Colegio', 8, 'view_historicalcolegio'),
(33, 'Can add Curso', 9, 'add_cursos'),
(34, 'Can change Curso', 9, 'change_cursos'),
(35, 'Can delete Curso', 9, 'delete_cursos'),
(36, 'Can view Curso', 9, 'view_cursos'),
(37, 'Can add imagenes', 10, 'add_imagenes'),
(38, 'Can change imagenes', 10, 'change_imagenes'),
(39, 'Can delete imagenes', 10, 'delete_imagenes'),
(40, 'Can view imagenes', 10, 'view_imagenes'),
(41, 'Can add Perfil', 11, 'add_profile'),
(42, 'Can change Perfil', 11, 'change_profile'),
(43, 'Can delete Perfil', 11, 'delete_profile'),
(44, 'Can view Perfil', 11, 'view_profile'),
(45, 'Can add oa', 12, 'add_oa'),
(46, 'Can change oa', 12, 'change_oa'),
(47, 'Can delete oa', 12, 'delete_oa'),
(48, 'Can view oa', 12, 'view_oa'),
(49, 'Can add problema probabilidad', 13, 'add_problemaprobabilidad'),
(50, 'Can change problema probabilidad', 13, 'change_problemaprobabilidad'),
(51, 'Can delete problema probabilidad', 13, 'delete_problemaprobabilidad'),
(52, 'Can view problema probabilidad', 13, 'view_problemaprobabilidad'),
(53, 'Can add terminos pareados', 14, 'add_terminospareados'),
(54, 'Can change terminos pareados', 14, 'change_terminospareados'),
(55, 'Can delete terminos pareados', 14, 'delete_terminospareados'),
(56, 'Can view terminos pareados', 14, 'view_terminospareados'),
(57, 'Can add niveles', 15, 'add_niveles'),
(58, 'Can change niveles', 15, 'change_niveles'),
(59, 'Can delete niveles', 15, 'delete_niveles'),
(60, 'Can view niveles', 15, 'view_niveles'),
(61, 'Can add indicadores evaluacion', 16, 'add_indicadoresevaluacion'),
(62, 'Can change indicadores evaluacion', 16, 'change_indicadoresevaluacion'),
(63, 'Can delete indicadores evaluacion', 16, 'delete_indicadoresevaluacion'),
(64, 'Can view indicadores evaluacion', 16, 'view_indicadoresevaluacion'),
(65, 'Can add etapas', 17, 'add_etapas'),
(66, 'Can change etapas', 17, 'change_etapas'),
(67, 'Can delete etapas', 17, 'delete_etapas'),
(68, 'Can view etapas', 17, 'view_etapas'),
(69, 'Can add avance estudiantes', 18, 'add_avanceestudiantes'),
(70, 'Can change avance estudiantes', 18, 'change_avanceestudiantes'),
(71, 'Can delete avance estudiantes', 18, 'delete_avanceestudiantes'),
(72, 'Can view avance estudiantes', 18, 'view_avanceestudiantes'),
(73, 'Can add Relación Docente-Estudiante', 19, 'add_docenteestudiante'),
(74, 'Can change Relación Docente-Estudiante', 19, 'change_docenteestudiante'),
(75, 'Can delete Relación Docente-Estudiante', 19, 'delete_docenteestudiante'),
(76, 'Can view Relación Docente-Estudiante', 19, 'view_docenteestudiante'),
(77, 'Can add respuesta escrita', 20, 'add_respuestaescrita'),
(78, 'Can change respuesta escrita', 20, 'change_respuestaescrita'),
(79, 'Can delete respuesta escrita', 20, 'delete_respuestaescrita'),
(80, 'Can view respuesta escrita', 20, 'view_respuestaescrita');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(35, 'pbkdf2_sha256$870000$455EHeWPTkCieEjWVIGxtE$bXmrvll+E+vOopop3nXwiICJzxjqRrOrDKLbCHfxOhY=', '2024-12-04 05:04:57.863525', 1, 'Clau', '', '', 'c@gmail.com', 1, 1, '2024-12-04 05:04:33.986866'),
(36, '', NULL, 0, 'Clau2', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:02:05.360280'),
(37, '', NULL, 0, 'Clau3', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:05:57.180711'),
(38, 'pbkdf2_sha256$870000$QqkfWID0j8zzgmz68KhZ7g$lFGDbdUdGGtk/VzHdDQqLT1m0hAEO/iw63YXbsId2s4=', NULL, 0, 'Clau4', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:11:47.610259'),
(39, 'pbkdf2_sha256$870000$JL7gti4nmmjuvdJNbGaYdt$W4y3xoyhDhGy6R2umLGD/8N5RB5oN07r8QHvVfoQ9kw=', NULL, 0, 'Clau5', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:13:49.236055'),
(40, 'pbkdf2_sha256$870000$EbUGVzWe3JiwRmnx2OLnRe$p6j39g+PwMpSGwBkJsMq4moyT3dXC0Z0Wdgt1X64bzA=', NULL, 0, 'Clau6', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:16:20.915750'),
(41, 'pbkdf2_sha256$870000$ZAJHkVk1R8T4nAMd6HQIbD$epIHZggBVIi+GQ5POHAPX8pb5fkrVMUYTG0RAJPVVoI=', NULL, 0, 'sy', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 06:20:42.328732'),
(42, 'pbkdf2_sha256$870000$Lx2KgUkIVlc2Wd31PEK3cf$zNa7Sxulq4tU5t6TPk3M4SnaS21hF8vi4TLmz0XqRw4=', NULL, 0, 'ssy', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 06:21:09.730435'),
(44, 'pbkdf2_sha256$870000$rfWHwl3IGpszS1jQVQR0uc$Bg1uJ5hAZ6rO2Z1f/MjTTnSMyaG1A48OSlvu0EGFjwY=', NULL, 0, 'Clau8', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:22:25.233584'),
(45, 'pbkdf2_sha256$870000$ZTKl1hRTK8b1SCApIRdsc8$UmULGx3a6V9UM2FhWMRq77Yar5ZbIYgpkyk9HMbW4/w=', NULL, 0, 'Clau9', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:23:13.531705'),
(46, 'pbkdf2_sha256$870000$iRpVDYldygsfxcXbrrfPj1$tbDVzalHH6/pGZidBCRUJ6l+RYP4m6sMhxmNLyHQNng=', NULL, 0, 'Clau10', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:29:47.623968'),
(47, 'pbkdf2_sha256$870000$Lk681EPbbk28TlVUgFKtCL$LcLqIow+GTraUQXtkyFSIwl06ivn1xfLXb6DlpCjH74=', NULL, 0, 'Clau11', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:43:12.008618'),
(48, 'pbkdf2_sha256$870000$Ml8IPo7DOcpAQX7r4Vjgen$kEct7wEWr22d3+5lCufpVyWyGj6+byLwqDE8wIef30I=', NULL, 0, 'Clau12', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:44:31.034134'),
(49, 'pbkdf2_sha256$870000$9zPuQRyO30hVr3axXXnsB1$Daj+WJeYWuX3oB/+BSUKHD6MBMmbAjlmGvbM6nZdQyY=', NULL, 0, 'Clau13', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:46:05.805751'),
(50, 'pbkdf2_sha256$870000$gG9NLK5M9JOmCMkYEBvUvm$GjOVlq/qBXKfrU5nmc/WNeVvb8sSRj4fmcAHmIVKO6c=', NULL, 0, 'Clau14', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:47:02.129245'),
(51, 'pbkdf2_sha256$870000$Z0IwykMDGgTu90eWwMvBDN$CfsRR07pKAYrTZ2N+g4QPUOWbAn/jL/c7T08fqe8TkI=', NULL, 0, 'Clau15', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:48:16.392718'),
(52, 'pbkdf2_sha256$870000$8Ao02ymVbVoGxoy8uGC8pJ$ZCEXWv5tFh8wr1ihgfz6Ks4LV4Hjx2l7wj1aUVkv32I=', NULL, 0, 'Clau16', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:49:13.432417'),
(53, 'pbkdf2_sha256$870000$wMKn00zk5XGi2SyUtCt3pP$qKPRz1hYNAbIUXXYU4JzH6gNN9Wi9/YXBnxA5MIaqIQ=', NULL, 0, 'Clau17', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:51:51.391199'),
(54, 'pbkdf2_sha256$870000$K5ppd1IawDJOupbb0oRsdR$OSzMoPGcCmU7jtnyYK2o55JYefa1z3QB75FzlmIDieQ=', NULL, 0, 'Clau18', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:53:47.851617'),
(55, 'pbkdf2_sha256$870000$IxxSPceQNtt3UpzkQ0rauY$bMVmmpraDgL/CCIGes2rvA9OGNbpFr4bm8z3zJSwQ0g=', NULL, 0, 'Clau19', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:55:34.080281'),
(56, 'pbkdf2_sha256$870000$ldpiX4Tjp3zs4ZwIFYFZ62$rZTFXbl2Ek4X+ssaVkhBeFh3wv42RUrkVx/QE8NbWOU=', NULL, 0, 'Clau20', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 06:56:22.120304'),
(57, 'pbkdf2_sha256$870000$xA1e6bO9bJsA48DkArfuwU$188PVazx5rk6DrmNNpbaWXtT307dNFeYDvM3AFluAxg=', NULL, 0, 'rE4ABXo+r0njgR2i8t', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 06:57:04.248588'),
(58, 'pbkdf2_sha256$870000$6FZCN2SJsFH13HW2nNRTw5$BuJ1YJfGOyOaOgHXWnK0vVSOelkZgE8CadMcvGQu+5g=', NULL, 0, 'Clau21', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 07:02:20.826920'),
(59, 'pbkdf2_sha256$870000$5wzzeGJ74z2bmdykukWPg4$CcOKqWL7PtamG6ZytrK+BnoTrimLoPMbcH0c1x+Hf24=', NULL, 0, 'Clau22', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 07:04:45.555365'),
(60, 'pbkdf2_sha256$870000$UwzVP1M2QHVlOWucXTo5af$GXm8I5AzyFaRJajv+UUBCyouN3Mf89jxXDffOHaOEBQ=', NULL, 0, 'rE4ABXo+r0njgR2iz8t', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:05:08.620805'),
(61, 'pbkdf2_sha256$870000$BOTs7HEN7VLVJEtQh9v3JP$xNWcX3t2DYoBrMN2BaylgsgopiiBKU5L8Nx+cht4VSM=', NULL, 0, 'vamrdYrDoiGPIcEDw_ax0.', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:05:57.341387'),
(62, 'pbkdf2_sha256$870000$0FI3ISsSxT9PkhRguaHxgH$aL201dieM6SGSyRok2fEyW2KoJigOx4kzufHHG9tm3k=', NULL, 0, 'vamrdYrDoiGPIcEssDw_ax0.', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:07:06.372772'),
(63, 'pbkdf2_sha256$870000$uu3iSHGFQQQdpV41SPG3m4$Z3jluZ4ijYYpMNV4NcPje9WldyY8G+YCVevnc/+4Poo=', NULL, 0, 'Gs6vrjt+RqQHw-DdQ2DCv', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:07:43.184912'),
(64, 'pbkdf2_sha256$870000$Xo5zS6PW6uImCroKsIvdvl$4TcESSa5ILDIbXfpwSwbKHv826GrA54PxwI9muxC+yw=', NULL, 0, 'Gs6vrjt+RqQHwss-DdQ2DCv', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:08:33.239170'),
(65, 'pbkdf2_sha256$870000$3ITShWdeNvKH7ZaL0unmJQ$No2+k+6V0Rz6TBJDeflumYzpq6GYw/zRLa0YTiO8NUA=', NULL, 0, 'Clau23', 'Claudia', 'Videla', 'c@gmail.cl', 0, 1, '2024-12-04 07:10:18.774802'),
(66, 'pbkdf2_sha256$870000$Jo7KjG7l0qWaI2gbYuSd0b$YU7K6yi1vCrhMnl/1+zEIf6kY08Q23A65Kw/jZCrTf4=', NULL, 0, 'Gs6vrjt+RqQHwss-sssDdQ2DCv', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:10:52.176461'),
(67, 'pbkdf2_sha256$870000$0Fe1bVGsbJ3qMYFJE0OaBw$Ctve5SmmE2Og/lMhG2YtaAPi0km+oc432En6uobXOKk=', NULL, 0, 'Gs6vrjtss+RqQHwss-sssDdQ2DCv', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:11:07.035949'),
(68, 'pbkdf2_sha256$870000$t2VzKO7FNKm5XH0Yfuv9Fz$oVEZkmDS4SoXeD/eaLVh0VeleonE61UiEAU4GRvFEkQ=', NULL, 0, 'DV@4@HONAuFWmZ5VegcWHfHPmhgsEz3Lo0B8gbUAppykC-k79nWwr', 'string', 'string', 'user@example.com', 0, 1, '2024-12-04 07:12:39.857359');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2024-11-30 18:14:32.544517', '1', 'Avatar 1', 1, '[{\"added\": {}}]', 10, 7),
(2, '2024-11-30 18:14:40.371695', '2', 'Avatar 2', 1, '[{\"added\": {}}]', 10, 7),
(3, '2024-11-30 18:14:53.323368', '3', 'Avatar 3', 1, '[{\"added\": {}}]', 10, 7),
(4, '2024-11-30 18:14:59.523765', '4', 'Avatar 4', 1, '[{\"added\": {}}]', 10, 7),
(5, '2024-11-30 18:15:38.338262', '5', 'Avatar 5', 1, '[{\"added\": {}}]', 10, 7),
(6, '2024-11-30 18:15:59.241127', '6', 'Avatar 6', 1, '[{\"added\": {}}]', 10, 7),
(7, '2024-11-30 18:16:12.056382', '7', 'Fondo Nivel 7', 1, '[{\"added\": {}}]', 10, 7),
(8, '2024-11-30 18:16:18.567891', '8', 'Fondo Nivel 8', 1, '[{\"added\": {}}]', 10, 7),
(9, '2024-11-30 18:23:13.826732', '10', 'Avatar 10', 1, '[{\"added\": {}}]', 10, 7),
(10, '2024-11-30 18:26:31.240689', '11', 'Avatar 11', 1, '[{\"added\": {}}]', 10, 7),
(11, '2024-11-30 18:28:11.362949', '1', 'Avatar 1', 2, '[]', 10, 7),
(12, '2024-11-30 19:12:43.325813', '4', 'qqq', 2, '[{\"added\": {\"name\": \"Perfil\", \"object\": \"qqq - student\"}}]', 4, 7),
(13, '2024-11-30 19:13:14.303534', NULL, 'asas - student', 1, '[{\"added\": {}}]', 11, 7),
(14, '2024-11-30 19:20:23.690241', '1', 'asas - student', 1, '[{\"added\": {}}]', 11, 7),
(15, '2024-11-30 21:07:16.281972', '2', 'Clau - teacher', 1, '[{\"added\": {}}]', 11, 7),
(16, '2024-11-30 21:12:22.758333', 'PC01', 'Prueba', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"etapas\", \"object\": \"Concepto espacio muestral\"}}, {\"added\": {\"name\": \"etapas\", \"object\": \"Experimentos\"}}]', 15, 7),
(17, '2024-11-30 21:13:31.358301', '2', 'Experimentos', 2, '[{\"changed\": {\"fields\": [\"Dificultad\", \"Habilidad\"]}}]', 17, 7),
(18, '2024-11-30 21:13:37.658383', '1', 'Concepto espacio muestral', 2, '[{\"changed\": {\"fields\": [\"Dificultad\", \"Habilidad\"]}}]', 17, 7),
(19, '2024-11-30 22:07:43.706253', '8', 'Fondo Nivel 8', 2, '[{\"changed\": {\"fields\": [\"Imagen\"]}}]', 10, 7),
(20, '2024-12-02 04:28:00.291452', 'PC01', 'Prueba', 2, '[{\"added\": {\"name\": \"etapas\", \"object\": \"Pelotas\"}}]', 15, 7),
(21, '2024-12-02 05:21:18.188695', '12', 'Fondo Nivel 12', 1, '[{\"added\": {}}]', 10, 7),
(22, '2024-12-02 05:21:22.751555', '13', 'Fondo Nivel 13', 1, '[{\"added\": {}}]', 10, 7),
(23, '2024-12-02 05:21:27.965356', '14', 'Fondo Nivel 14', 1, '[{\"added\": {}}]', 10, 7),
(24, '2024-12-02 05:21:48.741074', 'P01', 'Juego prueba', 2, '[{\"changed\": {\"fields\": [\"Fondo tarjeta\"]}}]', 15, 7),
(25, '2024-12-02 05:21:57.322970', 'PC01', 'Prueba', 2, '[{\"changed\": {\"fields\": [\"Fondo\", \"Fondo tarjeta\"]}}]', 15, 7),
(26, '2024-12-02 05:22:52.069747', '14', 'Fondo Nivel 14', 2, '[{\"changed\": {\"fields\": [\"Imagen\"]}}]', 10, 7),
(27, '2024-12-02 05:23:44.112282', '14', 'Fondo Nivel 14', 2, '[{\"changed\": {\"fields\": [\"Imagen\"]}}]', 10, 7),
(28, '2024-12-02 15:54:22.568875', 'P01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"fields\": [\"Nombre\"]}}]', 15, 7),
(29, '2024-12-02 15:55:13.119450', 'P01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Nombre\", \"Descripcion\", \"Componente\"]}}]', 15, 7),
(30, '2024-12-02 22:19:26.203827', '16', 'aleatorio', 1, '[{\"added\": {}}]', 14, 7),
(31, '2024-12-02 22:19:42.463501', '17', 'aleatorio', 1, '[{\"added\": {}}]', 14, 7),
(32, '2024-12-02 22:20:02.609421', '18', 'aleatorio', 1, '[{\"added\": {}}]', 14, 7),
(33, '2024-12-02 22:21:41.632427', '19', 'aleatorio', 1, '[{\"added\": {}}]', 14, 7),
(34, '2024-12-02 22:22:22.830352', '20', 'determinista', 1, '[{\"added\": {}}]', 14, 7),
(35, '2024-12-02 22:23:34.514220', '21', 'determinista', 1, '[{\"added\": {}}]', 14, 7),
(36, '2024-12-02 22:25:24.165630', '22', 'determinista', 1, '[{\"added\": {}}]', 14, 7),
(37, '2024-12-02 22:26:51.100899', '23', 'determinista', 1, '[{\"added\": {}}]', 14, 7),
(38, '2024-12-03 03:16:32.467385', '2', 'asas - Tipos de Experimentos - 50 - 100%', 1, '[{\"added\": {}}]', 18, 7),
(39, '2024-12-03 03:34:35.479555', '3', 'Tipos de Experimentos', 2, '[]', 17, 7),
(40, '2024-12-03 03:34:44.142519', '4', 'Pelotas', 2, '[{\"changed\": {\"fields\": [\"Dificultad\", \"Habilidad matematica\"]}}]', 17, 7),
(41, '2024-12-03 03:45:52.330483', '3', 'Tipos de Experimentos', 2, '[]', 17, 7),
(42, '2024-12-03 19:45:11.772973', '3', 'asas - Experimentos - 23 - 100%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(43, '2024-12-03 19:45:28.354291', '3', 'asas - Experimentos - 23 - 100%', 3, '', 18, 7),
(44, '2024-12-03 21:58:50.182365', '5', 'asas - Experimentos - 22 - 100%', 3, '', 18, 7),
(45, '2024-12-03 21:58:55.525738', '4', 'asas - Experimentos - 22 - 100%', 3, '', 18, 7),
(46, '2024-12-03 23:44:18.082288', '15', 'Fondo Nivel 15', 1, '[{\"added\": {}}]', 10, 7),
(47, '2024-12-03 23:45:56.600962', '2', 'asas - Tipos de Experimentos - 52 - 44%', 3, '', 18, 7),
(48, '2024-12-03 23:46:38.119175', '6', 'asas - Experimentos - 20 - 100%', 3, '', 18, 7),
(49, '2024-12-04 03:10:20.079534', '14', 'popo', 2, '[{\"added\": {\"name\": \"Perfil\", \"object\": \"popo - student\"}}]', 4, 7),
(50, '2024-12-04 03:11:10.878033', '8', 'asas - Pelotas - 12 - 12%', 1, '[{\"added\": {}}]', 18, 7),
(51, '2024-12-04 03:11:28.489302', '8', 'asas - Pelotas - 12 - 12%', 3, '', 18, 7),
(52, '2024-12-04 03:11:28.489302', '7', 'asas - Experimentos - 31 - 100%', 3, '', 18, 7),
(53, '2024-12-04 03:11:28.489302', '1', 'asas - Concepto espacio muestral - 33 - 100%', 3, '', 18, 7),
(54, '2024-12-04 03:14:49.867781', '9', 'asas - Tipos de Experimentos - 12 - 12%', 1, '[{\"added\": {}}]', 18, 7),
(55, '2024-12-04 03:17:04.575200', '10', 'asas - Concepto espacio muestral - 13 - 13%', 1, '[{\"added\": {}}]', 18, 7),
(56, '2024-12-04 03:17:47.048120', '11', 'asas - Experimentos - 55 - 100%', 1, '[{\"added\": {}}]', 18, 7),
(57, '2024-12-04 03:18:14.887233', '9', 'asas - Tipos de Experimentos - 12 - 12%', 3, '', 18, 7),
(58, '2024-12-04 03:19:48.667374', '10', 'asas - Concepto espacio muestral - 13 - 13%', 3, '', 18, 7),
(59, '2024-12-04 03:19:52.102297', '11', 'asas - Tipos de Experimentos - 55 - 100%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(60, '2024-12-04 03:21:36.662212', '11', 'asas - Experimentos - 55 - 100%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(61, '2024-12-04 03:22:11.373927', '2', 'Experimentos', 2, '[]', 17, 7),
(62, '2024-12-04 03:22:18.438988', '4', 'Pelotas', 2, '[]', 17, 7),
(63, '2024-12-04 03:22:34.042907', '11', 'asas - Pelotas - 55 - 100%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(64, '2024-12-04 03:23:19.997961', '11', 'asas - Pelotas - 55 - 100%', 3, '', 18, 7),
(65, '2024-12-04 03:35:09.111204', '12', 'asas - Tipos de Experimentos - 42 - 42%', 1, '[{\"added\": {}}]', 18, 7),
(66, '2024-12-04 03:37:28.429649', '12', 'asas - Experimentos - 42 - 42%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(67, '2024-12-04 03:37:41.483260', '12', 'asas - Concepto espacio muestral - 42 - 42%', 2, '[{\"changed\": {\"fields\": [\"Etapa\"]}}]', 18, 7),
(68, '2024-12-04 03:40:20.968406', '13', 'asas - Tipos de Experimentos - 1232 - 66%', 1, '[{\"added\": {}}]', 18, 7),
(69, '2024-12-04 03:42:31.684877', '14', 'asas - Tipos de Experimentos - 1232 - 66%', 1, '[{\"added\": {}}]', 18, 7),
(70, '2024-12-04 03:42:56.759462', '14', 'asas - Tipos de Experimentos - 1232 - 66%', 3, '', 18, 7),
(71, '2024-12-04 03:48:58.478488', '12', 'asas - Concepto espacio muestral - 42 - 42%', 3, '', 18, 7),
(72, '2024-12-04 03:58:02.496701', '13', 'asas - Tipos de Experimentos - 1232 - 89%', 2, '[{\"changed\": {\"fields\": [\"Logro\"]}}]', 18, 7),
(73, '2024-12-04 03:58:25.271177', '15', 'asas - Concepto espacio muestral - 11 - 99%', 1, '[{\"added\": {}}]', 18, 7),
(74, '2024-12-04 04:04:58.502089', '16', 'asas - Experimentos - 11 - 99%', 1, '[{\"added\": {}}]', 18, 7),
(75, '2024-12-04 04:08:30.155071', '16', 'asas - Experimentos - 11 - 99%', 3, '', 18, 7),
(76, '2024-12-04 04:08:30.155071', '15', 'asas - Concepto espacio muestral - 11 - 99%', 3, '', 18, 7),
(77, '2024-12-04 04:08:30.155071', '13', 'asas - Tipos de Experimentos - 1232 - 89%', 3, '', 18, 7),
(78, '2024-12-04 05:05:13.059741', '27', 'prueba1', 3, '', 4, 35),
(79, '2024-12-04 05:05:55.469338', '27', 'prueba1', 3, '', 4, 35),
(80, '2024-12-04 05:06:20.274000', '15', 'prueba3 - student', 3, '', 11, 35),
(81, '2024-12-04 05:06:41.533942', '29', 'prueba3', 2, '[{\"added\": {\"name\": \"Perfil\", \"object\": \"prueba3 - student\"}}]', 4, 35),
(82, '2024-12-04 05:07:44.487709', '22', 'prueba3 - student', 3, '', 11, 35),
(83, '2024-12-04 05:08:05.139199', '22', 'prueba3 - student', 3, '', 11, 35),
(84, '2024-12-04 05:08:13.871743', '29', 'prueba3', 3, '', 4, 35),
(85, '2024-12-04 05:08:18.093456', '28', 'prueba2', 3, '', 4, 35),
(86, '2024-12-04 06:22:35.978852', '25', 'ssy2 - student', 3, '', 11, 35),
(87, '2024-12-04 06:22:47.463526', '43', 'ssy2', 3, '', 4, 35),
(88, '2024-12-04 07:15:57.187559', '26', 'rE4ABXo+r0njgR2i8t - student', 3, '', 11, 35),
(89, '2024-12-04 07:15:57.188559', '27', 'rE4ABXo+r0njgR2iz8t - student', 3, '', 11, 35),
(90, '2024-12-04 07:15:57.188559', '28', 'vamrdYrDoiGPIcEDw_ax0. - student', 3, '', 11, 35),
(91, '2024-12-04 07:15:57.188559', '29', 'vamrdYrDoiGPIcEssDw_ax0. - student', 3, '', 11, 35),
(92, '2024-12-04 07:15:57.188559', '30', 'Gs6vrjt+RqQHw-DdQ2DCv - student', 3, '', 11, 35),
(93, '2024-12-04 07:15:57.188559', '31', 'Gs6vrjt+RqQHwss-DdQ2DCv - student', 3, '', 11, 35),
(94, '2024-12-04 07:15:57.188559', '33', 'Gs6vrjtss+RqQHwss-sssDdQ2DCv - student', 3, '', 11, 35),
(95, '2024-12-04 07:15:57.188559', '34', 'DV@4@HONAuFWmZ5VegcWHfHPmhgsEz3Lo0B8gbUAppykC-k79nWwr - student', 3, '', 11, 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(7, 'mattrix_admin', 'colegio'),
(9, 'mattrix_admin', 'cursos'),
(8, 'mattrix_admin', 'historicalcolegio'),
(17, 'mattrix_contenido', 'etapas'),
(16, 'mattrix_contenido', 'indicadoresevaluacion'),
(15, 'mattrix_contenido', 'niveles'),
(12, 'mattrix_contenido', 'oa'),
(13, 'mattrix_contenido', 'problemaprobabilidad'),
(14, 'mattrix_contenido', 'terminospareados'),
(18, 'mattrix_docentes', 'avanceestudiantes'),
(19, 'mattrix_docentes', 'docenteestudiante'),
(20, 'mattrix_docentes', 'respuestaescrita'),
(10, 'mattrix_usuarios', 'imagenes'),
(11, 'mattrix_usuarios', 'profile'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2024-11-30 18:07:25.063791'),
(2, 'auth', '0001_initial', '2024-11-30 18:07:25.706367'),
(3, 'admin', '0001_initial', '2024-11-30 18:07:25.840883'),
(4, 'admin', '0002_logentry_remove_auto_add', '2024-11-30 18:07:25.846896'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2024-11-30 18:07:25.852894'),
(6, 'contenttypes', '0002_remove_content_type_name', '2024-11-30 18:07:25.948486'),
(7, 'auth', '0002_alter_permission_name_max_length', '2024-11-30 18:07:26.004486'),
(8, 'auth', '0003_alter_user_email_max_length', '2024-11-30 18:07:26.041687'),
(9, 'auth', '0004_alter_user_username_opts', '2024-11-30 18:07:26.049688'),
(10, 'auth', '0005_alter_user_last_login_null', '2024-11-30 18:07:26.098369'),
(11, 'auth', '0006_require_contenttypes_0002', '2024-11-30 18:07:26.101423'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2024-11-30 18:07:26.107438'),
(13, 'auth', '0008_alter_user_username_max_length', '2024-11-30 18:07:26.144390'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2024-11-30 18:07:26.182452'),
(15, 'auth', '0010_alter_group_name_max_length', '2024-11-30 18:07:26.220735'),
(16, 'auth', '0011_update_proxy_permissions', '2024-11-30 18:07:26.227735'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2024-11-30 18:07:26.264495'),
(18, 'mattrix_admin', '0001_initial', '2024-11-30 18:07:26.565572'),
(19, 'mattrix_usuarios', '0001_initial', '2024-11-30 18:07:26.864492'),
(20, 'mattrix_contenido', '0001_initial', '2024-11-30 18:07:27.247189'),
(21, 'mattrix_docentes', '0001_initial', '2024-11-30 18:07:27.536812'),
(22, 'sessions', '0001_initial', '2024-11-30 18:07:27.594728'),
(23, 'mattrix_usuarios', '0002_alter_profile_avataruser', '2024-11-30 18:39:38.249651'),
(24, 'mattrix_usuarios', '0003_alter_profile_avataruser', '2024-11-30 22:18:52.096435'),
(25, 'mattrix_docentes', '0002_docenteestudiante_fecha_creacion', '2024-12-01 17:50:51.586866'),
(26, 'mattrix_contenido', '0002_niveles_fondo_tarjeta', '2024-12-02 05:11:51.241699'),
(27, 'mattrix_contenido', '0003_alter_terminospareados_uso', '2024-12-03 01:18:51.602539'),
(28, 'mattrix_docentes', '0003_respuestaescrita', '2024-12-03 01:18:51.757236'),
(29, 'mattrix_usuarios', '0004_alter_profile_avataruser', '2024-12-03 01:18:51.771262'),
(30, 'mattrix_contenido', '0004_rename_habilidad_etapas_habilidad_matematica_and_more', '2024-12-03 03:04:34.202136'),
(31, 'mattrix_contenido', '0005_etapas_contenido_abordado', '2024-12-03 03:20:24.880367'),
(32, 'mattrix_docentes', '0004_remove_avanceestudiantes_cantidad_intentos', '2024-12-03 20:19:50.353162'),
(33, 'mattrix_contenido', '0006_etapas_es_ultima', '2024-12-04 03:55:37.112855'),
(34, 'mattrix_usuarios', '0005_alter_profile_colegio_alter_profile_curso_and_more', '2024-12-04 04:51:37.775885');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('7fplnw90ht4gslhppjkcaizp60ozc0xi', '.eJxVjMsOwiAURP-FtSFAebp07zcQuPdWqgaS0q6M_64kXehuMufMvFhM-1bi3mmNC7Izc-z02-UED6oD4D3VW-PQ6rYumQ-FH7Tza0N6Xg7376CkXr5r7ZRFq7WbyCStZmGC9DPhJEQAsjZ7SUEAegVGKpfzSCQhJFAktWTvD8xEN6M:1tHRyI:S5-mUzB7hZr7iHskBT1T6xZwVnqLYNi5K1o-904E4Nk', '2024-12-14 18:13:34.271743'),
('jgfar9e0deaw3ue068zjttnk3rgovqk6', '.eJxVjMsOwiAURP-FtSFAebp07zcQuPdWqgaS0q6M_64kXehuMufMvFhM-1bi3mmNC7Izc-z02-UED6oD4D3VW-PQ6rYumQ-FH7Tza0N6Xg7376CkXr5r7ZRFq7WbyCStZmGC9DPhJEQAsjZ7SUEAegVGKpfzSCQhJFAktWTvD8xEN6M:1tIZv7:IVWQGJ1KkwZT8fwA6vz-ABidwQGY52v1CTSs0wbLqD8', '2024-12-17 20:54:57.110398'),
('o92zit4uckqcc5qg1qd7s9idnpcplams', '.eJxVjEsOwjAMBe-SNYpCXNcNS_acIXLsQAookfpZIe4OlbqA7ZuZ9zKR16XEdc5THNWcDKA5_I6J5ZHrRvTO9dastLpMY7KbYnc620vT_Dzv7t9B4bl86yAeBdE5JA_AmTsZkPCqmCAw9QCZdEiuz0oiiV3S0HUeCEmOKmTeH_wmOAo:1tIhZJ:Pg8NZP7PpNuqj9S_f6qRLUqYHGlXSnQNQjNU4u9MmVA', '2024-12-18 05:04:57.867454'),
('qq6de08etx34f3az8p7qppd4547xdnrd', '.eJxVjMsOwiAURP-FtSFAebp07zcQuPdWqgaS0q6M_64kXehuMufMvFhM-1bi3mmNC7Izc-z02-UED6oD4D3VW-PQ6rYumQ-FH7Tza0N6Xg7376CkXr5r7ZRFq7WbyCStZmGC9DPhJEQAsjZ7SUEAegVGKpfzSCQhJFAktWTvD8xEN6M:1tIY8O:ZEyA-yneE09TAu2RIU__zZVUkinSPbeZtUqxhptnqo4', '2024-12-17 19:00:32.919793');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_admin_colegio`
--

CREATE TABLE `mattrix_admin_colegio` (
  `id_colegio` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_admin_colegio`
--

INSERT INTO `mattrix_admin_colegio` (`id_colegio`, `nombre`, `direccion`, `ciudad`) VALUES
(1, 'Prueba', 'Calle 1', 'Ciudad 1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_admin_cursos`
--

CREATE TABLE `mattrix_admin_cursos` (
  `id_curso` bigint(20) NOT NULL,
  `nivel` varchar(50) NOT NULL,
  `letra` varchar(1) NOT NULL,
  `colegio_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_admin_cursos`
--

INSERT INTO `mattrix_admin_cursos` (`id_curso`, `nivel`, `letra`, `colegio_id`) VALUES
(1, '7° Básico', 'A', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_admin_historicalcolegio`
--

CREATE TABLE `mattrix_admin_historicalcolegio` (
  `id_colegio` bigint(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `history_id` int(11) NOT NULL,
  `history_date` datetime(6) NOT NULL,
  `history_change_reason` varchar(100) DEFAULT NULL,
  `history_type` varchar(1) NOT NULL,
  `history_user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_etapas`
--

CREATE TABLE `mattrix_contenido_etapas` (
  `id_etapa` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` longtext NOT NULL,
  `componente` longtext NOT NULL,
  `dificultad` longtext NOT NULL,
  `habilidad_matematica` longtext NOT NULL,
  `posicion_x` int(11) NOT NULL,
  `posicion_y` int(11) NOT NULL,
  `id_nivel_id` varchar(10) NOT NULL,
  `OA_id` int(11) NOT NULL,
  `habilidad_bloom` longtext NOT NULL,
  `contenido_abordado` longtext NOT NULL,
  `es_ultima` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_etapas`
--

INSERT INTO `mattrix_contenido_etapas` (`id_etapa`, `nombre`, `descripcion`, `componente`, `dificultad`, `habilidad_matematica`, `posicion_x`, `posicion_y`, `id_nivel_id`, `OA_id`, `habilidad_bloom`, `contenido_abordado`, `es_ultima`) VALUES
(1, 'Concepto espacio muestral', 'A', 'EspacioMuestral', 'Intermedia', 'Resolución de problemas', 20, 60, 'PC01', 1, 'Conocer', 'Espacio Muestral', 0),
(2, 'Experimentos', 'Experimentos', 'ExperimentoEvento', 'Baja', 'Representrar', 60, 40, 'PC01', 1, 'Conocer', 'Espacio Muestral', 0),
(3, 'Tipos de Experimentos', 'Conoce y diferencia los experimentos aleatorios y los deterministas.', 'TiposDeExperimentos', 'Baja', 'Argumentar', 35, 55, 'P01', 1, 'Conocer', 'Espacio Muestral', 1),
(4, 'Pelotas', 'Pelotas', 'Pelotas', 'Baja', 'Argumentar', 80, 50, 'PC01', 1, 'Conocer', 'Espacio Muestral', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_indicadoresevaluacion`
--

CREATE TABLE `mattrix_contenido_indicadoresevaluacion` (
  `id_indicador` int(11) NOT NULL,
  `descripcion` longtext NOT NULL,
  `contenido` longtext NOT NULL,
  `OA_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_indicadoresevaluacion`
--

INSERT INTO `mattrix_contenido_indicadoresevaluacion` (`id_indicador`, `descripcion`, `contenido`, `OA_id`) VALUES
(1, 'Mediante experimentos, estiman la probabilidad de un evento, registrando las frecuencias relativas.', 'Frecuencias relativas', 1),
(2, 'Establecen la probabilidad de un evento mediante razones, fracciones o porcentajes, sea haciendo un experimento o por medio de un problema.', 'Probabilidad de Laplace', 1),
(3, 'Antes del experimento, estiman la probabilidad de ocurrencia y verifican su estimación, usando de frecuencias relativas.', 'Probabilidad de Laplace', 1),
(4, 'Elaboran, con material concreto (como dados y monedas), experimentos aleatorios con resultados equiprobables y no equiprobables.', 'Experimentos aleatorios', 1),
(5, 'Realizan los experimentos aleatorios con numerosas repeticiones, determinan las frecuencias absolutas relativas y representan los resultados mediante gráficos.', 'Experimentos aleatorios, Frecuencia absoluta relativa', 1),
(6, 'Analizan y comunican si se cumple aproximadamente la equiprobabilidad.', 'Probabilidad de Laplace', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_niveles`
--

CREATE TABLE `mattrix_contenido_niveles` (
  `id_nivel` varchar(10) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `fondo_id` int(11) DEFAULT NULL,
  `OA_id` int(11) NOT NULL,
  `fondo_tarjeta_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_niveles`
--

INSERT INTO `mattrix_contenido_niveles` (`id_nivel`, `nombre`, `fondo_id`, `OA_id`, `fondo_tarjeta_id`) VALUES
('P01', 'Probabilidad clásica 01', 8, 1, 13),
('PC01', 'Prueba', 14, 1, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_oa`
--

CREATE TABLE `mattrix_contenido_oa` (
  `id_OA` int(11) NOT NULL,
  `OA` varchar(255) NOT NULL,
  `descripcion` longtext NOT NULL,
  `nivel_asociado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_oa`
--

INSERT INTO `mattrix_contenido_oa` (`id_OA`, `OA`, `descripcion`, `nivel_asociado`) VALUES
(1, 'OA1', 'Descripción del OA1', '1° Medio');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_problemaprobabilidad`
--

CREATE TABLE `mattrix_contenido_problemaprobabilidad` (
  `id_problema` int(11) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `enunciado` longtext NOT NULL,
  `espacio_muestral` longtext NOT NULL,
  `elementos_evento` longtext NOT NULL,
  `numerador` int(11) NOT NULL,
  `denominador` int(11) NOT NULL,
  `creado_en` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_terminospareados`
--

CREATE TABLE `mattrix_contenido_terminospareados` (
  `id_termino` int(11) NOT NULL,
  `uso` varchar(255) NOT NULL,
  `concepto` varchar(255) NOT NULL,
  `definicion` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_terminospareados`
--

INSERT INTO `mattrix_contenido_terminospareados` (`id_termino`, `uso`, `concepto`, `definicion`) VALUES
(1, 'conceptos', 'Experimento determinístico', 'Se conoce el resultado del experimento antes de realizarlo. Por ejemplo, si se deja caer una pelota desde cierta altura sabemos que caerá hasta tocar el suelo.'),
(2, 'conceptos', 'Experimento aleatorio', 'Se conocen todos los posibles resultados, pero no se puede saber cuál ocurrirá al realizar el experimento. Por ejemplo, al lanzar una moneda, se puede obtener cara o sello, pero no sabemos cuál va a salir con certeza.'),
(3, 'conceptos', 'Espacio muestral', 'Todos los posibles resultados de un experimento. Por ejemplo, al lanzar un dado, el espacio muestral es 1, 2, 3, 4, 5 y 6.'),
(4, 'conceptos', 'Suceso o evento', 'Es cualquier conjunto de resultados posibles en un experimento aleatorio. Por ejemplo, al lanzar un dado un evento podría ser \"que salga un número par\".'),
(5, 'conceptos', 'Sucesos o eventos equiprobables', 'Son aquellos sucesos o eventos que tienen la misma probabilidad de ocurrir.'),
(6, 'experimento', 'Lanzar una moneda.', 'Que salga cara.'),
(7, 'experimento', 'Lanzar un dado de 6 caras.', 'Obtener un número mayor a 4.'),
(8, 'experimento', 'Sacar una carta de una baraja inglesa.', 'Sacar una carta de corazones.'),
(9, 'experimento', 'Lanzar dos dados a la vez.', 'La suma de los dos dados es 10.'),
(10, 'experimento', 'Seleccionar al azar un número entre 1 y 100.', 'Seleccionar un número primo.'),
(11, 'experimento', 'Tirar una moneda tres veces.', 'Obtener exactamente 2 sellos.'),
(12, 'experimento', 'Elegir una letra al azar de la palabra \"JERE KLEIN\".', 'Elegir una letra \"K\".'),
(13, 'experimento', 'Medir la temperatura en una ciudad al mediodía.', 'La temperatura es superior a 21°C.'),
(14, 'experimento', 'Lanzar una moneda y un dado.', 'Obtener una cara y un número impar.'),
(15, 'experimento', 'Elegir una galleta al azar.', 'Que la galleta sea de chocolate.'),
(16, 'agrupar_experimentos', 'aleatorio', 'Lanzar un dado'),
(17, 'agrupar_experimentos', 'aleatorio', 'Lanzar una moneda'),
(18, 'agrupar_experimentos', 'aleatorio', 'Sacar una carta al azar de una baraja'),
(19, 'agrupar_experimentos', 'aleatorio', 'Elegir al azar una letra de la palabra \"PANCITO\"'),
(20, 'agrupar_experimentos', 'determinista', 'Dejar caer una pelota al suelo'),
(21, 'agrupar_experimentos', 'determinista', 'Cortar una cuerda en dos partes iguales'),
(22, 'agrupar_experimentos', 'determinista', 'Encender el motor de un auto'),
(23, 'agrupar_experimentos', 'determinista', 'Mirar la hora cada 5 minutos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_docentes_avanceestudiantes`
--

CREATE TABLE `mattrix_docentes_avanceestudiantes` (
  `id_avance` bigint(20) NOT NULL,
  `tiempo` varchar(8) NOT NULL,
  `fecha_completada` datetime(6) NOT NULL,
  `logro` int(10) UNSIGNED NOT NULL CHECK (`logro` >= 0),
  `estudiante_id` int(11) NOT NULL,
  `etapa_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_docentes_docenteestudiante`
--

CREATE TABLE `mattrix_docentes_docenteestudiante` (
  `id` bigint(20) NOT NULL,
  `confirmado` tinyint(1) NOT NULL,
  `docente_id` bigint(20) NOT NULL,
  `estudiante_id` bigint(20) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_docentes_respuestaescrita`
--

CREATE TABLE `mattrix_docentes_respuestaescrita` (
  `id` bigint(20) NOT NULL,
  `respuesta1` longtext NOT NULL,
  `respuesta2` longtext DEFAULT NULL,
  `respuesta3` longtext DEFAULT NULL,
  `id_avance_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_usuarios_imagenes`
--

CREATE TABLE `mattrix_usuarios_imagenes` (
  `id_imagen` int(11) NOT NULL,
  `imagen` varchar(100) NOT NULL,
  `uso` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_usuarios_imagenes`
--

INSERT INTO `mattrix_usuarios_imagenes` (`id_imagen`, `imagen`, `uso`) VALUES
(1, 'avatars/avatar_None.png', 'avatar'),
(2, 'avatars/avatar_None_nindhks.png', 'avatar'),
(3, 'avatars/avatar_None_A6B9oWF.png', 'avatar'),
(4, 'avatars/avatar_None_ntLOrzR.png', 'avatar'),
(5, 'avatars/avatar_None.jpg', 'avatar'),
(6, 'avatars/avatar_None_MDp2Ri9.jpg', 'avatar'),
(7, 'fondos/fondo_nivel_None.png', 'fondo-nivel'),
(8, 'fondos/fondo_nivel_8_MqxfeUK.png', 'fondo-nivel'),
(10, 'avatars/avatar_None_SmqsF8p.jpg', 'avatar'),
(11, 'avatars/avatar_11.jpg', 'avatar'),
(12, 'fondos/fondo_nivel_12.png', 'fondo-nivel'),
(13, 'fondos/fondo_nivel_13.png', 'fondo-nivel'),
(14, 'fondos/fondo_nivel_14_Z0g43dy.png', 'fondo-nivel'),
(15, 'fondos/fondo_nivel_15.png', 'fondo-nivel');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_usuarios_profile`
--

CREATE TABLE `mattrix_usuarios_profile` (
  `id` bigint(20) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `pais` varchar(20) NOT NULL,
  `rut` varchar(12) NOT NULL,
  `avatarUser_id` int(11) DEFAULT NULL,
  `colegio_id` bigint(20) DEFAULT NULL,
  `curso_id` bigint(20) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_usuarios_profile`
--

INSERT INTO `mattrix_usuarios_profile` (`id`, `rol`, `pais`, `rut`, `avatarUser_id`, `colegio_id`, `curso_id`, `user_id`) VALUES
(21, 'student', '', '', 5, 1, 1, 35);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indices de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indices de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indices de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indices de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indices de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indices de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indices de la tabla `mattrix_admin_colegio`
--
ALTER TABLE `mattrix_admin_colegio`
  ADD PRIMARY KEY (`id_colegio`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `nombre_unico_ciudad` (`nombre`,`ciudad`);

--
-- Indices de la tabla `mattrix_admin_cursos`
--
ALTER TABLE `mattrix_admin_cursos`
  ADD PRIMARY KEY (`id_curso`),
  ADD UNIQUE KEY `unique_curso` (`nivel`,`letra`,`colegio_id`),
  ADD KEY `mattrix_admin_cursos_colegio_id_c75f8fda_fk_mattrix_a` (`colegio_id`);

--
-- Indices de la tabla `mattrix_admin_historicalcolegio`
--
ALTER TABLE `mattrix_admin_historicalcolegio`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `mattrix_admin_histor_history_user_id_827819b5_fk_auth_user` (`history_user_id`),
  ADD KEY `mattrix_admin_historicalcolegio_id_colegio_c5f73e2b` (`id_colegio`),
  ADD KEY `mattrix_admin_historicalcolegio_nombre_9443ae41` (`nombre`),
  ADD KEY `mattrix_admin_historicalcolegio_history_date_b43f0a51` (`history_date`);

--
-- Indices de la tabla `mattrix_contenido_etapas`
--
ALTER TABLE `mattrix_contenido_etapas`
  ADD PRIMARY KEY (`id_etapa`),
  ADD KEY `mattrix_contenido_et_id_nivel_id_dc32cc23_fk_mattrix_c` (`id_nivel_id`),
  ADD KEY `mattrix_contenido_et_OA_id_c9bda8dc_fk_mattrix_c` (`OA_id`);

--
-- Indices de la tabla `mattrix_contenido_indicadoresevaluacion`
--
ALTER TABLE `mattrix_contenido_indicadoresevaluacion`
  ADD PRIMARY KEY (`id_indicador`),
  ADD KEY `mattrix_contenido_in_OA_id_967e88ed_fk_mattrix_c` (`OA_id`);

--
-- Indices de la tabla `mattrix_contenido_niveles`
--
ALTER TABLE `mattrix_contenido_niveles`
  ADD PRIMARY KEY (`id_nivel`),
  ADD KEY `mattrix_contenido_ni_fondo_id_f59f6dc5_fk_mattrix_u` (`fondo_id`),
  ADD KEY `mattrix_contenido_ni_OA_id_b39c4357_fk_mattrix_c` (`OA_id`),
  ADD KEY `mattrix_contenido_ni_fondo_tarjeta_id_02fba9cd_fk_mattrix_u` (`fondo_tarjeta_id`);

--
-- Indices de la tabla `mattrix_contenido_oa`
--
ALTER TABLE `mattrix_contenido_oa`
  ADD PRIMARY KEY (`id_OA`);

--
-- Indices de la tabla `mattrix_contenido_problemaprobabilidad`
--
ALTER TABLE `mattrix_contenido_problemaprobabilidad`
  ADD PRIMARY KEY (`id_problema`);

--
-- Indices de la tabla `mattrix_contenido_terminospareados`
--
ALTER TABLE `mattrix_contenido_terminospareados`
  ADD PRIMARY KEY (`id_termino`);

--
-- Indices de la tabla `mattrix_docentes_avanceestudiantes`
--
ALTER TABLE `mattrix_docentes_avanceestudiantes`
  ADD PRIMARY KEY (`id_avance`),
  ADD KEY `mattrix_docentes_ava_estudiante_id_5b9d34f3_fk_auth_user` (`estudiante_id`),
  ADD KEY `mattrix_docentes_ava_etapa_id_1ee7181e_fk_mattrix_c` (`etapa_id`);

--
-- Indices de la tabla `mattrix_docentes_docenteestudiante`
--
ALTER TABLE `mattrix_docentes_docenteestudiante`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mattrix_docentes_docente_docente_id_estudiante_id_8eebf7fd_uniq` (`docente_id`,`estudiante_id`),
  ADD KEY `mattrix_docentes_doc_estudiante_id_f9359e40_fk_mattrix_u` (`estudiante_id`);

--
-- Indices de la tabla `mattrix_docentes_respuestaescrita`
--
ALTER TABLE `mattrix_docentes_respuestaescrita`
  ADD PRIMARY KEY (`id`),
  ADD KEY `mattrix_docentes_res_id_avance_id_febd98e5_fk_mattrix_d` (`id_avance_id`);

--
-- Indices de la tabla `mattrix_usuarios_imagenes`
--
ALTER TABLE `mattrix_usuarios_imagenes`
  ADD PRIMARY KEY (`id_imagen`);

--
-- Indices de la tabla `mattrix_usuarios_profile`
--
ALTER TABLE `mattrix_usuarios_profile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `rut` (`rut`),
  ADD KEY `mattrix_usuarios_pro_avatarUser_id_53e9e892_fk_mattrix_u` (`avatarUser_id`),
  ADD KEY `mattrix_usuarios_pro_colegio_id_45d247d5_fk_mattrix_a` (`colegio_id`),
  ADD KEY `mattrix_usuarios_pro_curso_id_65de4eed_fk_mattrix_a` (`curso_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=96;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_colegio`
--
ALTER TABLE `mattrix_admin_colegio`
  MODIFY `id_colegio` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_cursos`
--
ALTER TABLE `mattrix_admin_cursos`
  MODIFY `id_curso` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_historicalcolegio`
--
ALTER TABLE `mattrix_admin_historicalcolegio`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_etapas`
--
ALTER TABLE `mattrix_contenido_etapas`
  MODIFY `id_etapa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_indicadoresevaluacion`
--
ALTER TABLE `mattrix_contenido_indicadoresevaluacion`
  MODIFY `id_indicador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_oa`
--
ALTER TABLE `mattrix_contenido_oa`
  MODIFY `id_OA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_problemaprobabilidad`
--
ALTER TABLE `mattrix_contenido_problemaprobabilidad`
  MODIFY `id_problema` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_terminospareados`
--
ALTER TABLE `mattrix_contenido_terminospareados`
  MODIFY `id_termino` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `mattrix_docentes_avanceestudiantes`
--
ALTER TABLE `mattrix_docentes_avanceestudiantes`
  MODIFY `id_avance` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `mattrix_docentes_docenteestudiante`
--
ALTER TABLE `mattrix_docentes_docenteestudiante`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `mattrix_docentes_respuestaescrita`
--
ALTER TABLE `mattrix_docentes_respuestaescrita`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mattrix_usuarios_imagenes`
--
ALTER TABLE `mattrix_usuarios_imagenes`
  MODIFY `id_imagen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `mattrix_usuarios_profile`
--
ALTER TABLE `mattrix_usuarios_profile`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Filtros para la tabla `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Filtros para la tabla `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `mattrix_admin_cursos`
--
ALTER TABLE `mattrix_admin_cursos`
  ADD CONSTRAINT `mattrix_admin_cursos_colegio_id_c75f8fda_fk_mattrix_a` FOREIGN KEY (`colegio_id`) REFERENCES `mattrix_admin_colegio` (`id_colegio`);

--
-- Filtros para la tabla `mattrix_admin_historicalcolegio`
--
ALTER TABLE `mattrix_admin_historicalcolegio`
  ADD CONSTRAINT `mattrix_admin_histor_history_user_id_827819b5_fk_auth_user` FOREIGN KEY (`history_user_id`) REFERENCES `auth_user` (`id`);

--
-- Filtros para la tabla `mattrix_contenido_etapas`
--
ALTER TABLE `mattrix_contenido_etapas`
  ADD CONSTRAINT `mattrix_contenido_et_OA_id_c9bda8dc_fk_mattrix_c` FOREIGN KEY (`OA_id`) REFERENCES `mattrix_contenido_oa` (`id_OA`),
  ADD CONSTRAINT `mattrix_contenido_et_id_nivel_id_dc32cc23_fk_mattrix_c` FOREIGN KEY (`id_nivel_id`) REFERENCES `mattrix_contenido_niveles` (`id_nivel`);

--
-- Filtros para la tabla `mattrix_contenido_indicadoresevaluacion`
--
ALTER TABLE `mattrix_contenido_indicadoresevaluacion`
  ADD CONSTRAINT `mattrix_contenido_in_OA_id_967e88ed_fk_mattrix_c` FOREIGN KEY (`OA_id`) REFERENCES `mattrix_contenido_oa` (`id_OA`);

--
-- Filtros para la tabla `mattrix_contenido_niveles`
--
ALTER TABLE `mattrix_contenido_niveles`
  ADD CONSTRAINT `mattrix_contenido_ni_OA_id_b39c4357_fk_mattrix_c` FOREIGN KEY (`OA_id`) REFERENCES `mattrix_contenido_oa` (`id_OA`),
  ADD CONSTRAINT `mattrix_contenido_ni_fondo_id_f59f6dc5_fk_mattrix_u` FOREIGN KEY (`fondo_id`) REFERENCES `mattrix_usuarios_imagenes` (`id_imagen`),
  ADD CONSTRAINT `mattrix_contenido_ni_fondo_tarjeta_id_02fba9cd_fk_mattrix_u` FOREIGN KEY (`fondo_tarjeta_id`) REFERENCES `mattrix_usuarios_imagenes` (`id_imagen`);

--
-- Filtros para la tabla `mattrix_docentes_avanceestudiantes`
--
ALTER TABLE `mattrix_docentes_avanceestudiantes`
  ADD CONSTRAINT `mattrix_docentes_ava_estudiante_id_5b9d34f3_fk_auth_user` FOREIGN KEY (`estudiante_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `mattrix_docentes_ava_etapa_id_1ee7181e_fk_mattrix_c` FOREIGN KEY (`etapa_id`) REFERENCES `mattrix_contenido_etapas` (`id_etapa`);

--
-- Filtros para la tabla `mattrix_docentes_docenteestudiante`
--
ALTER TABLE `mattrix_docentes_docenteestudiante`
  ADD CONSTRAINT `mattrix_docentes_doc_docente_id_b1f21e35_fk_mattrix_u` FOREIGN KEY (`docente_id`) REFERENCES `mattrix_usuarios_profile` (`id`),
  ADD CONSTRAINT `mattrix_docentes_doc_estudiante_id_f9359e40_fk_mattrix_u` FOREIGN KEY (`estudiante_id`) REFERENCES `mattrix_usuarios_profile` (`id`);

--
-- Filtros para la tabla `mattrix_docentes_respuestaescrita`
--
ALTER TABLE `mattrix_docentes_respuestaescrita`
  ADD CONSTRAINT `mattrix_docentes_res_id_avance_id_febd98e5_fk_mattrix_d` FOREIGN KEY (`id_avance_id`) REFERENCES `mattrix_docentes_avanceestudiantes` (`id_avance`);

--
-- Filtros para la tabla `mattrix_usuarios_profile`
--
ALTER TABLE `mattrix_usuarios_profile`
  ADD CONSTRAINT `mattrix_usuarios_pro_avatarUser_id_53e9e892_fk_mattrix_u` FOREIGN KEY (`avatarUser_id`) REFERENCES `mattrix_usuarios_imagenes` (`id_imagen`),
  ADD CONSTRAINT `mattrix_usuarios_pro_colegio_id_45d247d5_fk_mattrix_a` FOREIGN KEY (`colegio_id`) REFERENCES `mattrix_admin_colegio` (`id_colegio`),
  ADD CONSTRAINT `mattrix_usuarios_pro_curso_id_65de4eed_fk_mattrix_a` FOREIGN KEY (`curso_id`) REFERENCES `mattrix_admin_cursos` (`id_curso`),
  ADD CONSTRAINT `mattrix_usuarios_profile_user_id_6ef634fa_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
