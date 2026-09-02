// Desarrollado por: Alejandra
import Foundation

// TODO 10: Inventario de productos
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]
print("¿Cuántos productos?")
let n = Int(readLine() ?? "") ?? 0
for i in 1...n {
    print("Producto \(i) - Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0
    print("Stock:")
    let stock = Int(readLine() ?? "") ?? 0
    precios[nombre] = precio
    stocks[nombre] = stock
}

// Calcular valor total (precio × stock)
var valorTotalInventario = 0.0
for (nombre, precio) in precios {
    if let stock = stocks[nombre] {
        valorTotalInventario += precio * Double(stock)
    }
}
print("\nValor total del inventario: S/. \(valorTotalInventario)")

// Mostrar productos con stock < 5
print("\n===== STOCK BAJO (menos de 5) =====")
for (nombre, stock) in stocks {
    if stock < 5 {
        print("\(nombre): \(stock) unidades")
    }
}
