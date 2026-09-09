
import Foundation

// Guardo cada estación como una tupla: línea, si tiene ascensor,
// avenidas cercanas y si conecta con el Metropolitano
typealias InfoEstacion = (linea: String, ascensor: Bool, avenidas: [String], metropolitano: Bool)

var estaciones: [String: InfoEstacion] = [:]

let ordenLinea1 = [
    "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
    "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
    "Los Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Nicolás Arriola",
    "Gamarra", "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua",
    "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos",
    "San Martín", "Santa Rosa", "Bayóvar"
]

let ordenLinea2 = [
    "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial",
    "Hermilio Valdizán", "Mercado Santa Anita"
]

let avenidasLinea1: [String: [String]] = [
    "Villa El Salvador": ["Av. Pastor Sevilla", "Av. Micaela Bastidas"],
    "Parque Industrial": ["Av. Los Héroes"],
    "Pumacahua": ["Av. Pastor Sevilla"],
    "Villa María": ["Av. Los Héroes"],
    "María Auxiliadora": ["Av. Los Héroes"],
    "San Juan": ["Av. Los Héroes", "Av. San Juan"],
    "Atocongo": ["Av. Circunvalación", "Av. Los Héroes"],
    "Jorge Chávez": ["Av. Los Héroes", "Av. Miguel Iglesias"],
    "Ayacucho": ["Av. Miguel Iglesias"],
    "Los Cabitos": ["Av. Aviación"],
    "Angamos": ["Av. Angamos", "Av. Aviación"],
    "San Borja Sur": ["Av. Aviación", "Av. San Borja Sur"],
    "La Cultura": ["Av. Javier Prado", "Av. Aviación"],
    "Nicolás Arriola": ["Av. Aviación", "Av. San Luis"],
    "Gamarra": ["Av. Aviación", "Av. Gamarra"],
    "Miguel Grau": ["Av. Grau", "Av. Nicolás Ayllón"],
    "El Ángel": ["Av. Locumba"],
    "Presbítero Maestro": ["Av. Nicolás Ayllón"],
    "Caja de Agua": ["Av. Nicolás Ayllón"],
    "Pirámide del Sol": ["Av. Próceres de la Independencia"],
    "Los Jardines": ["Av. Próceres de la Independencia"],
    "Los Postes": ["Av. Próceres de la Independencia"],
    "San Carlos": ["Av. Próceres de la Independencia"],
    "San Martín": ["Av. Próceres de la Independencia"],
    "Santa Rosa": ["Av. Próceres de la Independencia"],
    "Bayóvar": ["Av. Próceres de la Independencia", "Av. Fernando Wiesse"]
]

let avenidasLinea2: [String: [String]] = [
    "Evitamiento": ["Av. Nicolás Ayllón", "Vía de Evitamiento"],
    "Óvalo Santa Anita": ["Carretera Central", "Av. Los Ángeles"],
    "Colectora Industrial": ["Av. Colectora Industrial"],
    "Hermilio Valdizán": ["Av. Hermilio Valdizán"],
    "Mercado Santa Anita": ["Av. Los Ángeles"]
]

let conAscensor: Set<String> = [
    "Villa El Salvador", "La Cultura", "Miguel Grau", "Gamarra", "Bayóvar",
    "Evitamiento", "Mercado Santa Anita"
]

let estacionMetropolitano = "Miguel Grau"

// Diccionario de lugares cercanos a cada estación (mall, parque, hospital, etc.)
// para que el usuario se pueda orientar al llegar
let lugaresCercanos: [String: [String]] = [
    "Villa El Salvador": ["Parque Industrial de Villa El Salvador", "Municipalidad de VES"],
    "Parque Industrial": ["Zona de fábricas y talleres"],
    "Pumacahua": ["Zona residencial", "Mercado de barrio"],
    "Villa María": ["Zona residencial", "Colegios locales"],
    "María Auxiliadora": ["Parroquia María Auxiliadora", "Zona residencial"],
    "San Juan": ["Mercado de San Juan de Miraflores", "Comercios de Av. Los Héroes"],
    "Atocongo": ["Mall del Sur", "Parque de la Amistad", "Parque de la Juventud"],
    "Jorge Chávez": ["Zona residencial", "Comercios de Av. Los Héroes"],
    "Ayacucho": ["Zona comercial local"],
    "Los Cabitos": ["Zona residencial de Surquillo", "Talleres y ferreterías"],
    "Angamos": ["Real Plaza Primavera (mall)", "Coliseo Eduardo Dibós", "INEN"],
    "San Borja Sur": ["Parque zonal de San Borja", "Zona residencial"],
    "La Cultura": ["Museo de la Nación", "Gran Teatro Nacional", "Biblioteca Nacional"],
    "Nicolás Arriola": ["Zona comercial de Av. Aviación", "Talleres y ferreterías"],
    "Gamarra": ["Emporio Comercial Gamarra (galería textil)"],
    "Miguel Grau": ["Hospital Nacional Dos de Mayo", "Complejo Deportivo Virrey Toledo"],
    "El Ángel": ["Cementerio Presbítero Maestro", "Zona residencial"],
    "Presbítero Maestro": ["Cementerio Presbítero Maestro", "Comercios de Av. Nicolás Ayllón"],
    "Caja de Agua": ["Zona residencial", "Mercado local"],
    "Pirámide del Sol": ["Zona comercial de Av. Próceres", "Colegios locales"],
    "Los Jardines": ["Zona residencial", "Áreas verdes del distrito"],
    "Los Postes": ["Zona comercial local"],
    "San Carlos": ["Zona residencial de San Juan de Lurigancho"],
    "San Martín": ["Colegios y mercados de barrio"],
    "Santa Rosa": ["Zona residencial", "Comercios locales"],
    "Bayóvar": ["Zona comercial de Bayóvar", "Colegios y mercados locales"],
    "Evitamiento": ["Zona industrial de Santa Anita"],
    "Óvalo Santa Anita": ["Carretera Central", "Comercios y talleres"],
    "Colectora Industrial": ["Zona de almacenes y fábricas"],
    "Hermilio Valdizán": ["Zona residencial de Santa Anita"],
    "Mercado Santa Anita": ["Mercado Mayorista de Santa Anita"]
]

