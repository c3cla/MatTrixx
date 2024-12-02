import React from "react";
import PropTypes from "prop-types";
import "./Resumen.css";
import ResumenAnimacion from "../assets/wow.gif";
import { RegistrarAvanceEstudiante, calcularPorcentajeCorrectas } from "../../indice";

export const Resumen = ({
  resultados,
  tiempoTotal,
  totalPreguntas,
  reiniciarQuiz,
  continuarQuiz,
  id_etapa,
}) => {
  const porcentajeLogro = calcularPorcentajeCorrectas(resultados, totalPreguntas);

  const handleContinuar = () => {
    localStorage.setItem("animarDesbloqueo", "true");
    continuarQuiz(localStorage.getItem("id_nivel"));
  };

  const handleAvanceCompleto = (data) => {
    console.log("Avance completado:", data);
    handleContinuar();
  };

  return (
    <div className="resumen-overlay">
      <div className="resumen-contenedor">
        <div className="animacion">
          <img src={ResumenAnimacion} alt="Animación de resumen" />
        </div>

        <div className="resumen-tabla">
          <h2>Preguntas</h2>
          <table>
            <thead>
              <tr>
                <th>#</th>
                <th>Tiempo</th>
                <th>Resultado</th>
              </tr>
            </thead>
            <tbody>
              {resultados.map((resultado, index) => (
                <tr key={index}>
                  <td>{index + 1}</td>
                  <td>{resultado.tiempo}</td>
                  <td>
                    {resultado.correcta ? (
                      <span role="img" aria-label="Correcto">
                        ✔️
                      </span>
                    ) : (
                      <span role="img" aria-label="Incorrecto">
                        ❌
                      </span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <h2>Porcentaje de logro: {porcentajeLogro}%</h2>

        <RegistrarAvanceEstudiante
          id_etapa={id_etapa}
          tiempoTotal={tiempoTotal}
          porcentajeLogro={porcentajeLogro}
          onComplete={handleAvanceCompleto}
        />

        <button onClick={reiniciarQuiz}>Repetir</button>
      </div>
    </div>
  );
};

Resumen.propTypes = {
  resultados: PropTypes.arrayOf(
    PropTypes.shape({
      correcta: PropTypes.bool.isRequired,
      tiempo: PropTypes.number.isRequired,
    })
  ).isRequired,
  tiempoTotal: PropTypes.number.isRequired,
  totalPreguntas: PropTypes.number.isRequired,
  reiniciarQuiz: PropTypes.func.isRequired,
  continuarQuiz: PropTypes.func.isRequired,
  id_etapa: PropTypes.number.isRequired,
};
