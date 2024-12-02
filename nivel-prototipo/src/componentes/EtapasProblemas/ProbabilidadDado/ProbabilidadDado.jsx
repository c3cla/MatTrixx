import React, { useEffect, useState } from 'react';
import { obtenerProblemaProbabilidad } from '../../../api';
import Latex from 'react-latex-next';
import './ProbabilidadDado.css';

const ProbabilidadDado = () => {
    const [problema, setProblema] = useState(null);
    const [numerosEventoSeleccionados, setNumerosEventoSeleccionados] = useState([]);
    const [numerosEspacioMuestralSeleccionados, setNumerosEspacioMuestralSeleccionados] = useState([]);
    const [numerador, setNumerador] = useState('');
    const [denominador, setDenominador] = useState('');
    const [mensajeValidacionEvento, setMensajeValidacionEvento] = useState('');
    const [mensajeValidacionEspacioMuestral, setMensajeValidacionEspacioMuestral] = useState('');
    const [mensajeValidacionProbabilidad, setMensajeValidacionProbabilidad] = useState('');
    const [cardinalidadEspacioMuestral, setCardinalidadEspacioMuestral] = useState(0);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const data = await obtenerProblemaProbabilidad();
    
                data.espacio_muestral = JSON.parse(
                    data.espacio_muestral.replace(/^[^[]*/, '') 
                );
                data.elementos_evento = JSON.parse(
                    data.elementos_evento.replace(/^[^[]*/, '') 
                );
    
                setProblema(data);
                setCardinalidadEspacioMuestral(data.espacio_muestral.length);
            } catch (error) {
                console.error("Error al obtener datos de la API:", error);
            }
        };
        fetchData();
    }, []);

    const toggleEventoSelection = (num) => {
        setNumerosEventoSeleccionados((prev) =>
            prev.includes(num) ? prev.filter((n) => n !== num) : [...prev, num]
        );
    };

    const toggleEspacioMuestralSelection = (num) => {
        setNumerosEspacioMuestralSeleccionados((prev) =>
            prev.includes(num) ? prev.filter((n) => n !== num) : [...prev, num]
        );
    };

    const validarSeleccionEvento = () => {
        const eventoCorrecto =
            numerosEventoSeleccionados.length === problema.elementos_evento.length &&
            numerosEventoSeleccionados.every((num) => problema.elementos_evento.includes(num));

        setMensajeValidacionEvento(
            eventoCorrecto
                ? '¡Correcto! Selección del evento es precisa.'
                : 'Error. La selección del evento no es correcta.'
        );
    };

    const validarSeleccionEspacioMuestral = () => {
        const espacioMuestralCorrecto =
            numerosEspacioMuestralSeleccionados.length === cardinalidadEspacioMuestral &&
            numerosEspacioMuestralSeleccionados.every((num) => num >= 1 && num <= cardinalidadEspacioMuestral);

        setMensajeValidacionEspacioMuestral(
            espacioMuestralCorrecto
                ? '¡Correcto! Selección del espacio muestral es precisa.'
                : 'Error. La selección del espacio muestral no es correcta.'
        );
    };

    const validarProbabilidad = () => {
        const fraccionCorrecta =
            parseInt(numerador) === problema.elementos_evento.length &&
            parseInt(denominador) === cardinalidadEspacioMuestral; // Validamos con la cardinalidad guardada

        setMensajeValidacionProbabilidad(
            fraccionCorrecta
                ? '¡Muy bien! La probabilidad ingresada es correcta.'
                : 'Error. La probabilidad ingresada no es correcta.'
        );
    };

    if (!problema) return <p>Cargando problema...</p>;

    return (
        <div className="problema-grid">
            
            <div className="enunciado">
                <h2>{problema.enunciado}</h2>
            </div>

            <div className="columna-izquierda">
                <div className="fila evento">
                    <div className="tarjeta evento-descripcion">
                        <h1>Evento</h1>
                        <p>Selecciona los números correspondientes al evento: <strong>{problema.elementos_evento.join(", ")}</strong></p>
                    </div>
                    <div className="flecha">➔</div>
                    <div className="tarjeta seleccion-evento">
                        <p><i>Haz click en los resultados correspondientes al evento</i></p>
                        <div className="numeros">
                            {problema.espacio_muestral.map((num) => (
                                <div
                                    key={num}
                                    className={`numero ${numerosEventoSeleccionados.includes(num) ? 'seleccionado' : ''}`}
                                    onClick={() => toggleEventoSelection(num)}
                                >
                                    {num}
                                </div>
                            ))}
                        </div>
                        <p className="contador">Seleccionados: {numerosEventoSeleccionados.length}</p>
                        <button className='validar-cardinalidad' onClick={validarSeleccionEvento}>Validar Selección Evento</button>
                        {mensajeValidacionEvento && <p className="mensaje-validacion">{mensajeValidacionEvento}</p>}
                    </div>
                </div>

                <div className="fila espacio-muestral">
                    <div className="tarjeta espacio-muestral-descripcion">
                        <h1>Espacio Muestral</h1>
                    </div>
                    <div className="flecha">➔</div>
                    <div className="tarjeta seleccion-espacio-muestral">
                        <p>Selecciona todos los posibles resultados:</p>
                        <div className="numeros">
                            {[...Array(12)].map((_, i) => (
                                <div
                                    key={i + 1}
                                    className={`numero ${numerosEspacioMuestralSeleccionados.includes(i + 1) ? 'seleccionado' : ''}`}
                                    onClick={() => toggleEspacioMuestralSelection(i + 1)}
                                >
                                    {i + 1}
                                </div>
                            ))}
                        </div>
                        <p className="contador">Seleccionados: {numerosEspacioMuestralSeleccionados.length}</p>
                        <button className='validar-cardinalidad' onClick={validarSeleccionEspacioMuestral}>Validar Selección Espacio Muestral</button>
                        {mensajeValidacionEspacioMuestral && <p className="mensaje-validacion">{mensajeValidacionEspacioMuestral}</p>}
                    </div>
                </div>
            </div>

            <div className="columna-derecha">
                <div className="fila probabilidad">
                    <div className="tarjeta fracciones-seleccion">
                        <h1>Probabilidad del evento</h1>
                        <p>La probabilidad de obtener {problema.elementos_evento.join(", ")} es:</p>
                        <div className="fraccion">
                            <input
                                type="number"
                                placeholder="Cardinalidad del Evento"
                                value={numerador}
                                onChange={(e) => setNumerador(e.target.value)}
                                className="numerador"
                            />
                            <span className="linea-fraccion"></span>
                            <input
                                type="number"
                                placeholder="Cardinalidad del Espacio Muestral"
                                value={denominador}
                                onChange={(e) => setDenominador(e.target.value)}
                                className="denominador"
                            />
                        </div>
                        <button className="validar-respuesta" onClick={validarProbabilidad}>Validar Probabilidad</button>
                        {mensajeValidacionProbabilidad && <p className="mensaje-validacion">{mensajeValidacionProbabilidad}</p>}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ProbabilidadDado;

//agregar fracciones simplificadas
//para que sean 5 preguntas
//para que muestre primero el evento, despues el espacio muestral y después la probabilidad