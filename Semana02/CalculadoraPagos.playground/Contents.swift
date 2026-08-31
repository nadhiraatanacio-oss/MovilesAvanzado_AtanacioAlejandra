import Foundation

// Datos del producto
print("Nombre Producto: ", terminator: "")
let nombreProducto = readLine() ?? ""

print("Precio Unitario: ", terminator: "")
let precioUnitario = Double(readLine() ?? "") ?? 0.0

print("Cantidad: ", terminator: "")
let cantidad = Int(readLine() ?? "") ?? 0

let montoTotal = precioUnitario * Double(cantidad)
print("Monto total compra: \(String(format: "%.2f", montoTotal))")

// Validación del plan
var plan = 0
while plan != 6 && plan != 12 && plan != 24 {
    print("Plan de pago (6, 12, 24): ", terminator: "")
    plan = Int(readLine() ?? "") ?? 0
    if plan != 6 && plan != 12 && plan != 24 {
        print("Plan inválido, intenta de nuevo.")
    }
}

print("Plan seleccionado: \(plan) meses")


