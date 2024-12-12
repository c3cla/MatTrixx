-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-12-2024 a las 16:05:17
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarAvatarDocente` (IN `docente_id` INT, IN `avatar_id` INT)   BEGIN
    UPDATE mattrix_usuarios_profile
    SET avatarUser_id = avatar_id
    WHERE id = docente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerAvancesEstudiante` (IN `user_id` INT)   BEGIN
    -- Detalle de los avances
    SELECT 
        et.nombre AS etapa,
        oa.OA AS objetivo_aprendizaje,
        n.nombre AS nivel,
        et.habilidad_matematica,
        et.habilidad_bloom,
        et.dificultad,
        a.logro,
        a.tiempo
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_contenido_etapas et ON a.etapa_id = et.id_etapa
    INNER JOIN 
        mattrix_contenido_niveles n ON et.id_nivel_id = n.id_nivel
    INNER JOIN 
        mattrix_contenido_oa oa ON et.OA_id = oa.id_OA
    INNER JOIN 
        auth_user u ON a.estudiante_id = u.id  -- Cambio aquí para usar user.id
    WHERE 
        u.id = user_id;

    -- Logro promedio por Objetivo de Aprendizaje
    SELECT 
        oa.OA AS objetivo_aprendizaje,
        ROUND(AVG(a.logro), 0) AS promedio_logro
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_contenido_etapas et ON a.etapa_id = et.id_etapa
    INNER JOIN 
        mattrix_contenido_oa oa ON et.OA_id = oa.id_OA
    INNER JOIN 
        auth_user u ON a.estudiante_id = u.id  -- Cambio aquí para usar user.id
    WHERE 
        u.id = user_id
    GROUP BY 
        oa.id_OA;

    -- Logro promedio por dificultad
    SELECT 
        et.dificultad,
        ROUND(AVG(a.logro), 0) AS promedio_logro
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_contenido_etapas et ON a.etapa_id = et.id_etapa
    INNER JOIN 
        auth_user u ON a.estudiante_id = u.id  -- Cambio aquí para usar user.id
    WHERE 
        u.id = user_id
    GROUP BY 
        et.dificultad;

    -- Distribución de habilidades matemáticas
    SELECT 
        et.habilidad_matematica AS habilidad,
        COUNT(*) AS cantidad
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_contenido_etapas et ON a.etapa_id = et.id_etapa
    INNER JOIN 
        auth_user u ON a.estudiante_id = u.id  -- Cambio aquí para usar user.id
    WHERE 
        u.id = user_id
    GROUP BY 
        et.habilidad_matematica;

    -- Distribución de habilidades de Bloom
    SELECT 
        et.habilidad_bloom AS habilidad,
        COUNT(*) AS cantidad
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_contenido_etapas et ON a.etapa_id = et.id_etapa
    INNER JOIN 
        auth_user u ON a.estudiante_id = u.id  -- Cambio aquí para usar user.id
    WHERE 
        u.id = user_id
    GROUP BY 
        et.habilidad_bloom;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerAvataresDocente` ()   BEGIN
    SELECT id_imagen, imagen
    FROM mattrix_usuarios_imagenes
    WHERE uso = 'avatarDocente';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerAvatarEstudiante` (IN `p_avatar_usuario` INT, OUT `p_imagen` VARCHAR(255))   BEGIN
    SELECT 
        imagen
    INTO 
        p_imagen
    FROM 
        mattrix_usuarios_imagenes
    WHERE 
        id_imagen = p_avatar_usuario;

    -- Si no se encuentra una coincidencia, devolver una imagen genérica
    IF p_imagen IS NULL THEN
        SET p_imagen = 'avatars/avatar_1.png';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerDatosEstudiante` (IN `user_id` INT, OUT `nombre_completo` VARCHAR(255), OUT `id_usuario` INT, OUT `avatar_usuario` VARCHAR(255))   BEGIN
    SELECT 
        CONCAT(auth_user.first_name, ' ', auth_user.last_name) AS nombre_completo,
        auth_user.id AS id_usuario,
        mattrix_usuarios_profile.avatarUser_id AS avatar_usuario
    INTO 
        nombre_completo, id_usuario, avatar_usuario
    FROM 
        auth_user
    INNER JOIN 
        mattrix_usuarios_profile ON auth_user.id = mattrix_usuarios_profile.user_id
    WHERE 
        auth_user.id = user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerEstadisticasCompletas` (IN `estudiante_id` INT)   BEGIN
    DECLARE user_id INT;

    -- Obtener el user_id a partir del estudiante_id
    SELECT user_id
    FROM mattrix_usuarios_profile
    WHERE id = estudianteId;

    -- Validar si se encontró el user_id
    IF user_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró el user_id para el estudiante.';
    END IF;

    -- Obtener estadísticas del estudiante (reemplaza aquí por las consultas necesarias)
    SELECT 
        ae.id_avance AS id_avance,
        e.nombre AS nombre_etapa,
        e.contenido_abordado,
        e.dificultad,
        e.habilidad_matematica,
        e.habilidad_bloom,
        ae.logro,
        ae.tiempo,
        ae.fecha_completada
    FROM mattrix_docentes_avanceestudiantes ae
    JOIN mattrix_contenido_etapas e ON ae.etapa_id = e.id_etapa
    WHERE ae.estudiante_id = user_id;

    -- Logro por dificultad
    SELECT 
        e.dificultad,
        AVG(ae.logro) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvanceEstudiantes ae
    JOIN Etapas e ON ae.etapa_id = e.id_etapa
    WHERE ae.estudiante_id = user_id
    GROUP BY e.dificultad;

    -- Logro por habilidad matemática
    SELECT 
        e.habilidad_matematica,
        AVG(ae.logro) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvanceEstudiantes ae
    JOIN Etapas e ON ae.etapa_id = e.id_etapa
    WHERE ae.estudiante_id = user_id
    GROUP BY e.habilidad_matematica;

    -- Logro por habilidad de Bloom
    SELECT 
        e.habilidad_bloom,
        AVG(ae.logro) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvanceEstudiantes ae
    JOIN Etapas e ON ae.etapa_id = e.id_etapa
    WHERE ae.estudiante_id = user_id
    GROUP BY e.habilidad_bloom;

    -- Etapas ordenadas por fecha
    SELECT 
        e.contenido_abordado,
        ae.logro,
        ae.fecha_completada
    FROM AvanceEstudiantes ae
    JOIN Etapas e ON ae.etapa_id = e.id_etapa
    WHERE ae.estudiante_id = user_id
    ORDER BY ae.fecha_completada;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerEstadisticasEstudianteMainDocente` (IN `user_id` INT)   BEGIN
    -- Crear tabla temporal con los avances del estudiante
    CREATE TEMPORARY TABLE IF NOT EXISTS AvancesTemporal AS (
        SELECT 
            ae.etapa_id AS id_etapa,
            e.nombre AS nombre_etapa,
            e.contenido_abordado,
            e.dificultad,
            e.habilidad_matematica,
            e.habilidad_bloom,
            ae.logro,
            ae.tiempo,
            ae.fecha_completada
        FROM mattrix_docentes_avanceestudiantes ae
        JOIN mattrix_contenido_etapas e ON ae.etapa_id = e.id_etapa
        WHERE ae.estudiante_id = user_id
    );

    -- Cantidad de etapas y tiempo total
    SELECT 
        COUNT(DISTINCT id_etapa) AS cantidad_etapas,
        SUM(CAST(tiempo AS UNSIGNED)) AS tiempo_total
    INTO @cantidad_etapas, @tiempo_total
    FROM AvancesTemporal;

    -- Logros por dificultad
    SELECT 
        dificultad,
        ROUND(AVG(logro),0) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvancesTemporal
    GROUP BY dificultad;

    -- Logros por habilidad matemática
    SELECT 
        habilidad_matematica,
        ROUND(AVG(logro),0) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvancesTemporal
    GROUP BY habilidad_matematica;

    -- Logros por habilidad de Bloom
    SELECT 
        habilidad_bloom,
        ROUND(AVG(logro),0) AS promedio_logro,
        COUNT(*) AS cantidad_intentos
    FROM AvancesTemporal
    GROUP BY habilidad_bloom;

    -- Gráfico de etapas ordenadas por fecha
    SELECT 
        contenido_abordado,
        logro,
        fecha_completada
    FROM AvancesTemporal
    ORDER BY fecha_completada ASC;

    -- Detalle extendido por etapa
    SELECT 
        id_etapa,
        nombre_etapa,
        contenido_abordado,
        dificultad,
        habilidad_matematica,
        habilidad_bloom,
        logro,
        tiempo,
        fecha_completada
    FROM AvancesTemporal
    ORDER BY id_etapa;

    -- Limpieza de tabla temporal
    DROP TEMPORARY TABLE IF EXISTS AvancesTemporal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerEstadisticasPorEstudiante` (IN `id_estudiante` INT)   BEGIN
    -- Promedio por etapa
    SELECT     	
        et.nombre AS NombreEtapa,
        et.descripcion AS DescripcionEtapa,
        ROUND(AVG(ae.logro),0) AS PromedioPorcentajeLogro,
        SUM(ae.tiempo) AS TiempoTotalDestinado,
        COUNT(ae.etapa_id) AS CantidadRegistros
    FROM 
        mattrix_docentes_avanceestudiantes ae
    INNER JOIN 
        mattrix_contenido_etapas et ON ae.etapa_id = et.id_etapa
    WHERE 
        ae.estudiante_id = id_estudiante
    GROUP BY 
        ae.etapa_id;

    -- Detalle por etapa
    SELECT 
        et.nombre AS NombreEtapa,
        ae.logro AS PorcentajeLogro,
        ae.tiempo AS TiempoDestinado
    FROM 
        mattrix_docentes_avanceestudiantes ae
    INNER JOIN 
        mattrix_contenido_etapas et ON ae.etapa_id = et.id_etapa
    WHERE 
        ae.estudiante_id = id_estudiante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerEstudiantesPorCurso` (IN `docente_id` INT)   BEGIN
    SELECT 
        CONCAT(c.nivel, ' ', c.letra) AS curso_nombre,
        e.id AS estudiante_id, 
        CONCAT(u.first_name, ' ', u.last_name) AS estudiante_nombre, 
        e.rut AS estudiante_rut
    FROM mattrix_docentes_docenteestudiante de
    INNER JOIN mattrix_usuarios_profile e ON de.estudiante_id = e.id
    INNER JOIN auth_user u ON e.user_id = u.id
    LEFT JOIN mattrix_admin_cursos c ON e.curso_id = c.id_curso
    WHERE de.docente_id = docente_id AND de.confirmado = TRUE
    ORDER BY curso_nombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProgresoHabilidad` (IN `TipoHabilidad` VARCHAR(100), IN `Habilidad` VARCHAR(100))   BEGIN
    IF TipoHabilidad = 'General' THEN
        SELECT 
            a.fecha_completada AS FechaEtapa, 
            a.logro AS NivelLogro
        FROM mattrix_docentes_avanceestudiantes a
        INNER JOIN mattrix_contenido_etapas e ON a.etapa_id = e.id_etapa
        WHERE e.habilidad_bloom = Habilidad
        ORDER BY a.fecha_completada ASC;
    ELSEIF TipoHabilidad = 'Matematica' THEN
        SELECT 
            a.fecha_completada AS FechaEtapa, 
            a.logro AS NivelLogro
        FROM mattrix_docentes_avanceestudiantes a
        INNER JOIN mattrix_contenido_etapas e ON a.etapa_id = e.id_etapa
        WHERE e.habilidad_matematica = Habilidad
        ORDER BY a.fecha_completada ASC;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerSaludoDocente` (IN `docente_id` INT)   BEGIN
    SELECT 
        u.username AS nombre_usuario, 
        i.imagen AS avatar
    FROM auth_user u
    INNER JOIN mattrix_usuarios_profile p ON u.id = p.user_id
    LEFT JOIN mattrix_usuarios_imagenes i ON i.id_imagen = p.avatarUser_id
    WHERE p.id = docente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerUserIdDesdeEstudianteId` (IN `estudianteId` INT, OUT `userId` INT)   BEGIN
    SELECT u.id INTO userId
    FROM auth_user u
    INNER JOIN mattrix_usuarios_profile p ON u.id = p.user_id
    WHERE p.id = estudianteId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerUserIdMainDocente` (IN `estudianteId` INT)   BEGIN
    SELECT user_id
    FROM mattrix_usuarios_profile
    WHERE id = estudianteId;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RespuestasEscritasPorEstudiante` (IN `estudiante_id` INT)   BEGIN
    SELECT 
        a.id_avance,
        a.etapa_id,
        e.nombre AS etapa_nombre,
        e.descripcion AS etapa_descripcion,
        r.pregunta,
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'respuesta', r.respuesta,
                'retroalimentacion', r.retroalimentacion
            )
        ) AS respuestas
    FROM 
        mattrix_docentes_avanceestudiantes a
    INNER JOIN 
        mattrix_docentes_respuestaescrita r ON a.id_avance = r.avance_id
    INNER JOIN
        mattrix_contenido_etapas e ON a.etapa_id = e.id_etapa
    WHERE 
        a.estudiante_id = estudiante_id
    GROUP BY 
        a.id_avance, 
        a.etapa_id, 
        e.nombre, 
        e.descripcion, 
        r.pregunta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ObtenerProgresoHabilidad` (IN `TipoHabilidad` VARCHAR(100), IN `Habilidad` VARCHAR(100))   BEGIN
    IF TipoHabilidad = 'General' THEN
        SELECT 
            a.fecha_completada AS FechaEtapa, 
            a.logro AS NivelLogro,
            e.nombre AS NombreEtapa
        FROM mattrix_docentes_avanceestudiantes a
        INNER JOIN mattrix_contenido_etapas e ON a.etapa_id = e.id_etapa
        WHERE e.habilidad_bloom = Habilidad
        ORDER BY a.fecha_completada ASC;
    ELSEIF TipoHabilidad = 'Matematica' THEN
        SELECT 
            a.fecha_completada AS FechaEtapa, 
            a.logro AS NivelLogro,
            e.nombre AS NombreEtapa
        FROM mattrix_docentes_avanceestudiantes a
        INNER JOIN mattrix_contenido_etapas e ON a.etapa_id = e.id_etapa
        WHERE e.habilidad_matematica = Habilidad
        ORDER BY a.fecha_completada ASC;
    END IF;
END$$

DELIMITER ;

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
(35, 'pbkdf2_sha256$870000$455EHeWPTkCieEjWVIGxtE$bXmrvll+E+vOopop3nXwiICJzxjqRrOrDKLbCHfxOhY=', '2024-12-04 05:04:57.000000', 1, 'Clau', 'Claudia', 'Videla', 'c@gmail.com', 1, 1, '2024-12-04 05:04:33.000000'),
(77, 'pbkdf2_sha256$870000$SDLHLz5utahFulhkEgFGoe$wAjgXdSrJo5vfLFSV/UlSyrpeBEYuPnE12WuIiEAnc8=', NULL, 0, 'Profe1', 'Clau', 'Videla', '', 0, 1, '2024-12-06 06:02:51.000000'),
(110, 'pbkdf2_sha256$870000$0hAOdzDJagEGKxPOzvlW3m$weih3ecmy8xjo21OuMb76SUQiK/iq0+IrbCHm+MI9RI=', NULL, 0, 'Est2', 'Estudiante', '2', '3233c@cl.cl', 0, 1, '2024-12-11 23:33:27.980394'),
(111, 'pbkdf2_sha256$870000$RyGZfNFAVQoprMLK5PbIlX$wbDGCUHl9/kBulaNrQEldMNUJmzrzm8T3csnShrGW8o=', NULL, 1, 'Admin', 'Claudia', 'Videla', 'cvidelasandoval@gmail.com', 0, 1, '2024-12-12 01:50:21.000000'),
(113, 'pbkdf2_sha256$870000$tvM4rnUrBt1lZerEjDqG3Y$bUHzniwq6m865agiQAeGJtOVk1PY+DyYnQkP7oZPEXA=', NULL, 0, 'est7', 'Estudiante', '7', 'e7@d.cl', 0, 1, '2024-12-12 04:27:40.020191'),
(114, 'pbkdf2_sha256$870000$jMIiqhoXSPHVjACXObmgTW$Q9StYUE9EKnmxyULrFVihvijFM7aOJG//T6ii5WLRmY=', NULL, 0, 'est9', 'Estudiante', '9', 'e9@d.cl', 0, 1, '2024-12-12 06:14:43.984151'),
(115, 'pbkdf2_sha256$870000$IPDW45xdEKA5SICXreiJGk$uhJv/5CjIxhXT7GqezR4KB+PCII3/WXFw9DAbNC5rto=', NULL, 0, 'Est12', 'Estudiante', '91', 'correo@s.cl', 0, 1, '2024-12-12 06:21:16.850319');

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
(95, '2024-12-04 07:15:57.188559', '34', 'DV@4@HONAuFWmZ5VegcWHfHPmhgsEz3Lo0B8gbUAppykC-k79nWwr - student', 3, '', 11, 35),
(96, '2024-12-04 14:16:12.572167', '46', 'Clau10', 3, '', 4, 35),
(97, '2024-12-04 14:16:12.572167', '47', 'Clau11', 3, '', 4, 35),
(98, '2024-12-04 14:16:12.572167', '48', 'Clau12', 3, '', 4, 35),
(99, '2024-12-04 14:16:12.572167', '49', 'Clau13', 3, '', 4, 35),
(100, '2024-12-04 14:16:12.572167', '50', 'Clau14', 3, '', 4, 35),
(101, '2024-12-04 14:16:12.572167', '51', 'Clau15', 3, '', 4, 35),
(102, '2024-12-04 14:16:12.572167', '52', 'Clau16', 3, '', 4, 35),
(103, '2024-12-04 14:16:12.572167', '53', 'Clau17', 3, '', 4, 35),
(104, '2024-12-04 14:16:12.572167', '54', 'Clau18', 3, '', 4, 35),
(105, '2024-12-04 14:16:12.572167', '55', 'Clau19', 3, '', 4, 35),
(106, '2024-12-04 14:16:12.572167', '36', 'Clau2', 3, '', 4, 35),
(107, '2024-12-04 14:16:12.572167', '56', 'Clau20', 3, '', 4, 35),
(108, '2024-12-04 14:16:12.572167', '58', 'Clau21', 3, '', 4, 35),
(109, '2024-12-04 14:16:12.572167', '59', 'Clau22', 3, '', 4, 35),
(110, '2024-12-04 14:16:12.572167', '65', 'Clau23', 3, '', 4, 35),
(111, '2024-12-04 14:16:12.572167', '37', 'Clau3', 3, '', 4, 35),
(112, '2024-12-04 14:16:12.572167', '38', 'Clau4', 3, '', 4, 35),
(113, '2024-12-04 14:16:12.572167', '39', 'Clau5', 3, '', 4, 35),
(114, '2024-12-04 14:16:12.572167', '40', 'Clau6', 3, '', 4, 35),
(115, '2024-12-04 14:16:12.572167', '44', 'Clau8', 3, '', 4, 35),
(116, '2024-12-04 14:16:12.572167', '45', 'Clau9', 3, '', 4, 35),
(117, '2024-12-04 14:16:12.572167', '68', 'DV@4@HONAuFWmZ5VegcWHfHPmhgsEz3Lo0B8gbUAppykC-k79nWwr', 3, '', 4, 35),
(118, '2024-12-04 14:16:12.572167', '69', 'ghcsdd@b222q+G++', 3, '', 4, 35),
(119, '2024-12-04 14:16:12.572167', '70', 'ghcsdd@b222qk+G++', 3, '', 4, 35),
(120, '2024-12-04 14:16:12.572167', '63', 'Gs6vrjt+RqQHw-DdQ2DCv', 3, '', 4, 35),
(121, '2024-12-04 14:16:12.573165', '64', 'Gs6vrjt+RqQHwss-DdQ2DCv', 3, '', 4, 35),
(122, '2024-12-04 14:16:12.573165', '66', 'Gs6vrjt+RqQHwss-sssDdQ2DCv', 3, '', 4, 35),
(123, '2024-12-04 14:16:12.573165', '67', 'Gs6vrjtss+RqQHwss-sssDdQ2DCv', 3, '', 4, 35),
(124, '2024-12-04 14:16:12.573165', '57', 'rE4ABXo+r0njgR2i8t', 3, '', 4, 35),
(125, '2024-12-04 14:16:12.573165', '60', 'rE4ABXo+r0njgR2iz8t', 3, '', 4, 35),
(126, '2024-12-04 14:16:12.573165', '42', 'ssy', 3, '', 4, 35),
(127, '2024-12-04 14:16:12.573165', '41', 'sy', 3, '', 4, 35),
(128, '2024-12-04 14:16:12.573165', '61', 'vamrdYrDoiGPIcEDw_ax0.', 3, '', 4, 35),
(129, '2024-12-04 14:16:12.573165', '62', 'vamrdYrDoiGPIcEssDw_ax0.', 3, '', 4, 35),
(130, '2024-12-04 14:39:33.360659', '16', 'Avatar 16', 1, '[{\"added\": {}}]', 10, 35),
(131, '2024-12-04 16:46:22.042573', '17', 'Clau - Concepto espacio muestral - 11 - 99%', 1, '[{\"added\": {}}]', 18, 35),
(132, '2024-12-06 00:43:28.554945', '17', 'Avatar 17', 1, '[{\"added\": {}}]', 10, 35),
(133, '2024-12-06 00:43:44.990465', '18', 'Fondo Nivel 18', 1, '[{\"added\": {}}]', 10, 35),
(134, '2024-12-06 00:45:12.743526', '19', 'Fondo Nivel 19', 1, '[{\"added\": {}}]', 10, 35),
(135, '2024-12-06 00:45:21.744521', '20', 'Avatar 20', 1, '[{\"added\": {}}]', 10, 35),
(136, '2024-12-06 02:58:01.618886', '27', 'Clau - Concepto espacio muestral - 11 - 99%', 1, '[{\"added\": {}}]', 18, 35),
(137, '2024-12-06 04:52:55.770099', '29', 'Clau - Experimentos - 17 - 100%', 3, '', 18, 35),
(138, '2024-12-06 04:52:55.770099', '28', 'Clau - Experimentos - 17 - 100%', 3, '', 18, 35),
(139, '2024-12-06 04:52:55.770099', '27', 'Clau - Concepto espacio muestral - 11 - 99%', 3, '', 18, 35),
(140, '2024-12-06 04:52:55.770099', '26', 'Clau - Tipos de Experimentos - 26 - 100%', 3, '', 18, 35),
(141, '2024-12-06 05:58:11.181244', '71', 'Clau2', 3, '', 4, 35),
(142, '2024-12-06 05:58:11.181244', '72', 'Clau3', 3, '', 4, 35),
(143, '2024-12-06 05:58:11.181244', '73', 'Clau4', 3, '', 4, 35),
(144, '2024-12-06 06:02:52.242541', '77', 'Profe1', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"Perfil\", \"object\": \"Profe1 - teacher\"}}]', 4, 35),
(145, '2024-12-06 06:29:20.774525', '77', 'Profe1', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}, {\"changed\": {\"name\": \"Perfil\", \"object\": \"Profe1 - teacher\", \"fields\": [\"Colegio\", \"Curso\"]}}]', 4, 35),
(146, '2024-12-06 06:31:45.635859', '35', 'Clau', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\"]}}, {\"changed\": {\"name\": \"Perfil\", \"object\": \"Clau - student\", \"fields\": [\"Pais\", \"Rut\"]}}]', 4, 35),
(147, '2024-12-06 16:29:56.559678', '7', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 2, '[]', 19, 35),
(148, '2024-12-06 17:02:47.459304', '8', 'Docente: Profe1 - Estudiante: est6 - Confirmado: True', 2, '[{\"changed\": {\"fields\": [\"Confirmado\"]}}]', 19, 35),
(149, '2024-12-06 17:02:57.156791', '7', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 2, '[]', 19, 35),
(150, '2024-12-06 17:03:00.125600', '8', 'Docente: Profe1 - Estudiante: est6 - Confirmado: False', 2, '[{\"changed\": {\"fields\": [\"Confirmado\"]}}]', 19, 35),
(151, '2024-12-06 17:06:23.518629', '7', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 3, '', 19, 35),
(152, '2024-12-06 17:18:13.512540', '9', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 3, '', 19, 35),
(153, '2024-12-06 18:42:50.390927', '10', 'Docente: Profe1 - Estudiante: Clau - Confirmado: True', 2, '[{\"changed\": {\"fields\": [\"Confirmado\"]}}]', 19, 35),
(154, '2024-12-07 17:45:18.850402', '21', 'Clau - student', 2, '[]', 11, 35),
(155, '2024-12-07 17:45:21.824122', '40', 'Profe1 - teacher', 2, '[{\"changed\": {\"fields\": [\"Colegio\", \"Curso\"]}}]', 11, 35),
(156, '2024-12-07 17:45:56.256648', '40', 'Profe1 - teacher', 2, '[{\"changed\": {\"fields\": [\"Colegio\", \"Curso\"]}}]', 11, 35),
(157, '2024-12-07 17:46:19.155209', '77', 'Profe1', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 4, 35),
(158, '2024-12-08 23:04:48.554008', '77', 'Profe1', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 4, 35),
(159, '2024-12-09 03:50:45.708862', '21', 'AvatarDocente 21', 1, '[{\"added\": {}}]', 10, 35),
(160, '2024-12-09 03:51:55.409487', '22', 'AvatarDocente 22', 1, '[{\"added\": {}}]', 10, 35),
(161, '2024-12-09 03:52:20.086734', '21', 'AvatarDocente 21', 3, '', 10, 35),
(162, '2024-12-09 04:38:19.037639', '23', 'AvatarDocente 23', 1, '[{\"added\": {}}]', 10, 35),
(163, '2024-12-09 06:08:33.570735', '78', 'est1', 3, '', 4, 35),
(164, '2024-12-09 06:08:33.570735', '79', 'est2', 3, '', 4, 35),
(165, '2024-12-09 06:08:33.570735', '80', 'est3', 3, '', 4, 35),
(166, '2024-12-09 06:08:33.570735', '81', 'est4', 3, '', 4, 35),
(167, '2024-12-09 06:08:33.570735', '82', 'est5', 3, '', 4, 35),
(168, '2024-12-09 06:08:33.570735', '83', 'est6', 3, '', 4, 35),
(169, '2024-12-09 06:09:27.972106', '84', 'Est7', 2, '[{\"added\": {\"name\": \"Perfil\", \"object\": \"Est7 - student\"}}]', 4, 35),
(170, '2024-12-09 22:31:47.109670', '24', 'Fondo Nivel 24', 1, '[{\"added\": {}}]', 10, 35),
(171, '2024-12-09 22:31:55.189802', '25', 'Fondo Nivel 25', 1, '[{\"added\": {}}]', 10, 35),
(172, '2024-12-09 22:32:38.437548', 'P01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"fields\": [\"Fondo tarjeta\"]}}]', 15, 35),
(173, '2024-12-09 22:32:51.224714', 'PC01', 'Prueba', 2, '[{\"changed\": {\"fields\": [\"Fondo tarjeta\"]}}]', 15, 35),
(174, '2024-12-10 19:21:12.108242', '36', 'Clau - Concepto espacio muestral - 11 - 99%', 1, '[{\"added\": {}}]', 18, 35),
(175, '2024-12-11 02:46:27.942987', '2', 'MA07OA18', 1, '[{\"added\": {}}]', 12, 35),
(176, '2024-12-11 02:46:42.139893', '3', 'MA08OA17', 1, '[{\"added\": {}}]', 12, 35),
(177, '2024-12-11 02:46:59.187171', '4', 'MA1MOA14', 1, '[{\"added\": {}}]', 12, 35),
(178, '2024-12-11 02:47:38.758574', '4', 'Indicador 4', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(179, '2024-12-11 02:47:48.727832', '2', 'Indicador 2', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(180, '2024-12-11 02:47:53.735487', '3', 'Indicador 3', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(181, '2024-12-11 02:47:57.986367', '6', 'Indicador 6', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(182, '2024-12-11 02:48:02.225042', '1', 'Indicador 1', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(183, '2024-12-11 02:48:05.503109', '5', 'Indicador 5', 2, '[{\"changed\": {\"fields\": [\"OA\"]}}]', 16, 35),
(184, '2024-12-11 02:48:45.000463', '3', 'Tipos de Experimentos', 3, '', 17, 35),
(185, '2024-12-11 02:48:45.000463', '4', 'Pelotas', 3, '', 17, 35),
(186, '2024-12-11 02:48:45.000463', '2', 'Experimentos', 3, '', 17, 35),
(187, '2024-12-11 02:48:45.000463', '1', 'Concepto espacio muestral', 3, '', 17, 35),
(188, '2024-12-11 02:53:05.818812', '5', 'Tipos de experimentos', 1, '[{\"added\": {}}]', 17, 35),
(189, '2024-12-11 02:53:13.115550', '5', 'Tipos de experimentos', 2, '[]', 17, 35),
(190, '2024-12-11 02:53:26.598186', 'P01', 'Probabilidad clásica 01', 3, '', 15, 35),
(191, '2024-12-11 02:53:26.598186', 'PC01', 'Prueba', 3, '', 15, 35),
(192, '2024-12-11 02:55:21.221063', 'PC01', 'Probabilidad clásica 01', 1, '[{\"added\": {}}]', 15, 35),
(193, '2024-12-11 02:57:18.057984', 'PC01', 'Probabilidad clásica 01', 2, '[{\"added\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\"}}]', 15, 35),
(194, '2024-12-11 02:57:51.215593', 'PC01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Posicion x\", \"Posicion y\"]}}]', 15, 35),
(195, '2024-12-11 02:58:11.916236', 'PC01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Posicion x\"]}}]', 15, 35),
(196, '2024-12-11 02:58:28.423611', 'PC01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Posicion x\", \"Posicion y\"]}}]', 15, 35),
(197, '2024-12-11 02:58:50.003048', 'PC01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Posicion x\", \"Posicion y\"]}}]', 15, 35),
(198, '2024-12-11 02:59:02.667599', 'PC01', 'Probabilidad clásica 01', 2, '[{\"changed\": {\"name\": \"etapas\", \"object\": \"Tipos de Experimentos\", \"fields\": [\"Posicion x\"]}}]', 15, 35),
(199, '2024-12-11 03:00:20.525698', 'PC01', 'Probabilidad clásica 01', 2, '[]', 15, 35),
(200, '2024-12-11 03:17:57.102587', '26', 'Avatar 26', 1, '[{\"added\": {}}]', 10, 35),
(201, '2024-12-11 03:18:06.071751', '27', 'Avatar 27', 1, '[{\"added\": {}}]', 10, 35),
(202, '2024-12-11 03:18:14.987669', '28', 'Avatar 28', 1, '[{\"added\": {}}]', 10, 35),
(203, '2024-12-11 03:18:36.196434', '29', 'Avatar 29', 1, '[{\"added\": {}}]', 10, 35),
(204, '2024-12-11 03:18:51.827156', '30', 'Avatar 30', 1, '[{\"added\": {}}]', 10, 35),
(205, '2024-12-11 03:19:10.908928', '31', 'Avatar 31', 1, '[{\"added\": {}}]', 10, 35),
(206, '2024-12-11 03:19:30.368968', '32', 'Avatar 32', 1, '[{\"added\": {}}]', 10, 35),
(207, '2024-12-11 05:19:44.212314', '20', 'determinista', 2, '[{\"changed\": {\"fields\": [\"Definicion\"]}}]', 14, 35),
(208, '2024-12-11 05:20:05.008593', '16', 'aleatorio', 2, '[{\"changed\": {\"fields\": [\"Definicion\"]}}]', 14, 35),
(209, '2024-12-11 05:20:44.323034', '17', 'aleatorio', 2, '[{\"changed\": {\"fields\": [\"Definicion\"]}}]', 14, 35),
(210, '2024-12-11 05:20:51.263150', '18', 'aleatorio', 2, '[]', 14, 35),
(211, '2024-12-11 05:20:58.011892', '19', 'aleatorio', 2, '[]', 14, 35),
(212, '2024-12-11 22:41:57.419719', '92', 'cece', 3, '', 4, 35),
(213, '2024-12-11 22:41:57.420706', '93', 'ceceb', 3, '', 4, 35),
(214, '2024-12-11 22:41:57.420706', '90', 'dada', 3, '', 4, 35),
(215, '2024-12-11 22:41:57.420706', '89', 'dede', 3, '', 4, 35),
(216, '2024-12-11 22:41:57.420706', '86', 'Est10', 3, '', 4, 35),
(217, '2024-12-11 22:41:57.420706', '87', 'Est12', 3, '', 4, 35),
(218, '2024-12-11 22:41:57.420706', '84', 'Est7', 3, '', 4, 35),
(219, '2024-12-11 22:41:57.420706', '85', 'Est9', 3, '', 4, 35),
(220, '2024-12-11 22:41:57.420706', '91', 'gege', 3, '', 4, 35),
(221, '2024-12-11 22:41:57.420706', '88', 'koko', 3, '', 4, 35),
(222, '2024-12-11 22:56:27.268056', '10', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 2, '[{\"changed\": {\"fields\": [\"Confirmado\"]}}]', 19, 35),
(223, '2024-12-12 01:50:22.089980', '111', 'Admin', 1, '[{\"added\": {}}, {\"added\": {\"name\": \"Perfil\", \"object\": \"Admin - admin\"}}]', 4, 35),
(224, '2024-12-12 01:56:47.398903', '52', 'Admin - admin', 2, '[{\"changed\": {\"fields\": [\"AvatarUser\"]}}]', 11, 35),
(225, '2024-12-12 01:56:54.147318', '52', 'Admin - admin', 2, '[]', 11, 35),
(226, '2024-12-12 01:57:08.654207', '111', 'Admin', 2, '[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\"]}}]', 4, 35),
(227, '2024-12-12 02:24:39.882378', '38', 'Clau - Tipos de Experimentos - 23 - 100%', 3, '', 18, 35),
(228, '2024-12-12 03:05:21.355157', '111', 'Admin', 2, '[{\"changed\": {\"fields\": [\"password\"]}}]', 4, 35),
(229, '2024-12-12 06:38:02.966350', '40', 'Est2 - Tipos de Experimentos - 73 - 100%', 3, '', 18, 35),
(230, '2024-12-12 09:04:28.524267', '39', 'Clau - Tipos de Experimentos - 23 - 100%', 2, '[]', 18, 35),
(231, '2024-12-12 11:36:01.112560', '33', 'AvatarDocente 33', 1, '[{\"added\": {}}]', 10, 35),
(232, '2024-12-12 11:37:38.804718', '10', 'Docente: Profe1 - Estudiante: Clau - Confirmado: False', 2, '[{\"changed\": {\"fields\": [\"Confirmado\"]}}]', 19, 35),
(233, '2024-12-12 14:03:43.900384', 'PC01', 'Probabilidad clásica 01', 2, '[{\"added\": {\"name\": \"etapas\", \"object\": \"Concepto espacio muestral\"}}]', 15, 35),
(234, '2024-12-12 14:04:41.280437', 'PC01', 'Probabilidad clásica 01', 2, '[{\"added\": {\"name\": \"etapas\", \"object\": \"Eventos o sucesor\"}}]', 15, 35),
(235, '2024-12-12 14:05:03.162859', '7', 'Concepto espacio muestral', 2, '[{\"changed\": {\"fields\": [\"Contenido abordado\", \"Dificultad\", \"Habilidad matematica\", \"Habilidad bloom\"]}}]', 17, 35),
(236, '2024-12-12 14:05:22.993979', '8', 'Eventos o sucesor', 2, '[{\"changed\": {\"fields\": [\"Contenido abordado\", \"Dificultad\", \"Habilidad matematica\", \"Habilidad bloom\"]}}]', 17, 35),
(237, '2024-12-12 14:05:37.798393', '41', 'Clau - Concepto espacio muestral - 78 - 80%', 1, '[{\"added\": {}}]', 18, 35),
(238, '2024-12-12 14:05:52.823036', '42', 'Clau - Concepto espacio muestral - 51 - 90%', 1, '[{\"added\": {}}]', 18, 35),
(239, '2024-12-12 14:47:31.968762', '42', 'Clau - Concepto espacio muestral - 51 - 90%', 3, '', 18, 35),
(240, '2024-12-12 14:47:31.968762', '41', 'Clau - Concepto espacio muestral - 78 - 80%', 3, '', 18, 35);

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
(34, 'mattrix_usuarios', '0005_alter_profile_colegio_alter_profile_curso_and_more', '2024-12-04 04:51:37.775885'),
(35, 'mattrix_docentes', '0005_rename_id_avance_respuestaescrita_avance_and_more', '2024-12-04 17:02:35.064641'),
(36, 'mattrix_usuarios', '0006_alter_profile_avataruser', '2024-12-06 14:54:40.254126'),
(37, 'mattrix_contenido', '0007_niveles_descripcion', '2024-12-09 22:35:29.485600'),
(38, 'mattrix_usuarios', '0007_alter_imagenes_uso', '2024-12-09 22:35:29.490600'),
(39, 'mattrix_contenido', '0008_alter_etapas_habilidad_bloom', '2024-12-12 13:37:54.557686');

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
('hftfhecr3bc7mujtwx95gmyi72to4ytr', '.eJxVjEsOwjAMBe-SNYpCXNcNS_acIXLsQAookfpZIe4OlbqA7ZuZ9zKR16XEdc5THNWcDKA5_I6J5ZHrRvTO9dastLpMY7KbYnc620vT_Dzv7t9B4bl86yAeBdE5JA_AmTsZkPCqmCAw9QCZdEiuz0oiiV3S0HUeCEmOKmTeH_wmOAo:1tLZVx:Rtd7iYgNFUVkGTdbzTK0CBSSTSkGoMxAISxRPHOZ_9Y', '2024-12-26 03:05:21.368157'),
('jgfar9e0deaw3ue068zjttnk3rgovqk6', '.eJxVjMsOwiAURP-FtSFAebp07zcQuPdWqgaS0q6M_64kXehuMufMvFhM-1bi3mmNC7Izc-z02-UED6oD4D3VW-PQ6rYumQ-FH7Tza0N6Xg7376CkXr5r7ZRFq7WbyCStZmGC9DPhJEQAsjZ7SUEAegVGKpfzSCQhJFAktWTvD8xEN6M:1tIZv7:IVWQGJ1KkwZT8fwA6vz-ABidwQGY52v1CTSs0wbLqD8', '2024-12-17 20:54:57.110398'),
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
(1, 'Prueba', 'Calle 1', 'Ciudad 1'),
(2, 'Prueba 2', 'Calle 1', 'Ciudad 1');

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

--
-- Volcado de datos para la tabla `mattrix_admin_historicalcolegio`
--

INSERT INTO `mattrix_admin_historicalcolegio` (`id_colegio`, `nombre`, `direccion`, `ciudad`, `history_id`, `history_date`, `history_change_reason`, `history_type`, `history_user_id`) VALUES
(2, 'Prueba 2', 'Calle 1', 'Ciudad 1', 1, '2024-12-12 03:14:39.413933', NULL, '+', NULL),
(3, 'TURRR', 'Punta Arenas', 'Punta Arenas', 2, '2024-12-12 03:27:23.565577', NULL, '+', 111),
(3, 'TURRR', 'Punta Arenas', 'Punta Arenas', 3, '2024-12-12 03:34:18.828361', NULL, '-', 111),
(4, 'Prueba 3', 'Calle 1', 'Ciudad 1', 4, '2024-12-12 03:51:45.282178', NULL, '+', 111),
(4, 'Prueba 3', 'Calle 1', 'Ciudad 1', 5, '2024-12-12 03:51:56.028581', NULL, '-', 111),
(1, 'Prueba 3', 'Calle 1', 'Ciudad 1', 6, '2024-12-12 03:55:01.331010', NULL, '~', 111),
(1, 'Prueba', 'Calle 1', 'Ciudad 1', 7, '2024-12-12 03:55:08.775681', NULL, '~', 111),
(1, 'Prueba2', 'Calle 1', 'Ciudad 1', 8, '2024-12-12 04:06:04.227836', NULL, '~', 111),
(1, 'Prueba', 'Calle 1', 'Ciudad 1', 9, '2024-12-12 04:06:09.648335', NULL, '~', 111);

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
(6, 'Tipos de Experimentos', '¿Podrás diferenciar un experimento aleatorio de uno determinista?', 'TiposDeExperimentos', 'Baja', 'Argumentar', 26, 60, 'PC01', 3, 'Comprender', 'Experimento aleatorio y experimento determinista', 0),
(7, 'Concepto espacio muestral', 'Descubre qué es el espacio muestral.', 'EspacioMuestral', 'Intermedia', 'Representrar', 22, 22, 'PC01', 2, 'Aplicar', 'Espacio Muestral', 0),
(8, 'Eventos o sucesor', '¿Qué será un evento en un experimento aleatorio?', 'ExperimentoEvento', 'Alta', 'Resolución de problemas', 22, 31, 'PC01', 2, 'Aplicar', 'Eventos o sucesos', 0);

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
(1, 'Mediante experimentos, estiman la probabilidad de un evento, registrando las frecuencias relativas.', 'Frecuencias relativas', 2),
(2, 'Establecen la probabilidad de un evento mediante razones, fracciones o porcentajes, sea haciendo un experimento o por medio de un problema.', 'Probabilidad de Laplace', 2),
(3, 'Antes del experimento, estiman la probabilidad de ocurrencia y verifican su estimación, usando de frecuencias relativas.', 'Probabilidad de Laplace', 2),
(4, 'Elaboran, con material concreto (como dados y monedas), experimentos aleatorios con resultados equiprobables y no equiprobables.', 'Experimentos aleatorios', 2),
(5, 'Realizan los experimentos aleatorios con numerosas repeticiones, determinan las frecuencias absolutas relativas y representan los resultados mediante gráficos.', 'Experimentos aleatorios, Frecuencia absoluta relativa', 2),
(6, 'Analizan y comunican si se cumple aproximadamente la equiprobabilidad.', 'Probabilidad de Laplace', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_contenido_niveles`
--

