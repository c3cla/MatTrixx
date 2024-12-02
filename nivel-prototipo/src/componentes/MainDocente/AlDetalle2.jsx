// AlDetalle.jsx
import React, { useEffect, useState } from "react";
import { obtenerAvancesCurso } from "../../api";

const AlDetalle = ({ cursoId }) => {
  const [datosDetalle, setDatosDetalle] = useState([]);

  useEffect(() => {
    const obtenerDatosDetalle = async () => {
      try {
        const avances = await obtenerAvancesCurso(cursoId);

        // Crear un mapa para almacenar detalles de cada etapa
        const etapaMap = {};

        avances.forEach((avance) => {
          const etapaNombre = avance.etapa?.nombre || "Etapa desconocida";
          const nombreCompleto = avance.nombre_completo || "Nombre desconocido";

          if (etapaNombre) {
            if (!etapaMap[etapaNombre]) {
              etapaMap[etapaNombre] = [];
            }
            etapaMap[etapaNombre].push({
              nombreCompleto,
              tiempo: avance.tiempo || "N/A",
              logro: avance.logro !== undefined ? `${avance.logro}%` : "N/A",
            });
          }
        });

        setDatosDetalle(Object.entries(etapaMap).map(([etapa, estudiantes]) => ({ etapa, estudiantes })));
      } catch (error) {
        console.error("Error al obtener detalles por etapa:", error);
      }
    };

    if (cursoId) {
      obtenerDatosDetalle();
    }
  }, [cursoId]);

  return (
    <div className="al-detalle">
      <h3>Detalles por Etapa</h3>
      {datosDetalle.length > 0 ? (
        datosDetalle.map((detalle, index) => (
          <div key={index} className="etapa-detalle">
            <h4>{detalle.etapa}</h4>
            <table className="tabla-detalle">
              <thead>
                <tr>
                  <th>Nombre Completo</th>
                  <th>Tiempo (segundos)</th>
                  <th>Porcentaje de Logro</th>
                </tr>
              </thead>
              <tbody>
                {detalle.estudiantes.map((estudiante, idx) => (
                  <tr key={idx}>
                    <td>{estudiante.nombreCompleto}</td>
                    <td>{estudiante.tiempo}</td>
                    <td>{estudiante.logro}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ))
      ) : (
        <p>No hay datos disponibles para las etapas trabajadas en este curso.</p>
      )}
    </div>
  );
};

export default AlDetalle;
