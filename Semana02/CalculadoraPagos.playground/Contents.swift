
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

// Pago adelantado
print("¿En qué mes hará un pago adelantado? (0 ninguno): ", terminator: "")
let mesAdelanto = Int(readLine() ?? "") ?? 0

var montoAdicional = 0.0
if mesAdelanto > 0 {
    print("Monto Adicional a pagar ese mes (S/.): ", terminator: "")
    montoAdicional = Double(readLine() ?? "") ?? 0.0
}


// función para alinear columnas
func pad(_ texto: String, _ ancho: Int) -> String {
    if texto.count >= ancho { return texto }
    return texto + String(repeating: " ", count: ancho - texto.count)
}

// Cálculo de intereses y cuota
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
print("==================================================================\n")

// Tabla con fechas
print(pad("Mes", 5) + pad("Fecha", 12) + pad("Monto inicial", 16) + pad("Pago", 12) + "Resta x pago")
print(String(repeating: "-", count: 60))

var montoInicial = montoFinal
var mesesPagados = 0
let calendar = Calendar.current
var fecha = Date()

for mes in 1...plan {
    fecha = calendar.date(byAdding: .month, value: 1, to: fecha) ?? fecha
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    let fechaStr = formatter.string(from: fecha)

    var pago = cuotaMensual
    if mes == mesAdelanto {
        pago += montoAdicional
    }

    let restaXPago = montoInicial - pago
    print(pad("\(mes)", 5) + pad(fechaStr, 12) + pad(String(format: "%.2f", montoInicial), 16) + pad(String(format: "%.2f", pago), 12) + String(format: "%.2f", restaXPago))
    montoInicial = restaXPago
    mesesPagados += 1
}

print("\nMeses Pagados: \(mesesPagados) de \(plan)")
