import Foundation

//un calendario de pagos
//ingresar el nombre del producto, precio y cantidad
let igv = 0.18
func CalcularDescuesto (cantidad: Int, subtotal: Double)-> Double {
    if cantidad > 10 {
        return subtotal * 0.15
    }else if cantidad > 5 {
        return subtotal * 0.10
    }else
    {
        return 0.0
    }
}
print ("ingrese el nombre del producto")
let producto = readLine() ?? ""
print ("Ingrese el precio de producto")
let precio = Double(readLine() ?? "0") ?? 0.0
print ("ingrese la cantidad de producto")
let cantidad = Int(readLine() ?? "0") ?? 0

let subtotal = precio * Double(cantidad)
let descuento = CalcularDescuesto(cantidad: cantidad, subtotal: subtotal)
let montobase = subtotal - descuento
let igvcalculo = montobase * igv
let total = montobase + igvcalculo

print("El monto base es \(montobase)")
print("El IGV es \(igvcalculo)")
print("El total es \(total)")



// hallar el monto base: subtotal - descuento
//hallar el igv : montobase * igv
//toal monto base + igv
//commit
//mostrar los datos


