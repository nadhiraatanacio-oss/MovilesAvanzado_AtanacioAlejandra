// Desarrollado por: Alejandra Atanacio
// Ejercicio 1: Arrays
import Foundation

// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = []
for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}
print("Alumnos: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====
print("Buscar alumno:")
let buscar = readLine() ?? ""
if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = []
for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0
for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}
print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")

//Fix
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Kiwi") // FIX 1: el array es de String, no puede recibir un Int7

var colores = ["Rojo", "Azul", "Verde"] // FIX 2: era "let", no se puede mutar una constante → se cambia a "var"
colores.append("Amarillo")

let numeros = [10, 20, 30, 40, 50]
print(numeros[4]) // FIX 3: el array tiene 5 elementos (índices 0 a 4), el índice 5 no existe

//PREDICT

var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)
print(lista) // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres) // PREDICT 4: ["Ana", "Carlos", "Beto"] -< sorted() no modifica el original
