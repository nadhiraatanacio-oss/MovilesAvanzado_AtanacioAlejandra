// ===== EJERCICIO 6: CARRITO MEJORADO (asistido por IA) =====

// --- Datos de productos (mismos del Ejercicio 5) ---
let p1Nombre = "Laptop"          // Nombre del producto 1
let p1Precio = 3500.0            // Precio unitario del producto 1
let p1Cantidad = 1                // Cantidad comprada del producto 1

let p2Nombre = "Mouse"            // Nombre del producto 2
let p2Precio = 45.50               // Precio unitario del producto 2
let p2Cantidad = 3                 // Cantidad comprada del producto 2 (activa descuento por cantidad)

let p3Nombre = "Teclado"          // Nombre del producto 3
let p3Precio = 120.00              // Precio unitario del producto 3
let p3Cantidad = 1                  // Cantidad comprada del producto 3

let p4Nombre = "Monitor"          // Nombre del producto 4
let p4Precio = 890.00              // Precio unitario del producto 4
let p4Cantidad = 1                  // Cantidad comprada del producto 4

let p5Nombre = "USB Cable"        // Nombre del producto 5
let p5Precio = 15.00               // Precio unitario del producto 5
let p5Cantidad = 4                  // Cantidad comprada del producto 5 (activa descuento por cantidad)

let codigoCupon = "DESCUENTO20"   // Código de cupón ingresado por el cliente

// --- REQUISITO 5: Validación de datos ---
var hayError = false               // Bandera que indica si se encontró un dato inválido
let precios = [p1Precio, p2Precio, p3Precio, p4Precio, p5Precio]   // Arreglo con todos los precios para validarlos juntos
let cantidades = [p1Cantidad, p2Cantidad, p3Cantidad, p4Cantidad, p5Cantidad] // Arreglo con todas las cantidades para validarlas juntas

for precio in precios {            // Recorre cada precio del arreglo
    if precio < 0 {                 // Verifica si el precio es negativo
        hayError = true              // Marca error si encuentra un precio negativo
        print("Error: hay un precio negativo en el carrito") // Informa el error encontrado
    }
}

for cantidad in cantidades {       // Recorre cada cantidad del arreglo
    if cantidad == 0 {               // Verifica si la cantidad es cero
        hayError = true               // Marca error si encuentra una cantidad en cero
        print("Error: hay una cantidad en cero en el carrito") // Informa el error encontrado
    }
}

if !hayError {                     // Solo continúa con el cálculo si NO hubo errores de validación

    // --- REQUISITO 1: Descuento por cantidad (5% extra si cantidad >= 3) ---
    func calcularSubtotal(precio: Double, cantidad: Int) -> Double {  // Función que calcula el subtotal de un producto con su posible descuento
        var subtotal = precio * Double(cantidad)    // Calcula el subtotal base (precio x cantidad)
        if cantidad >= 3 {                            // Verifica si la cantidad comprada es 3 o más
            subtotal = subtotal * 0.95                  // Aplica 5% de descuento extra sobre ese producto
        }
        return subtotal                                // Devuelve el subtotal final del producto
    }

    let sub1 = calcularSubtotal(precio: p1Precio, cantidad: p1Cantidad) // Subtotal del producto 1 con su posible descuento
    let sub2 = calcularSubtotal(precio: p2Precio, cantidad: p2Cantidad) // Subtotal del producto 2 con su posible descuento
    let sub3 = calcularSubtotal(precio: p3Precio, cantidad: p3Cantidad) // Subtotal del producto 3 con su posible descuento
    let sub4 = calcularSubtotal(precio: p4Precio, cantidad: p4Cantidad) // Subtotal del producto 4 con su posible descuento
    let sub5 = calcularSubtotal(precio: p5Precio, cantidad: p5Cantidad) // Subtotal del producto 5 con su posible descuento

    let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5  // Suma todos los subtotales para obtener el monto general

    // --- REQUISITO 2: Cupón de descuento (20% adicional si el código es válido) ---
    var totalConCupon = subtotalGeneral                // Variable que guardará el total después de aplicar el cupón
    if codigoCupon == "DESCUENTO20" {                    // Verifica si el cupón ingresado es el válido
        totalConCupon = subtotalGeneral * 0.80             // Aplica 20% de descuento adicional sobre el subtotal
        print("Cupón DESCUENTO20 aplicado: -20% adicional") // Informa que el cupón fue aplicado
    }

    // --- REQUISITO 3: Envío gratis si el total supera S/. 3000 ---
    var costoEnvio = 25.00                              // Costo de envío por defecto
    if totalConCupon > 3000 {                             // Verifica si el total supera los S/. 3000
        costoEnvio = 0.0                                    // Si supera el monto, el envío es gratis
        print("¡Envío gratis! Tu compra superó S/. 3000")   // Informa que el envío es gratuito
    }

    let totalFinal = totalConCupon + costoEnvio          // Suma el envío al total para obtener el monto final a pagar

    // --- REQUISITO 4: Puntos de fidelidad (1 punto por cada S/. 100) ---
    let puntosGanados = Int(totalConCupon / 100)          // Divide el total entre 100 y descarta decimales para obtener los puntos

    // --- Imprimir resumen final ---
    var separador = ""                                   // Variable que construirá la línea separadora del ticket
    for _ in 1...40 {                                     // Repite 40 veces para formar la línea
        separador += "="                                    // Agrega un símbolo "=" en cada vuelta
    }

    print(separador)                                     // Imprime la línea separadora superior
    print("   TICKET MEJORADO - CON IA")                  // Imprime el encabezado del ticket
    print(separador)                                     // Imprime otra línea separadora
    print("Subtotal (con desc. por cantidad): S/. \(subtotalGeneral)") // Muestra el subtotal ya con descuento por cantidad aplicado
    print("Total con cupón: S/. \(totalConCupon)")         // Muestra el total después de aplicar el cupón
    print("Costo de envío: S/. \(costoEnvio)")             // Muestra el costo de envío (0 si fue gratis)
    print("TOTAL FINAL: S/. \(totalFinal)")                // Muestra el monto final que el cliente debe pagar
    print("Puntos de fidelidad ganados: \(puntosGanados)")  // Muestra los puntos de fidelidad acumulados
    print(separador)                                     // Imprime la línea separadora final
}