CREATE TABLE `mattrix_contenido_niveles` (
  `id_nivel` varchar(10) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `fondo_id` int(11) DEFAULT NULL,
  `OA_id` int(11) NOT NULL,
  `fondo_tarjeta_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_contenido_niveles`
--

INSERT INTO `mattrix_contenido_niveles` (`id_nivel`, `nombre`, `fondo_id`, `OA_id`, `fondo_tarjeta_id`, `descripcion`) VALUES
('PC01', 'Probabilidad clásica 01', 19, 2, 24, 'En este nivel trabajarás los conceptos de experimento aleatorio, espacio muestral y sucesos o eventos.');

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
(1, 'OA1', 'Descripción del OA1', '1° Medio'),
(2, 'MA07OA18', 'Explicar las probabilidades de eventos obtenidos por medio de experimentos de manera manual y/o con software educativo: \r\n    • Estimándolas de manera intuitiva. \r\n    • Utilizando frecuencias relativas. \r\n    • Relacionándolas con razones, fracciones o porcentaje.', '7° Básico'),
(3, 'MA08OA17', 'Explicar el principio combinatorio multiplicativo:\r\n•         A partir de situaciones concretas.\r\n•         Representándolo con tablas y árboles regulares, de manera manual y/o con software educativo.\r\n•         Utilizándolo para calcular la probabilidad de un evento compuesto.', '8° Básico'),
(4, 'MA1MOA14', 'Desarrollar las reglas de las probabilidades, la regla aditiva, la regla multiplicativa y la combinación de ambas, de manera concreta, pictórica y simbólica, de manera manual y/o con software educativo, en el contexto de la resolución de problemas.', '1° Medio');

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
(16, 'agrupar_experimentos', 'aleatorio', 'Lanzar un dado y observar la cara superior'),
(17, 'agrupar_experimentos', 'aleatorio', 'Lanzar una moneda y ver la cara que queda arriba'),
(18, 'agrupar_experimentos', 'aleatorio', 'Sacar una carta al azar de una baraja'),
(19, 'agrupar_experimentos', 'aleatorio', 'Elegir al azar una letra de la palabra \"PANCITO\"'),
(20, 'agrupar_experimentos', 'determinista', 'Dejar caer una pelota al suelo y observar su caída'),
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

--
-- Volcado de datos para la tabla `mattrix_docentes_avanceestudiantes`
--

INSERT INTO `mattrix_docentes_avanceestudiantes` (`id_avance`, `tiempo`, `fecha_completada`, `logro`, `estudiante_id`, `etapa_id`) VALUES
(39, '23', '2024-12-12 02:29:00.409010', 100, 35, 6);

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

--
-- Volcado de datos para la tabla `mattrix_docentes_docenteestudiante`
--

INSERT INTO `mattrix_docentes_docenteestudiante` (`id`, `confirmado`, `docente_id`, `estudiante_id`, `fecha_creacion`) VALUES
(10, 1, 40, 21, '2024-12-06 17:18:20.589164');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mattrix_docentes_respuestaescrita`
--

CREATE TABLE `mattrix_docentes_respuestaescrita` (
  `id` bigint(20) NOT NULL,
  `avance_id` bigint(20) NOT NULL,
  `pregunta` longtext NOT NULL,
  `respuesta` longtext NOT NULL,
  `retroalimentacion` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Volcado de datos para la tabla `mattrix_docentes_respuestaescrita`
--

INSERT INTO `mattrix_docentes_respuestaescrita` (`id`, `avance_id`, `pregunta`, `respuesta`, `retroalimentacion`) VALUES
(102, 39, 'Un experimento determinista es:', 'cuando se sabe lo que pasará', NULL),
(103, 39, 'Un experimento aleatorio es:', 'cuando no se sabe', NULL);

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
(17, 'avatars/avatar_17.png', 'avatar'),
(18, 'fondos/fondo_nivel_18.png', 'fondo-nivel'),
(19, 'fondos/fondo_nivel_19.png', 'fondo-nivel'),
(20, 'avatars/avatar_20.png', 'avatar'),
(22, 'avatarDocente/avatar_docente_22.jpg', 'avatarDocente'),
(23, 'avatarDocente/avatar_docente_23.png', 'avatarDocente'),
(24, 'fondos/fondo_nivel_24.png', 'fondo-nivel'),
(25, 'fondos/fondo_nivel_25.png', 'fondo-nivel'),
(26, 'avatars/avatar_26.png', 'avatar'),
(27, 'avatars/avatar_27.png', 'avatar'),
(28, 'avatars/avatar_28.jpg', 'avatar'),
(29, 'avatars/avatar_29.png', 'avatar'),
(30, 'avatars/avatar_30.jpg', 'avatar'),
(31, 'avatars/avatar_31.jpg', 'avatar'),
(32, 'avatars/avatar_32.jpg', 'avatar'),
(33, 'avatarDocente/avatar_docente_33.png', 'avatarDocente');

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
(21, 'student', 'Chile', '18549895-6', 20, 1, 1, 35),
(40, 'teacher', 'Chile', '18.903.564-0', 33, NULL, NULL, 77),
(51, 'student', 'Chile', '8981021-3', 20, 1, 1, 110),
(52, 'admin', 'Chile', '8498683-6', 32, 1, 1, 111),
(53, 'student', 'Chile', '17487872-2', 20, 1, 1, 113),
(54, 'student', 'Chile', '13234384-5', 20, 1, 1, 114),
(55, 'student', 'Chile', '24124325-7', 20, 1, 1, 115);

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
  ADD KEY `mattrix_docentes_res_avance_id_d981c186_fk_mattrix_d` (`avance_id`);

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
  ADD KEY `mattrix_usuarios_pro_colegio_id_45d247d5_fk_mattrix_a` (`colegio_id`),
  ADD KEY `mattrix_usuarios_pro_curso_id_65de4eed_fk_mattrix_a` (`curso_id`),
  ADD KEY `mattrix_usuarios_pro_avatarUser_id_53e9e892_fk_mattrix_u` (`avatarUser_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT de la tabla `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_colegio`
--
ALTER TABLE `mattrix_admin_colegio`
  MODIFY `id_colegio` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_cursos`
--
ALTER TABLE `mattrix_admin_cursos`
  MODIFY `id_curso` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `mattrix_admin_historicalcolegio`
--
ALTER TABLE `mattrix_admin_historicalcolegio`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_etapas`
--
ALTER TABLE `mattrix_contenido_etapas`
  MODIFY `id_etapa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_indicadoresevaluacion`
--
ALTER TABLE `mattrix_contenido_indicadoresevaluacion`
  MODIFY `id_indicador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `mattrix_contenido_oa`
--
ALTER TABLE `mattrix_contenido_oa`
  MODIFY `id_OA` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `id_avance` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT de la tabla `mattrix_docentes_docenteestudiante`
--
ALTER TABLE `mattrix_docentes_docenteestudiante`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `mattrix_docentes_respuestaescrita`
--
ALTER TABLE `mattrix_docentes_respuestaescrita`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT de la tabla `mattrix_usuarios_imagenes`
--
ALTER TABLE `mattrix_usuarios_imagenes`
  MODIFY `id_imagen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `mattrix_usuarios_profile`
--
ALTER TABLE `mattrix_usuarios_profile`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

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
  ADD CONSTRAINT `mattrix_docentes_res_avance_id_d981c186_fk_mattrix_d` FOREIGN KEY (`avance_id`) REFERENCES `mattrix_docentes_avanceestudiantes` (`id_avance`);

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
