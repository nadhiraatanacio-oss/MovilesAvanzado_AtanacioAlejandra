import Foundation

// Guardo cada estación como una tupla: línea, si tiene ascensor,
// avenidas cercanas y si conecta con el Metropolitano
typealias InfoEstacion = (linea: String, ascensor: Bool, avenidas: [String], metropolitano: Bool)

// Estaciones de la Línea 1 en orden real, de sur a norte
let ordenLinea1 = [
    "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
    "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
    "Los Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Nicolás Arriola",
    "Gamarra", "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua",
    "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos",
    "San Martín", "Santa Rosa", "Bayóvar"
]

// Estaciones de la Línea 2
let ordenLinea2 = [
    "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial",
    "Hermilio Valdizán", "Mercado Santa Anita"
]

// Avenidas cercanas por estación, Línea 1
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

// Avenidas cercanas por estación, Línea 2
let avenidasLinea2: [String: [String]] = [
    "Evitamiento": ["Av. Nicolás Ayllón", "Vía de Evitamiento"],
    "Óvalo Santa Anita": ["Carretera Central", "Av. Los Ángeles"],
    "Colectora Industrial": ["Av. Colectora Industrial"],
    "Hermilio Valdizán": ["Av. Hermilio Valdizán"],
    "Mercado Santa Anita": ["Av. Los Ángeles"]
]

// Estaciones con ascensor
let conAscensor: Set<String> = [
    "Villa El Salvador", "La Cultura", "Miguel Grau", "Gamarra", "Bayóvar",
    "Evitamiento", "Mercado Santa Anita"
]

// La única estación que marco con conexión al Metropolitano
let estacionMetropolitano = "Miguel Grau"

// Diccionario de lugares cercanos a cada estación
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

// Tarifa y horario de cada línea (para la opción 5 del menú)
let infoLineas: [String: (tarifa: String, horario: String)] = [
    "Línea 1": (tarifa: "S/ 1.50 (tarjeta propia de Línea 1)", horario: "Lunes a sábado 5:00-22:00, domingos y feriados 5:30-22:00"),
    "Línea 2": (tarifa: "S/ 1.40, S/ 0.70 tarifa reducida (Tarjeta Interoperable de Transporte)", horario: "Todos los días 6:00-23:00")
]

// información de las líneas 3 y 4 es referencial y proyecciones propuestos
let lineasFuturas: [String: String] = [
    "Línea 3": "Aún en proyecto (sin construcción). Ruta futura referencial: Comas - San Juan de Miraflores.",
    "Línea 4": "Aún en construcción (solo el ramal al aeropuerto). Ruta futura referencial: Callao - Santa Anita."
]

// Estaciones de las líneas que aún no operan
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

// Minutos aprox entre estación y estación, según la línea
let minutosPorTramo: [String: Double] = [
    "Línea 1": 2.2,
    "Línea 2": 1.75
]

// Arma el diccionario de estaciones (línea, ascensor, avenidas, Metropolitano)
// juntando ambas líneas
func construirEstaciones() -> [String: InfoEstacion] {
    var resultado: [String: InfoEstacion] = [:]

    for nombre in ordenLinea1 {
        let avenidas = avenidasLinea1[nombre] ?? []
        let ascensor = conAscensor.contains(nombre)
        let metropolitano = nombre == estacionMetropolitano
        resultado[nombre] = (linea: "Línea 1", ascensor: ascensor, avenidas: avenidas, metropolitano: metropolitano)
    }

    for nombre in ordenLinea2 {
        let avenidas = avenidasLinea2[nombre] ?? []
        let ascensor = conAscensor.contains(nombre)
        resultado[nombre] = (linea: "Línea 2", ascensor: ascensor, avenidas: avenidas, metropolitano: false)
    }

    return resultado
}

let estaciones: [String: InfoEstacion] = construirEstaciones()


