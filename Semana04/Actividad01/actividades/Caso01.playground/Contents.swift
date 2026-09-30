// ===== ACTIVIDAD PROPUESTA 01: FACTURA DE CURSOS =====

struct Curso {
    let nombre: String
    let precioUnitario: Double
    let cantidad: Int
}

let nombreEstudiante = "Juan León"
let dni = "78965412"
let esAlumnoTecsup = true

let cursos: [Curso] = [
    Curso(nombre: "Swift Avanzado", precioUnitario: 450.0, cantidad: 1),
    Curso(nombre: "IA con Python", precioUnitario: 650.0, cantidad: 2),
    Curso(nombre: "Diseño UX/UI", precioUnitario: 500.0, cantidad: 1)
]
var subtotal = 0.0
for curso in cursos {
    subtotal += curso.precioUnitario * Double(curso.cantidad)
}

let igv = subtotal * 0.18
let totalConIGV = subtotal + igv

var descuentoPorCantidad = 0.0
var descuentoTecsup = 0.0

if cursos.count >= 3 {
    descuentoPorCantidad = totalConIGV * 0.10
    if esAlumnoTecsup {
        descuentoTecsup = 400.0
    }
}

let totalFinal = totalConIGV - descuentoPorCantidad - descuentoTecsup

print("FACTURA DE CURSOS")
print("Estudiante: \(nombreEstudiante)")
print("DNI: \(dni)")
print("Alumno de Tecsup: \(esAlumnoTecsup ? "Sí" : "No")")
print("--------------------")
for curso in cursos {
    let totalCurso = curso.precioUnitario * Double(curso.cantidad)
    print("\(curso.nombre) x\(curso.cantidad) - S/ \(totalCurso)")
}
print("--------------------")
print("Subtotal: S/ \(subtotal)")
print("IGV (18%): S/ \(igv)")
print("Total con IGV: S/ \(totalConIGV)")
print("Descuento 10% por cantidad: -S/ \(descuentoPorCantidad)")
print("Descuento especial Tecsup: -S/ \(descuentoTecsup)")
print("TOTAL FINAL A PAGAR: S/ \(totalFinal)")
