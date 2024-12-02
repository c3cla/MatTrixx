import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  obtenerEtapasPorNivel,
  obtenerEtapasCompletadasPorUsuario,
} from "../../../api";
import "./MapaEtapas.css";

import etapaActualImg from "../MostrarNiveles/assets/etapa-actual.png";
import etapaBloqueadaImg from "../MostrarNiveles/assets/etapa-bloqueada.png";
import etapaCompletadaImg from "../MostrarNiveles/assets/etapa-completada.png";
import fondoMapaImg from "../MostrarNiveles/assets/fondo-mapa.png";

const MapaEtapas = () => {
  const { id_nivel } = useParams();
  const navigate = useNavigate();

  const [etapas, setEtapas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [completedStages, setCompletedStages] = useState([]);

  useEffect(() => {
    localStorage.setItem("id_nivel", id_nivel);

    const fetchEtapas = async () => {
      try {
        const data = await obtenerEtapasPorNivel(id_nivel);
        setEtapas(data);
      } catch (err) {
        setError("Error al cargar las etapas.");
      } finally {
        setLoading(false);
      }
    };

    const fetchCompletedStages = async () => {
      try {
        const completedData = await obtenerEtapasCompletadasPorUsuario(
          id_nivel
        );

        setCompletedStages(
          completedData.map((etapa) => ({
            id_etapa: etapa.id_etapa,
            logro: etapa.logro,
          }))
        );
      } catch (err) {
        setError("Error al cargar las etapas completadas.");
      }
    };

    fetchEtapas();
    fetchCompletedStages();
  }, [id_nivel]);

  const handleEtapaClick = (etapa) => {
    const etapaIndex = etapas.findIndex((e) => e.id_etapa === etapa.id_etapa);
    const etapaAnterior = etapas[etapaIndex - 1];

    if (etapaAnterior) {
      const etapaAnteriorDatos = completedStages.find(
        (e) => e.id_etapa === etapaAnterior.id_etapa
      );

      const porcentajeLogro = etapaAnteriorDatos?.logro || 0;

      if (!etapaAnteriorDatos || porcentajeLogro < 80) {
        alert(
          `Necesitas un porcentaje de logro mayor o igual al 80% en la etapa anterior (${etapaAnterior.nombre}) para avanzar.`
        );
        return;
      }
    }

    navigate(`/etapa/${etapa.id_etapa}`, { state: { componente: etapa.componente } });
  };

  const obtenerClaseEtapa = (etapa, index) => {
    const etapaCompletada = completedStages.find(
      (e) => e.id_etapa === etapa.id_etapa
    );

    if (index === 0) {
      // Primera etapa siempre desbloqueada
      if (etapaCompletada && etapaCompletada.logro >= 80) {
        return "etapa etapa-completada"; // Completada con éxito
      }
      return "etapa proxima-etapa"; // Desbloqueada y animada
    }

    if (etapaCompletada && etapaCompletada.logro >= 80) {
      // Etapas completadas con logro suficiente
      return "etapa etapa-completada";
    }

    const etapaAnterior = etapas[index - 1];
    const etapaAnteriorCompletada = completedStages.find(
      (e) => e.id_etapa === etapaAnterior?.id_etapa
    );

    if (etapaAnteriorCompletada && etapaAnteriorCompletada.logro >= 80) {
      // Desbloquear la siguiente etapa si la anterior está completada
      return "etapa proxima-etapa";
    }

    return "etapa etapa-bloqueada"; // Etapas bloqueadas
  };

  const obtenerImagenEtapa = (etapa, index) => {
    const etapaCompletada = completedStages.find(
      (e) => e.id_etapa === etapa.id_etapa
    );

    if (index === 0) {
      // Primera etapa siempre desbloqueada y animada
      if (etapaCompletada && etapaCompletada.logro >= 80) {
        return etapaCompletadaImg; // Imagen de completada
      }
      return etapaActualImg; // Imagen de etapa actual
    }

    if (etapaCompletada && etapaCompletada.logro >= 80) {
      // Imagen de etapa completada con éxito
      return etapaCompletadaImg;
    }

    const etapaAnterior = etapas[index - 1];
    const etapaAnteriorCompletada = completedStages.find(
      (e) => e.id_etapa === etapaAnterior?.id_etapa
    );

    if (etapaAnteriorCompletada && etapaAnteriorCompletada.logro >= 80) {
      // Imagen de la siguiente etapa desbloqueada
      return etapaActualImg;
    }

    return etapaBloqueadaImg;
  };

  if (loading) return <p>Cargando etapas...</p>;
  if (error) return <p>{error}</p>;

  return (
    <div className="mapa-niveles">
      <div className="barra-lateral">
        <h1>{etapas[0]?.nivel?.nombre || "Nivel no disponible"}</h1>
        <button onClick={() => navigate("/estudiante")}>Volver al menú</button>
      </div>

      <div className="mapa-container">
        <div className="mapa">
          <img src={fondoMapaImg} alt="Mapa de fondo" className="fondo-mapa" />

          <svg className="lineas-camino" xmlns="http://www.w3.org/2000/svg">
            {etapas.map((etapa, index) => {
              if (index < etapas.length - 1) {
                const siguienteEtapa = etapas[index + 1];
                return (
                  <line
                    key={`linea-${etapa.id_etapa}`}
                    x1={`${etapa.posicion_x}px`}
                    y1={`${etapa.posicion_y}px`}
                    x2={`${siguienteEtapa.posicion_x}px`}
                    y2={`${siguienteEtapa.posicion_y}px`}
                    stroke="url(#gradiente)"
                    strokeWidth="2"
                  />
                );
              }
              return null;
            })}
            <defs>
              <linearGradient id="gradiente" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" style={{ stopColor: "black", stopOpacity: 1 }} />
                <stop offset="50%" style={{ stopColor: "purple", stopOpacity: 1 }} />
                <stop offset="100%" style={{ stopColor: "blue", stopOpacity: 1 }} />
              </linearGradient>
            </defs>
          </svg>

          {etapas.map((etapa, index) => (
            <div
              key={etapa.id_etapa}
              className={obtenerClaseEtapa(etapa, index)}
              style={{
                left: `${etapa.posicion_x}px`,
                top: `${etapa.posicion_y}px`,
              }}
              onClick={() => handleEtapaClick(etapa)}
              tabIndex="0"
              onKeyPress={(e) => {
                if (e.key === "Enter") {
                  handleEtapaClick(etapa);
                }
              }}
              aria-label={`Selecciona la etapa ${etapa.nombre}`}
            >
              <img
                src={obtenerImagenEtapa(etapa, index)}
                alt={`Etapa ${etapa.nombre}`}
                className="imagen-etapa"
              />
              <div className="tooltip">
                <h3>{etapa.nombre}</h3>
                <p>{etapa.descripcion}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default MapaEtapas;