// Por cada estación guarda su vecina anterior y siguiente dentro de la misma línea
func construirConexiones(orden: [String]) -> [String: [String]] {
    var resultado: [String: [String]] = [:]

    for i in 0..<orden.count {
        var vecinas: [String] = []
        if i > 0 {
            vecinas.append(orden[i - 1])
        }
        if i < orden.count - 1 {
            vecinas.append(orden[i + 1])
        }
        resultado[orden[i]] = vecinas
    }

    return resultado
}

// Junto las conexiones de ambas líneas en un solo diccionario
let conexiones: [String: [String]] = construirConexiones(orden: ordenLinea1)
    .merging(construirConexiones(orden: ordenLinea2)) { actual, _ in actual }

// Quita tildes y mayúsculas al texto para poder comparar
// lo que escribe el usuario
func normalizar(_ texto: String) -> String {
    return texto
        .folding(options: .diacriticInsensitive, locale: .current)
        .lowercased()
        .trimmingCharacters(in: .whitespaces)
}

// Busca el nombre correcto de una estación a partir de lo que escribió el usuario
func buscarNombreReal(_ entrada: String) -> String? {
    let entradaNormalizada = normalizar(entrada)
    for clave in estaciones.keys {
        if normalizar(clave) == entradaNormalizada {
            return clave
        }
    }
    return nil
}

// Igual que arriba pero busca entre las estaciones futuras (Línea 3 y 4)
func buscarEstacionFutura(_ entrada: String) -> (nombre: String, linea: String)? {
    let entradaNormalizada = normalizar(entrada)
    for (nombre, linea) in estacionesFuturas {
        if normalizar(nombre) == entradaNormalizada {
            return (nombre, linea)
        }
    }
    return nil
}

// Muestra toda la ficha de la estación. Si no la encuentra entre
// las operativas, revisa si es una futura antes de decir que no existe
func mostrarInfo(de entrada: String) {
    if let nombre = buscarNombreReal(entrada) {
        let info = estaciones[nombre]!
        print("\nEstación: \(nombre)")
        print("Línea: \(info.linea)")
        print("Tiene ascensor: \(info.ascensor ? "Sí" : "No")")
        print("Avenidas cercanas: \(info.avenidas.joined(separator: ", "))")
        print("Conecta con el Metropolitano: \(info.metropolitano ? "Sí" : "No")")

        let cercanos = lugaresCercanos[nombre] ?? []
        if cercanos.isEmpty {
            print("Lugares cercanos: sin datos registrados")
        } else {
            print("Lugares cercanos: \(cercanos.joined(separator: ", "))")
        }

        let vecinas = conexiones[nombre] ?? []
        if vecinas.isEmpty {
            print("Conexiones directas: es estación terminal")
        } else {
            print("Conexiones directas: \(vecinas.joined(separator: " y "))")
        }
    } else if let futura = buscarEstacionFutura(entrada) {
        print("\n\(futura.nombre) es una estación proyectada (referencial) de la \(futura.linea), todavía no está en operación.")
    } else {
        print("No encontré esa estación. Verifica que esté bien escrita e intenta de nuevo.")
    }
}

// Filtra las estaciones de la línea que pidió el usuario y las lista ordenadas
func listarPorLinea(_ entrada: String) {
    let lineaNormalizada = normalizar(entrada)
    var encontradas: [String] = []

    for (nombre, info) in estaciones {
        if normalizar(info.linea) == lineaNormalizada {
            encontradas.append(nombre)
        }
    }

    if encontradas.isEmpty {
        print("No encontré estaciones de esa línea. Verifica que esté bien escrita (ej: Línea 1)")
    } else {
        print("\nEstaciones de \(entrada):")
        for nombre in encontradas.sorted() {
            print("- \(nombre)")
        }
    }
}

