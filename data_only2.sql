INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
INSERT INTO `mattrix_admin_colegio` (`id_colegio`, `nombre`, `direccion`, `ciudad`) VALUES
INSERT INTO `mattrix_admin_cursos` (`id_curso`, `nivel`, `letra`, `colegio_id`) VALUES
INSERT INTO `mattrix_contenido_etapas` (`id_etapa`, `nombre`, `descripcion`, `componente`, `dificultad`, `habilidad_matematica`, `posicion_x`, `posicion_y`, `id_nivel_id`, `OA_id`, `habilidad_bloom`, `contenido_abordado`, `es_ultima`) VALUES
INSERT INTO `mattrix_contenido_indicadoresevaluacion` (`id_indicador`, `descripcion`, `contenido`, `OA_id`) VALUES
INSERT INTO `mattrix_contenido_niveles` (`id_nivel`, `nombre`, `fondo_id`, `OA_id`, `fondo_tarjeta_id`) VALUES
INSERT INTO `mattrix_contenido_oa` (`id_OA`, `OA`, `descripcion`, `nivel_asociado`) VALUES
INSERT INTO `mattrix_contenido_terminospareados` (`id_termino`, `uso`, `concepto`, `definicion`) VALUES
INSERT INTO `mattrix_usuarios_imagenes` (`id_imagen`, `imagen`, `uso`) VALUES
INSERT INTO `mattrix_usuarios_profile` (`id`, `rol`, `pais`, `rut`, `avatarUser_id`, `colegio_id`, `curso_id`, `user_id`) VALUES
