// Desarrollado por: Alejandra Atanacio
import UIKit

class Producto {
    let nombre: String
    let precio: Double
    var stock: Int

    init(nombre: String, precio: Double, stock: Int) {
        self.nombre = nombre
        self.precio = precio
        self.stock = stock
    }
}

class ItemCarrito {
    let producto: Producto
    var cantidad: Int

    init(producto: Producto, cantidad: Int) {
        self.producto = producto
        self.cantidad = cantidad
    }

    func subtotal() -> Double {
        return producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    var items: [ItemCarrito] = []

    // A1: agrega respetando el stock (incluye lo que ya está en el carrito)
    func agregar(producto: Producto, cantidad: Int) -> Bool {
        if cantidad <= 0 { return false }

        // === compara si es el MISMO objeto (funciona porque Producto es class)
        if let item = items.first(where: { $0.producto === producto }) {
            if item.cantidad + cantidad > producto.stock { return false }
            item.cantidad += cantidad          // suma a la línea existente
        } else {
            if cantidad > producto.stock { return false }
            items.append(ItemCarrito(producto: producto, cantidad: cantidad))
        }
        return true
    }

    // A2: suma de los subtotales de cada línea
    func subtotal() -> Double {
        var total = 0.0
        for item in items {
            total += item.subtotal()
        }
        return total
    }

    // A3: descuento por tramos
    func porcentajeDescuento() -> Double {
        let s = subtotal()
        if s >= 5000 { return 0.15 }
        else if s >= 2000 { return 0.10 }
        else if s >= 500 { return 0.05 }
        else { return 0.0 }
    }

    // A4: suma de cantidades
    func cantidadTotal() -> Int {
        var total = 0
        for item in items {
            total += item.cantidad
        }
        return total
    }

    // A5: vaciar el carrito
    func vaciar() {
        items.removeAll()
    }

    // --- Cálculos extra (Regla 5: los cálculos viven en el modelo) ---
    func montoDescuento() -> Double {
        return subtotal() * porcentajeDescuento()
    }

    func igv() -> Double {
        return (subtotal() - montoDescuento()) * 0.18
    }

    func total() -> Double {
        return subtotal() - montoDescuento() + igv()
    }

    // Regla 7: categoría con switch
    func categoriaCliente() -> String {
        switch Int(subtotal()) {
        case ..<500:       return "Regular"
        case 500...1999:   return "Frecuente"
        case 2000...4999:  return "VIP"
        default:           return "Premium"
        }
    }
}
