// Desarrollado por: Alejandra Atanacio
import UIKit

class CatalogoViewController: UIViewController {

    // Datos fijos del caso (Regla 1)
    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4)
    ]

    // El carrito se crea UNA sola vez, aquí (Regla 2)
    let carrito = CarritoModel()

    @IBOutlet weak var verCarritoButton: UIButton!

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Catálogo"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // B2: se ejecuta CADA vez que vuelves a esta pantalla
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verCarritoButton.setTitle("Ver carrito (\(carrito.cantidadTotal()))", for: .normal)
    }

    // Los 4 botones de producto usan ESTA misma acción
    @IBAction func productoTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            let boton = sender as! UIButton
            let destino = segue.destination as! DetalleViewController
            destino.producto = productos[boton.tag]   // producto según el tag
            destino.carrito = carrito                 // el MISMO objeto
        }
        // TODO B1: caso "verCarrito" (se completa en el Checkpoint 4)
    }
}
