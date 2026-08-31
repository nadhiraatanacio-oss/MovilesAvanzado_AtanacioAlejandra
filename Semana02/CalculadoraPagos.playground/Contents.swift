import Foundation
// Alinear texto en columnas
func pad(_ texto: String, _ ancho: Int) -> String {
    if texto.count >= ancho { return texto }
    return texto + String(repeating: " ", count: ancho - texto.count)
}
// Datos del producto

print("Nombre del Producto: ", terminator: "")
let nombreProducto = readLine() ?? ""

print("Precio Unit: ", terminator: "")
let precioUnitario = Double(readLine() ?? "") ?? 0.0

print("Cantidad: ", terminator: "")
let cantidad = Int(readLine() ?? "") ?? 0

let montoTotal = precioUnitario * Double(cantidad)
print("Monto total de la compra: \(String(format: "%.2f", montoTotal))")
// Plan de pago

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

print("\n========================= PLAN DE PAGO =========================")
print("Producto: \(nombreProducto)")
print("Intereses: S/. \(String(format: "%.2f", intereses))    Cuotas: \(plan) meses")
print("Monto compra: S/. \(String(format: "%.2f", montoTotal))    Monto final: S/. \(String(format: "%.2f", montoFinal))")
print("==================================================================\n")
// Tabla de amortización

print(pad("Mes", 6) + pad("Monto inicial", 16) + pad("Cuota mensual", 16) + "Resta x pago")
print(String(repeating: "-", count: 54))

var montoInicial = montoFinal
for mes in 1...plan {
    let restaXPago = montoInicial - cuotaMensual
    print(pad("\(mes)", 6) + pad(String(format: "%.2f", montoInicial), 16) + pad(String(format: "%.2f", cuotaMensual), 16) + String(format: "%.2f", restaXPago))
    montoInicial = restaXPago
}
