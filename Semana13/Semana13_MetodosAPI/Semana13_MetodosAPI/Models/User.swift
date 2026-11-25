// Utilizando los métodos POST - PUT - DELETE
import Foundation

struct User: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var email: String

    // Datos extra que trae la API (opcionales: los usuarios creados en la app no los tienen)
    var username: String? = nil
    var phone: String? = nil
    var website: String? = nil
    var address: Address? = nil
    var company: Company? = nil
}

struct Address: Codable, Hashable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
}

struct Company: Codable, Hashable {
    var name: String
    var catchPhrase: String
}