let infoLineas: [String: (tarifa: String, horario: String)] = [
    "Línea 1": (tarifa: "S/ 1.50 (tarjeta propia de Línea 1)", horario: "Lunes a sábado 5:00-22:00, domingos y feriados 5:30-22:00"),
    "Línea 2": (tarifa: "S/ 1.40, S/ 0.70 tarifa reducida (Tarjeta Interoperable de Transporte)", horario: "Todos los días 6:00-23:00")
]

let lineasFuturas: [String: String] = [
    "Línea 3": "Aún en proyecto (sin construcción). Ruta futura: Comas - San Juan de Miraflores.",
    "Línea 4": "Aún en construcción (solo el ramal al aeropuerto). Ruta futura: Callao - Santa Anita."
]

// Estaciones de las líneas que aún no operan. Solo guardo el nombre y
// a qué línea pertenecen, para poder avisar que existen en el mapa,
// sin inventar
let estacionesFuturas: [String: String] = [
    "El Álamo": "Línea 3", "Huandoy": "Línea 3", "2 de Octubre": "Línea 3",
    "Villa Sol": "Línea 3", "Naranjal": "Línea 3", "Carlos Izaguirre": "Línea 3",
    "Tomás Valle": "Línea 3", "Bartolomé de las Casas": "Línea 3", "José Granda": "Línea 3",
    "Caquetá": "Línea 3", "Tacna": "Línea 3", "Garcilaso de la Vega": "Línea 3",
    "Parque de la Reserva": "Línea 3", "Museo de Historia Natural": "Línea 3",
    "César Canevaro": "Línea 3", "Andrés Aramburú": "Línea 3", "Huaca Pucllana": "Línea 3",
    "Parque Central de Miraflores": "Línea 3", "Parque Reducto": "Línea 3",
    "Panamá": "Línea 3", "Juana Alarco": "Línea 3", "Alejandro Velasco": "Línea 3",
    "Las Gardenias": "Línea 3", "Los Héroes": "Línea 3", "Pedro Miotta": "Línea 3",
    "Gambeta": "Línea 4", "Canta Callao": "Línea 4", "Bocanegra": "Línea 4",
    "Aeropuerto": "Línea 4", "El Olivar": "Línea 4", "Quilca": "Línea 4",
    "Morales Duárez": "Línea 4", "Carmen de la Legua": "Línea 4", "Venezuela": "Línea 4",
    "Rafael Escardó": "Línea 4", "Pando": "Línea 4", "José de Sucre": "Línea 4",
    "Brasil": "Línea 4", "Felipe Salaverry": "Línea 4", "Guillermo Prescott": "Línea 4",
    "Las Palmeras": "Línea 4", "Rivera Navarrete": "Línea 4", "Pablo Carriquiry": "Línea 4",
    "San Luis": "Línea 4", "Monterrico": "Línea 4", "Manuel Olguín": "Línea 4",
    "Los Frutales": "Línea 4", "La Molina": "Línea 4", "Santa Patricia": "Línea 4",
    "Mayorazgo": "Línea 4"
]

let minutosPorTramo: [String: Double] = [
    "Línea 1": 2.2,
    "Línea 2": 1.75
]

for nombre in ordenLinea1 {
    let avenidas = avenidasLinea1[nombre] ?? []
    let ascensor = conAscensor.contains(nombre)
    let metropolitano = nombre == estacionMetropolitano
    estaciones[nombre] = (linea: "Línea 1", ascensor: ascensor, avenidas: avenidas, metropolitano: metropolitano)
}

for nombre in ordenLinea2 {
    let avenidas = avenidasLinea2[nombre] ?? []
    let ascensor = conAscensor.contains(nombre)
    estaciones[nombre] = (linea: "Línea 2", ascensor: ascensor, avenidas: avenidas, metropolitano: false)
}

var conexiones: [String: [String]] = [:]

func construirConexiones(orden: [String]) {
    for i in 0..<orden.count {
        var vecinas: [String] = []
        if i > 0 {
            vecinas.append(orden[i - 1])
        }
        if i < orden.count - 1 {
            vecinas.append(orden[i + 1])
        }
        conexiones[orden[i]] = vecinas
    }
}

construirConexiones(orden: ordenLinea1)
construirConexiones(orden: ordenLinea2)
