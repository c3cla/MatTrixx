import React from "react";
import PropTypes from "prop-types";
import api from "../../../api";

/**
 * Convierte el tiempo en segundos a un formato HH:mm:ss.
 * @param {number} tiempoEnSegundos - Tiempo en segundos.
 * @returns {string} - Tiempo formateado en el estándar HH:mm:ss.
 */
export const formatearTiempo = (tiempoEnSegundos) => {
  const horas = Math.floor(tiempoEnSegundos / 3600);
  const minutos = Math.floor((tiempoEnSegundos % 3600) / 60);
  const segundos = Math.floor(tiempoEnSegundos % 60);
  return [horas, minutos, segundos]
    .map((unidad) => String(unidad).padStart(2, "0"))
    .join(":");
};

/**
 * Calcula el porcentaje de respuestas correctas en base a los resultados.
 * @param {Array} resultados - Lista de resultados con propiedades `correcta` (boolean).
 * @param {number} totalPreguntas - Total de preguntas realizadas.
 * @returns {number} - Porcentaje de respuestas correctas.
 */
export const calcularPorcentajeCorrectas = (resultados, totalPreguntas) => {
  if (!Array.isArray(resultados) || totalPreguntas <= 0) {
    console.warn("Parámetros inválidos para calcular el porcentaje de correctas.");
    return 0;
  }

  const correctas = resultados.filter((r) => r.correcta).length;
  return Math.round((correctas * 100) / totalPreguntas);
};

/**
 * Lógica para registrar el avance del estudiante en el backend.
 * @param {number} etapaId - ID de la etapa completada.
 * @param {string} tiempo - Tiempo formateado en HH:mm:ss.
 * @param {number} logro - Porcentaje de logro alcanzado.
 * @returns {Promise<object>} - Respuesta del backend.
 */
export const registrarAvanceEstudiante = async (etapaId, tiempo, logro) => {
  if (!etapaId) {
    console.warn("El ID de la etapa es indefinido. No se puede registrar el avance.");
    throw new Error("ID de etapa indefinido");
  }

  try {
    const response = await api.post("/api/avance_estudiantes/", {
      etapa: etapaId,
      tiempo,
      logro,
    });
    console.log("Avance registrado exitosamente:", response.data);
    return response.data;
  } catch (error) {
    console.error("Error al registrar el avance del estudiante:", error);
    throw error;
  }
};

/**
 * Componente encargado de registrar el avance de un estudiante en el backend.
 * 
 * @param {number} id_etapa - ID de la etapa completada.
 * @param {number} tiempoTotal - Tiempo total dedicado a la etapa (en segundos).
 * @param {number} porcentajeLogro - Porcentaje de logro obtenido.
 * @param {function} onComplete - Callback ejecutado después de registrar el avance.
 */
const RegistrarAvanceEstudiante = ({ id_etapa, tiempoTotal, porcentajeLogro, onComplete }) => {
  const handleRegistrar = async () => {
    try {
      const tiempoFormateado = formatearTiempo(tiempoTotal);
      const data = await registrarAvanceEstudiante(id_etapa, tiempoFormateado, porcentajeLogro);
      onComplete(data);
    } catch (error) {
      console.error("Error al registrar el avance:", error);
    }
  };

  return (
    <button onClick={handleRegistrar} className="registrar-avance-boton">
      Registrar Avance
    </button>
  );
};

RegistrarAvanceEstudiante.propTypes = {
  id_etapa: PropTypes.number.isRequired,
  tiempoTotal: PropTypes.number.isRequired,
  porcentajeLogro: PropTypes.number.isRequired,
  onComplete: PropTypes.func.isRequired,
};

export default RegistrarAvanceEstudiante;
