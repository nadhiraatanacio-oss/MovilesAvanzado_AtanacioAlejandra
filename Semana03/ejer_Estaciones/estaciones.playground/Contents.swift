import Foundation

typealias InfoEstacion = (linea: String, ascensor: Bool, avenidas: [String], metropolitano: Bool)

var estaciones: [String: InfoEstacion] = [:]

let ordenLinea1 = [
    "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
    "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
    "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
    "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua",
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
    "Cabitos": ["Av. Aviación"],
    "Angamos": ["Av. Angamos", "Av. Aviación"],
    "San Borja Sur": ["Av. Aviación", "Av. San Borja Sur"],
    "La Cultura": ["Av. Javier Prado", "Av. Aviación"],
    "Arriola": ["Av. Aviación", "Av. San Luis"],
    "Gamarra": ["Av. Aviación", "Av. Gamarra"],
    "Miguel Grau": ["Av. Grau", "Av. Aviación"],
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

let estacionMetropolitano = "La Cultura"


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
