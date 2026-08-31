import Foundation

print("Nombre del Producto: ", terminator: "")
let nombreProducto = readLine() ?? ""

print("Precio Unit: ", terminator: "")
let precioUnitario = Double(readLine() ?? "") ?? 0.0

print("Cantidad: ", terminator: "")
let cantidad = Int(readLine() ?? "") ?? 0

let montoTotal = precioUnitario * Double(cantidad)
print("Monto total de la compra: \(montoTotal)")

print("Elige el plan de pago (6, 12, 24): ", terminator: "")
let plan = Int(readLine() ?? "") ?? 0

var porcentajeInteres = 0.0
switch plan {
case 6: porcentajeInteres = 0.20
case 12: porcentajeInteres = 0.40
case 24: porcentajeInteres = 0.60
default: porcentajeInteres = 0.0
}

let intereses = montoTotal * porcentajeInteres
let montoFinal = montoTotal + intereses
let cuotaMensual = montoFinal / Double(plan)

print("\n------------------------------------Plan de Pago------------------------------")
print("Producto: \(nombreProducto)   Intereses: \(intereses)   Cuota meses: \(plan)")
print("Monto compra: \(montoTotal)   Monto Final: \(montoFinal)")
