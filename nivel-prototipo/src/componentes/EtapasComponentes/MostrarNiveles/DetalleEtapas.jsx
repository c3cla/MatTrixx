import React, { useEffect, useState, Suspense } from "react";
import { useParams, useNavigate } from "react-router-dom";
import "./DetalleEtapas.css";
import * as Componentes from "../../indice";
import { RegistrarAvanceEstudiante } from "../../indice";
import api from "../../../api";

const DetalleEtapas = () => {
  const { id_etapa } = useParams();
  const navigate = useNavigate();
  const [etapa, setEtapa] = useState(null);
  const [cargando, setCargando] = useState(true);
  const [error, setError] = useState(null);
  const [ComponenteSeleccionado, setComponenteSeleccionado] = useState(null);

  const [etapasCompletadas, setEtapasCompletadas] = useState(() => {
    const almacenadas = localStorage.getItem("etapasCompletadas");
    return almacenadas ? JSON.parse(almacenadas) : [];
  });

  useEffect(() => {
    localStorage.setItem("etapasCompletadas", JSON.stringify(etapasCompletadas));
  }, [etapasCompletadas]);

  // Fetch etapa
  useEffect(() => {
    const obtenerEtapa = async () => {
      try {
        const respuesta = await api.get(`/api/etapas/${id_etapa}/`);
        setEtapa(respuesta.data);
      } catch (error) {
        setError("Error al cargar la etapa.");
        console.error(error);
      } finally {
        setCargando(false);
      }
    };

    obtenerEtapa();
  }, [id_etapa]);

  // Configurar el componente asociado a la etapa
  useEffect(() => {
    if (etapa && etapa.componente) {
      const componenteNombre = etapa.componente;
      const Componente = Componentes[componenteNombre];
      if (Componente) {
        setComponenteSeleccionado(() => Componente);
      } else {
        setError("Componente no encontrado.");
      }
    }
  }, [etapa]);

  // Manejo al completar la etapa
  const manejarEtapaCompletada = (avanceExitoso) => {
    if (avanceExitoso) {
      setEtapasCompletadas((prev) => [...prev, etapa.id_etapa]);
      navigate(`/nivel/${etapa.id_nivel}`, {
        state: { id_etapa_completada: etapa.id_etapa },
      });
    } else {
      setError("No se pudo completar la etapa.");
    }
  };

  if (cargando) {
    return <p>Cargando etapa...</p>;
  }

  if (error) {
    return <p>{error}</p>;
  }

  if (!etapa) {
    return <p>Etapa no encontrada.</p>;
  }

  return (
    <div className="detalle-etapa-general">
      <div className="barra-lateral">
        <button onClick={() => navigate("/estudiante")}>Volver al menú</button>
        <button onClick={() => navigate(`/nivel/${etapa.id_nivel}`)}>
          Volver al Mapa
        </button>
      </div>

      <div className="detalles-etapa-container">
        <h1>{etapa.nombre}</h1>
        <p>{etapa.descripcion}</p>

        {/* Registro del avance */}
        <RegistrarAvanceEstudiante
          id_etapa={etapa.id_etapa}
          tiempoTotal={etapa.tiempoTotal || 0} // Puede ajustarse dinámicamente
          porcentajeLogro={etapa.porcentajeLogro || 100} // Puede ajustarse dinámicamente
        />

        {/* Componente dinámico asociado a la etapa */}
        {ComponenteSeleccionado ? (
          <Suspense fallback={<div>Cargando componente...</div>}>
            <ComponenteSeleccionado etapa={etapa} />
          </Suspense>
        ) : (
          <p>No hay un componente asociado a esta etapa.</p>
        )}
      </div>
    </div>
  );
};

export default DetalleEtapas;
