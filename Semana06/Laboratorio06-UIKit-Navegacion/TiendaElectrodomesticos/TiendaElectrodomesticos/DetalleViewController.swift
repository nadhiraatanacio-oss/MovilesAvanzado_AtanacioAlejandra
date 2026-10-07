// Desarrollado por: Alejandra Atanacio
import UIKit

class DetalleViewController: UIViewController {

    // Llegan desde el Catálogo por prepare(for:sender:)
    var producto: Producto!
    var carrito: CarritoModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = producto.nombre
    }
}
