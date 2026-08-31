
import Foundation

// ===== Datos del producto =====
var nombreProducto = "Laptop"
var precioUnitario = 1000.0
var cantidad = 3

// ===== Cálculo del monto total =====
var montoTotal = precioUnitario * Double(cantidad)

print("Nombre del Producto: \(nombreProducto)")
print("Precio Unit: \(precioUnitario)")
print("Cantidad: \(cantidad)")
print("Monto total de la compra: \(montoTotal)")
