// Desarrollado por: Ale
// Ejercicio 7: Inventario con menú

import Foundation

// ===== REGISTRO DE PRODUCTOS =====

var nombresProd: [String] = []
var preciosProd: [Double] = []
var stocksProd: [Int] = []

print("¿Cuántos productos vas a registrar?")

let totalProd = Int(readLine() ?? "") ?? 0

// Registrar productos
for i in 0..<totalProd {

    print("\nProducto \(i + 1) - Nombre:")
    let nombre = readLine() ?? ""
    nombresProd.append(nombre)

    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0
    preciosProd.append(precio)

    print("Stock:")
    let stock = Int(readLine() ?? "") ?? 0
    stocksProd.append(stock)
}

// ===== MENÚ INVENTARIO =====

var opcion = 0

while opcion != 5 {

    print("\n===== MENÚ INVENTARIO =====")
    print("1) Ver inventario")
    print("2) Buscar producto")
    print("3) Ver stock bajo")
    print("4) Ver valor total")
    print("5) Salir")
    print("Elige una opción:")

    opcion = Int(readLine() ?? "") ?? 0

    switch opcion {

    // OPCIÓN 1: VER INVENTARIO
    case 1:

        print("\n===== INVENTARIO =====")

        if nombresProd.isEmpty {
            print("No hay productos registrados")
        } else {
            for i in 0..<nombresProd.count {
                print("\(nombresProd[i]) - Precio: S/. \(preciosProd[i]) - Stock: \(stocksProd[i])")
            }
        }

    // OPCIÓN 2: BUSCAR PRODUCTO
    case 2:

        print("\nNombre a buscar:")

        let buscado = readLine() ?? ""

        if let indice = nombresProd.firstIndex(of: buscado) {

            print("\nProducto encontrado:")
            print("\(nombresProd[indice]) - Precio: S/. \(preciosProd[indice]) - Stock: \(stocksProd[indice])")

        } else {

            print("Producto no encontrado")

        }

    // OPCIÓN 3: VER STOCK BAJO
    case 3:

        print("\n===== STOCK BAJO (menos de 5) =====")

        var hayStockBajo = false

        for i in 0..<nombresProd.count {

            if stocksProd[i] < 5 {

                print("\(nombresProd[i]): \(stocksProd[i]) unidades")

                hayStockBajo = true
            }
        }

        if !hayStockBajo {
            print("No hay productos con stock bajo")
        }

    // OPCIÓN 4: VALOR TOTAL
    case 4:

        var valorTotal = 0.0

        for i in 0..<nombresProd.count {

            valorTotal += preciosProd[i] * Double(stocksProd[i])

        }

        print("\nValor total del inventario: S/. \(valorTotal)")

    // OPCIÓN 5: SALIR
    case 5:

        print("\nSaliendo del inventario...")

    // OPCIÓN INVÁLIDA
    default:

        print("\nOpción inválida, intenta de nuevo")

    }
}
