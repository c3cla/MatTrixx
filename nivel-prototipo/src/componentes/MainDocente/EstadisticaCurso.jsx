import React, { useEffect, useState } from "react";
import CursosDocente from "./CursosDocente";
import { obtenerAvancesCurso, obtenerEstudiantesPorCurso } from "../../api";
import "./EstadisticaCurso.css";

const EstadisticaCurso = () => {
  const [cursoSeleccionado, setCursoSeleccionado] = useState(null);
  const [estadisticasEstudiantes, setEstadisticasEstudiantes] = useState([]);
  const [estudiantes, setEstudiantes] = useState([]);
  const [logroPorOA, setLogroPorOA] = useState([]);
  const [avancePorHabilidad, setAvancePorHabilidad] = useState([]);
  const [porcentajePorEtapa, setPorcentajePorEtapa] = useState([]);
  const [tiempoPromedioPorEtapa, setTiempoPromedioPorEtapa] = useState([]);

  const handleCursoSeleccionado = async (cursoId) => {
    setCursoSeleccionado(cursoId);
    try {
      const estadisticasData = await obtenerAvancesCurso(cursoId);
      setEstadisticasEstudiantes(estadisticasData);
      
      const estudiantesData = await obtenerEstudiantesPorCurso(cursoId);
      setEstudiantes(estudiantesData);

      // Calcular el total de estudiantes después de obtener estudiantesData
      const totalEstudiantes = estudiantesData.length;

      // Calcular métricas usando totalEstudiantes y actualizar estados
      setLogroPorOA(calcularLogrosPorOA(estadisticasData, totalEstudiantes));
      setAvancePorHabilidad(calcularPromedioAvancePorHabilidad(estadisticasData));
      setPorcentajePorEtapa(calcularPorcentajeEstudiantesPorEtapa(estadisticasData, estudiantesData));
      setTiempoPromedioPorEtapa(calcularPromedioTiempoPorEtapa(estadisticasData));
    } catch (error) {
      console.error("Error al obtener datos del curso:", error);
    }
  };

  const calcularLogrosPorOA = (estadisticasEstudiantes, totalEstudiantes) => {
    const oaMap = {};
  
    estadisticasEstudiantes.forEach((avance) => {
      const { OA, descripcion } = avance.etapa.nivel.OA;
      const etapa = avance.etapa.nombre;
  
      if (!oaMap[OA]) {
        oaMap[OA] = { OA, descripcion, logroTotal: 0, etapas: {} };
      }
      if (!oaMap[OA].etapas[etapa]) {
        oaMap[OA].etapas[etapa] = { etapa, logroTotal: 0 };
      }
  
      oaMap[OA].logroTotal += parseFloat(avance.logro);
      oaMap[OA].etapas[etapa].logroTotal += parseFloat(avance.logro);
    });
  
    return Object.keys(oaMap).map(OA => ({
      OA,
      descripcion: oaMap[OA].descripcion,
      promedioLogro: parseFloat((oaMap[OA].logroTotal / totalEstudiantes).toFixed(2)),
      etapas: Object.values(oaMap[OA].etapas).map(etapa => ({
        etapa: etapa.etapa,
        promedioEtapa: parseFloat((etapa.logroTotal / totalEstudiantes).toFixed(2)),
      })),
    }));
  };

  const calcularPromedioAvancePorHabilidad = (estadisticasEstudiantes) => {
    const habilidadMap = {};
    estadisticasEstudiantes.forEach((avance) => {
      const habilidad = avance.etapa.habilidad;
      if (!habilidadMap[habilidad]) {
        habilidadMap[habilidad] = { logroTotal: 0, count: 0 };
      }
      habilidadMap[habilidad].logroTotal += parseFloat(avance.logro);
      habilidadMap[habilidad].count += 1;
    });
    return Object.keys(habilidadMap).map(habilidad => ({
      habilidad,
      promedioLogro: parseFloat((habilidadMap[habilidad].logroTotal / habilidadMap[habilidad].count).toFixed(2)),
    }));
  };

  const calcularPorcentajeEstudiantesPorEtapa = (estadisticasEstudiantes, estudiantes) => {
    const etapaMap = {};
    estudiantes.forEach(estudiante => {
      estadisticasEstudiantes.forEach(avance => {
        const etapa = avance.etapa.id_etapa;
        if (!etapaMap[etapa]) {
          etapaMap[etapa] = { completados: new Set(), noCompletados: new Set(estudiantes.map(e => e.id)) };
        }
        etapaMap[etapa].completados.add(avance.estudiante_id);
        etapaMap[etapa].noCompletados.delete(avance.estudiante_id);
      });
    });
    return Object.keys(etapaMap).map(etapa => ({
      etapa,
      porcentajeCompletado: (etapaMap[etapa].completados.size / estudiantes.length) * 100,
      estudiantesNoCompletados: Array.from(etapaMap[etapa].noCompletados),
    }));
  };

  const calcularPromedioTiempoPorEtapa = (estadisticasEstudiantes) => {
    const etapaTiempoMap = {};
    estadisticasEstudiantes.forEach(avance => {
      const etapa = avance.etapa.id_etapa;
      if (!etapaTiempoMap[etapa]) {
        etapaTiempoMap[etapa] = { tiempoTotal: 0, count: 0 };
      }
      const tiempo = parseFloat(avance.tiempo);
      etapaTiempoMap[etapa].tiempoTotal += tiempo;
      etapaTiempoMap[etapa].count += 1;
    });
    return Object.keys(etapaTiempoMap).map(etapa => ({
      etapa,
      promedioTiempo: (etapaTiempoMap[etapa].tiempoTotal / etapaTiempoMap[etapa].count).toFixed(2),
    }));
  };

  return (
    <div className="estadistica-curso">
      <h2>Estadísticas del Curso</h2>
      <CursosDocente onCursoSeleccionado={handleCursoSeleccionado} />

      <div className="contenido-principal">
        {cursoSeleccionado ? (
          <>
            {/* Logro por OA en tarjetas */}
            <h3>Promedio de Logro por OA</h3>
            <div className="logros-oa-container">
              {logroPorOA.map((oaData, index) => (
                <div key={index} className="oa-card">
                  <div className="oa-percentage">{oaData.promedioLogro}%</div>
                  <div className="oa-description" title={oaData.descripcion}>
                    {oaData.OA}
                  </div>
                  <div className="etapas-promedio">
                    <h5>Promedio por Etapa</h5>
                    {oaData.etapas.map((etapaData, idx) => (
                      <div key={idx} className="etapa-promedio">
                        <span>{etapaData.etapa}:</span> {etapaData.promedioEtapa}%
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>

            {/* Promedio de Avance por Habilidad */}
            <h3>Promedio de Avance por Habilidad</h3>
            <table className="tabla-curso-avance-habilidad">
              <thead>
                <tr><th>Habilidad</th><th>Promedio de Logro (%)</th></tr>
              </thead>
              <tbody>
                {avancePorHabilidad.map((habilidadData, index) => (
                  <tr key={index}>
                    <td>{habilidadData.habilidad}</td>
                    <td>{habilidadData.promedioLogro}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            {/* Porcentaje de Estudiantes por Etapa */}
            <h3>Porcentaje de Estudiantes que Completaron cada Etapa</h3>
            <table className="tabla-curso-porcentaje-etapa">
              <thead>
                <tr>
                  <th>Etapa</th>
                  <th>Porcentaje Completado (%)</th>
                  <th>Estudiantes No Completados</th>
                </tr>
              </thead>
              <tbody>
                {porcentajePorEtapa.map((etapaData, index) => (
                  <tr key={index}>
                    <td>{etapaData.etapa}</td>
                    <td>{etapaData.porcentajeCompletado}</td>
                    <td>{etapaData.estudiantesNoCompletados.join(', ')}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            {/* Promedio de Tiempo por Etapa */}
            <h3>Promedio de Tiempo por Etapa</h3>
            <table className="tabla-curso-tiempo-etapa">
              <thead>
                <tr><th>Etapa</th><th>Tiempo Promedio (segundos)</th></tr>
              </thead>
              <tbody>
                {tiempoPromedioPorEtapa.map((etapaData, index) => (
                  <tr key={index}>
                    <td>{etapaData.etapa}</td>
                    <td>{etapaData.promedioTiempo}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </>
        ) : (
          <p>Selecciona un curso para ver sus estadísticas</p>
        )}
      </div>
    </div>
  );
};

export default EstadisticaCurso;
