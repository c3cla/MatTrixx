import React, { useEffect, useState } from "react";
import axios from "axios";

const ProgresoPromedio = () => {
  const [datos, setDatos] = useState([]);
  const [cargando, setCargando] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const obtenerDatos = async () => {
      try {
        const respuesta = await axios.get("/api/progreso-promedio", {
          params: {
            curso_nivel: "8°",
            curso_letra: "A",
          },
        });
        setDatos(respuesta.data);
      } catch (err) {
        setError("Error al cargar los datos.");
        console.error(err);
      } finally {
        setCargando(false);
      }
    };

    obtenerDatos();
  }, []);

  if (cargando) {
    return <p>Cargando datos...</p>;
  }

  if (error) {
    return <p>{error}</p>;
  }

  return (
    <div>
      <h2>Progreso Promedio del Curso 8°A</h2>
      {datos.length === 0 ? (
        <p>No hay datos disponibles.</p>
      ) : (
        <table>
          <thead>
            <tr>
              {Object.keys(datos[0]).map((key) => (
                <th key={key}>{key}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {datos.map((fila, index) => (
              <tr key={index}>
                {Object.values(fila).map((valor, idx) => (
                  <td key={idx}>{valor}</td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default ProgresoPromedio;
