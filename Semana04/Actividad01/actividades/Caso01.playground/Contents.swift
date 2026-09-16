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
