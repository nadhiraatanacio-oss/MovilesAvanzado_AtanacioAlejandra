// ===== CASO 1.5: HERENCIA Y POLIMORFISMO — LA CADENA DE SUCURSALES =====
// Docente: Juan León

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// --- Ejemplo (ya resuelto): la base define el FLUJO; las hijas cambiaran las REGLAS ---
class Sucursal {
    let nombre: String
    let ciudad: String
    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }
    func descuento() -> Double {
        return 0.05
    }
    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }
    // REGLA 2: este metodo NO se sobreescribe en las subclases
    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// --- TODO 14: SucursalLima ---
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }
    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// --- TODO 15: SucursalProvincia ---
class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let envio = monto * 0.08
        if envio < 50.0 {
            return 50.0
        } else {
            return envio
        }
    }
}

// --- TODO 16: SucursalOutlet ---
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }
    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// --- TODO 17: El recorrido polimorfico (REGLA 4) ---
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)
let sucursales: [Sucursal] = [SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
                               SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
                               SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima")]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales { sucursal.cotizar(item: refrigeradora) }

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales { sucursal.cotizar(item: licuadora) }

// --- TODO 18: La prueba del polimorfismo (REGLA 6) ---
// Agregamos SucursalOnline sin tocar cotizar() ni los for-in
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
// Solo se necesitaron 3 lineas nuevas: la clase SucursalOnline (con su override) y agregarla al array de sucursales.

// ===== FIX: Este codigo tiene 2 errores =====
// Docente: Juan León
class SucursalMall: Sucursal {
    override func descuento() -> Double { // FIX 7: faltaba 'override' porque Swift exige marcarlo cuando reemplazas un metodo heredado
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int
    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        super.init(nombre: nombre, ciudad: ciudad) // FIX 8: faltaba llamar al init de la clase base para inicializar nombre y ciudad
    }
}

// ===== PREDICT: Que imprime? =====
// Docente: Juan León
let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")
print(misteriosa.descuento()) // PREDICT 6: imprime 0.1 (no 0.05). Aunque el tipo declarado es Sucursal, el objeto real es SucursalLima; Swift usa despacho dinamico y llama al metodo de la clase real.
let monto = 2000.0 * (1 - misteriosa.descuento())
print(misteriosa.costoEnvio(monto: monto)) // PREDICT 7: monto = 1800.0, como es >= 1500, costoEnvio devuelve 0.0
// ===== CASO 2 — PARTE B: BIBLIOTECA (CON IA) =====
// Docente: Juan León
// Pide a la IA el mismo enunciado de la Parte A, con las mismas firmas.
// MARK: - Enum de estado del libro
enum EstadoLibro {
    case disponible // El libro está en la biblioteca, se puede prestar
    case prestado   // El libro ya fue entregado a alguien
}

// MARK: - Struct que representa un libro
struct Libro {
    var titulo: String        // Nombre del libro
    var autor: String         // Nombre del autor
    var estado: EstadoLibro = .disponible // Todo libro nuevo empieza disponible
}

// MARK: - Clase que administra la colección de libros
class Biblioteca {
    var libros: [Libro] = [] // Arreglo vacío al inicio

    // Agrega un nuevo libro al arreglo
    func agregar(libro: Libro) {
        libros.append(libro)
    }

    // Busca el libro por título recorriendo el arreglo por índice
    // Si está disponible, lo marca como prestado y retorna true
    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya está prestado")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }

    // Busca el libro por título y, si está prestado, lo marca como disponible
    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {
            if libros[i].titulo == titulo {
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) no estaba prestado")
                    return false
                }
            }
        }
        print("Error: no existe \(titulo)")
        return false
    }

    // Imprime cada libro con su autor y estado usando switch
    func inventario() {
        print("===== INVENTARIO =====")
        for i in 0..<libros.count {
            var estadoTexto = ""
            switch libros[i].estado {
            case .disponible:
                estadoTexto = "disponible"
            case .prestado:
                estadoTexto = "prestado"
            }
            print("\(libros[i].titulo) (\(libros[i].autor)) - \(estadoTexto)")
        }
    }
}
// MARK: - Pruebas
let biblioteca = Biblioteca()

biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez"))
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa"))
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes"))

biblioteca.prestar(titulo: "La ciudad y los perros")   // Préstamo aprobado
biblioteca.prestar(titulo: "La ciudad y los perros")   // Error: ya está prestado
biblioteca.devolver(titulo: "La ciudad y los perros")  // Devolución registrada
biblioteca.prestar(titulo: "El Quijote")               // Préstamo aprobado
biblioteca.prestar(titulo: "El Principito")            // Error: no existe

biblioteca.inventario()
