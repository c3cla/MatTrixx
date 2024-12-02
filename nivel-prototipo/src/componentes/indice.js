//ELEMENTOS

//Rescatar nombre usuario
export {default as SaludoUsuario} from "./MainDocente/SaludoUsuario.jsx"

//Main Estudiante
export {default as MainEstudiante} from "./MainEstudiante/MainEstudiante.jsx"
export {default as SeleccionarDocente} from "./MainEstudiante/SeleccionarDocente.jsx"
export {default as DocenteAsignado} from "./MainEstudiante/DocenteAsignado.jsx"

//Main Docente
export {default as MainDocente} from "./MainDocente/MainDocente.jsx"
export {default as SolicitudesDocente} from "./MainDocente/Solicitudes.jsx" //recibe y gestiona solicitudes de estudiantes
export {default as CursosDocente} from "./MainDocente/CursosDocente.jsx"
export {default as EstudiantesCurso} from "./MainDocente/EstudiantesCurso.jsx"
export {default as EstadisticaEstudiante} from "./MainDocente/EstadisticaEstudiante.jsx"
export {default as EstadisticaCurso} from "./MainDocente/EstadisticaCurso.jsx"
export {default as AlDetalle} from "./MainDocente/AlDetalle.jsx"


//COMPONENTES PARA TODAS LAS ETAPAS

//Registrar avance del estudiante
export { default as RegistrarAvanceEstudiante } from "./EtapasComponentes/RegistrarAvanceEstudiante/RegistrarAvanceEstudiante.jsx";
export { calcularPorcentajeCorrectas } from "./EtapasComponentes/RegistrarAvanceEstudiante/RegistrarAvanceEstudiante.jsx";
export { formatearTiempo } from "./EtapasComponentes/RegistrarAvanceEstudiante/RegistrarAvanceEstudiante.jsx";

//Barra de progeso
export * from "./EtapasComponentes/BarraProgreso/BarraProgreso.jsx";

//ManejoRespuesta
export * from "./EtapasComponentes/ManejoRespuesta/ManejoRespuesta.jsx"

//Resumen de respuestas
export * from "./EtapasComponentes/Resumen/Resumen.jsx"

//Visualización etapass
export { default as MostrarNiveles} from './EtapasComponentes/MostrarNiveles/MostrarNiveles.jsx';
export { default as MapaEtapas} from './EtapasComponentes/MostrarNiveles/MapaEtapas.jsx';
export { default as DetalleEtapas} from './EtapasComponentes/MostrarNiveles/DetalleEtapas.jsx';


//ACTIVIDADES
// Problema pelotas aleatorias 
export * from "./EtapasProblemas/Pelotas/Pelotas.jsx"

// Problema espacio muestral
export { default as EspacioMuestral} from './EtapasProblemas/EspacioMuestral/EspacioMuestral.jsx';

//Problema experimentos y eventos
export {default as ExperimentoEvento} from './EtapasProblemas/ExperimentoEvento/ExperimentoEvento.jsx'

//Problema experimentos y eventos
export {default as ProbabilidadDado} from './EtapasProblemas/ProbabilidadDado/ProbabilidadDado.jsx'


//INICIO DE SESIÓN
export { default as Login } from './Sesion/Login.jsx';
export { default as Register } from "./Sesion/Register.jsx"
export { default as ProtectedRoute } from "./Sesion/ProtectedRoute.jsx";
export { default as NotFound } from './Sesion/NotFound.jsx';
export { default as LoadingIndicator } from './Sesion/LoadingIndicator.jsx';

//VISTA ADMINISTRADOR
export {default as Administrador } from './MainAdministrador/MainAdministrador.jsx';