// Cuenta cuántas estaciones hay entre origen y destino (misma línea)
// y calcula el tiempo aprox
func calcularTiempo(desde entradaOrigen: String, hasta entradaDestino: String) {
    guard let origen = buscarNombreReal(entradaOrigen), let destino = buscarNombreReal(entradaDestino) else {
        print("No encontré una de las dos estaciones. Verifica que estén bien escritas.")
        return
    }

    let infoOrigen = estaciones[origen]!
    let infoDestino = estaciones[destino]!

    if infoOrigen.linea != infoDestino.linea {
        print("\(origen) y \(destino) están en líneas distintas, no puedo calcular un tiempo directo entre ellas.")
        return
    }

    // Orden correcto según la línea para saber la posición de cada estación
    let orden = infoOrigen.linea == "Línea 1" ? ordenLinea1 : ordenLinea2
    guard let indiceOrigen = orden.firstIndex(of: origen), let indiceDestino = orden.firstIndex(of: destino) else {
        return
    }

    let tramos = abs(indiceDestino - indiceOrigen)
    let minutos = Double(tramos) * (minutosPorTramo[infoOrigen.linea] ?? 2.0)

    print("\nDe \(origen) a \(destino): \(tramos) estaciones de distancia")
    print("Tiempo estimado: \(String(format: "%.0f", minutos)) minutos aprox.")
}

// imprime tarifa y horario de cada línea, más el estado de las futuras
func mostrarTarifasYHorarios() {
    print("\n=== Tarifas y horarios ===")
    if let l1 = infoLineas["Línea 1"] {
        print("Línea 1:")
        print("  Tarifa: \(l1.tarifa)")
        print("  Horario: \(l1.horario)")
    }
    if let l2 = infoLineas["Línea 2"] {
        print("\nLínea 2:")
        print("  Tarifa: \(l2.tarifa)")
        print("  Horario: \(l2.horario)")
    }

    print("\n=== Próximas líneas (información referencial, sujeta a cambios) ===")
    for (linea, estado) in lineasFuturas.sorted(by: { $0.key < $1.key }) {
        print("\(linea): \(estado)")
    }
}

//commit 6
// Menú principal, se repite hasta que el usuario elige salir
print("=== Sistema de consulta - Metro de Lima ===")

var seguir = true
while seguir {
    print("\n1. Buscar estación")
    print("2. Ver estaciones por línea")
    print("3. Ver con qué estaciones conecta")
    print("4. Calcular tiempo entre dos estaciones")
    print("5. Ver tarifas y horarios")
    print("6. Salir")
    print("Elige una opción: ", terminator: "")

    let opcion = readLine() ?? ""

    if opcion == "1" {
        print("Nombre de la estación: ", terminator: "")
        let nombre = readLine() ?? ""
        mostrarInfo(de: nombre)
    } else if opcion == "2" {
        print("Escribe la línea (Línea 1 / Línea 2): ", terminator: "")
        let linea = readLine() ?? ""
        listarPorLinea(linea)
    } else if opcion == "3" {
        // solo muestra las vecinas directas, sin la ficha completa
        print("Nombre de la estación: ", terminator: "")
        let entrada = readLine() ?? ""
        if let nombre = buscarNombreReal(entrada), let vecinas = conexiones[nombre] {
            print("\(nombre) conecta con: \(vecinas.joined(separator: ", "))")
        } else {
            print("No encontré esa estación. Verifica que esté bien escrita e intenta de nuevo.")
        }
    } else if opcion == "4" {
        print("Estación de origen: ", terminator: "")
        let origen = readLine() ?? ""
        print("Estación de destino: ", terminator: "")
        let destino = readLine() ?? ""
        calcularTiempo(desde: origen, hasta: destino)
    } else if opcion == "5" {
        mostrarTarifasYHorarios()
    } else if opcion == "6" {
        seguir = false
        print("Listo, saliendo del sistema")
    } else {
        print("Opción no válida, elige un número del 1 al 6")
    }
}
