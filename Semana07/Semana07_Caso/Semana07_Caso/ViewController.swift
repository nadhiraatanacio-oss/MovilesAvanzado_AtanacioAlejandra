import UIKit

// Modelo de datos
struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let imagen: String
}

// PANTALLA 1: Lista de culturas
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let culturas = [
        Cultura(nombre: "Chavín",
                region: "Sierra norte - Áncash",
                descripcion: "Se desarrolló entre los años 1200 y 200 a.C. Su centro principal fue Chavín de Huántar, un templo de piedra famoso por sus cabezas clavas. Rendían culto al felino.",
                imagen: "chavin"),
        Cultura(nombre: "Paracas",
                region: "Costa sur - Ica",
                descripcion: "Se desarrolló entre los años 700 a.C. y 200 d.C. Destacó por sus finos mantos textiles de colores y por realizar trepanaciones craneanas.",
                imagen: "paracas"),
        Cultura(nombre: "Nazca",
                region: "Costa sur - Ica",
                descripcion: "Se desarrolló entre los años 100 a.C. y 700 d.C. Es conocida por las Líneas de Nazca, enormes figuras trazadas en el desierto, y por su cerámica de muchos colores.",
                imagen: "nazca"),
        Cultura(nombre: "Mochica",
                region: "Costa norte - La Libertad y Lambayeque",
                descripcion: "Se desarrolló entre los años 100 y 800 d.C. Fueron grandes ceramistas, famosos por sus huacos retrato. A esta cultura pertenece el Señor de Sipán.",
                imagen: "mochica"),
        Cultura(nombre: "Inca",
                region: "Sierra sur - Cusco",
                descripcion: "Fue el imperio más grande de América del Sur, conocido como el Tahuantinsuyo. Construyeron Machu Picchu y una gran red de caminos llamada Qhapaq Ñan.",
                imagen: "inca")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "culturaCell", for: indexPath) as! CulturaTableViewCell
        let cultura = culturas[indexPath.row]
        cell.culturaNombre.text = cultura.nombre
        cell.culturaImagen.image = UIImage(named: cultura.imagen)
        cell.culturaImagen.contentMode = .scaleAspectFill
        cell.culturaImagen.clipsToBounds = true
        return cell
    }

    // Al seleccionar una cultura, abre la pantalla de detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detalle = DetalleViewController()
        detalle.cultura = culturas[indexPath.row]
        navigationController?.pushViewController(detalle, animated: true)
    }
}

// PANTALLA 2: Detalle de la cultura (hecha por código)
class DetalleViewController: UIViewController {

    var cultura: Cultura!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Detalle"

        let imagen = UIImageView(image: UIImage(named: cultura.imagen))
        imagen.contentMode = .scaleAspectFill
        imagen.clipsToBounds = true
        imagen.layer.cornerRadius = 12

        let nombre = UILabel()
        nombre.text = cultura.nombre
        nombre.font = .boldSystemFont(ofSize: 26)

        let region = UILabel()
        region.text = "Región: " + cultura.region
        region.textColor = .secondaryLabel

        let descripcion = UILabel()
        descripcion.text = cultura.descripcion
        descripcion.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [imagen, nombre, region, descripcion])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imagen.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
}
