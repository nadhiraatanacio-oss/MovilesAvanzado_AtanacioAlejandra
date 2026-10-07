// Desarrollado por: Alejandra Atanacio
import UIKit

class DetalleViewController: UIViewController {

    // Llegan desde el Catálogo por prepare(for:sender:)
    var producto: Producto!
    var carrito: CarritoModel!

    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var cantidadLabel: UILabel!
    @IBOutlet weak var cantidadStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Aquí los IBOutlet ya existen (en prepare todavía eran nil)
        title = producto.nombre
        precioLabel.text = String(format: "S/ %.2f", producto.precio)
        cantidadLabel.text = "Cantidad: 1"

        let enCarrito = carrito.items.first(where: { $0.producto === producto })?.cantidad ?? 0
        stockLabel.text = "Stock: \(producto.stock)  ·  En tu carrito: \(enCarrito)"
    }

    @IBAction func stepperCambio(_ sender: UIStepper) {
        cantidadLabel.text = "Cantidad: \(Int(sender.value))"
    }

    @IBAction func agregarTapped(_ sender: UIButton) {
        let cantidad = Int(cantidadStepper.value)

        if carrito.agregar(producto: producto, cantidad: cantidad) {
            let alerta = UIAlertController(title: "Agregado ✅",
                                           message: "\(producto.nombre) x\(cantidad) se agregó al carrito.",
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)  // vuelve al Catálogo
            })
            present(alerta, animated: true)
        } else {
            let alerta = UIAlertController(title: "Stock insuficiente",
                                           message: "Solo hay \(producto.stock) unidades de \(producto.nombre), contando lo que ya tienes en el carrito.",
                                           preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Entendido", style: .default))
            present(alerta, animated: true)
        }
    }
}
