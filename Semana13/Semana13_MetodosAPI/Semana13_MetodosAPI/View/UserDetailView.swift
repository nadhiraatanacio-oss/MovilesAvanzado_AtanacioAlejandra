import SwiftUI

// Pantalla de detalle: muestra toda la información del usuario que trae la API
struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Cabecera con avatar y nombre
                VStack(spacing: 10) {
                    Text(inicialesDe(user.name))
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 86, height: 86)
                        .background(colorAvatar(user.id))
                        .clipShape(RoundedRectangle(cornerRadius: 26))

                    Text(user.name)
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    if let username = user.username {
                        Text("@\(username)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.coral)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(Color.tinta)
                .clipShape(RoundedRectangle(cornerRadius: 28))

                TarjetaDatos(titulo: "CONTACTO", datos: [
                    Dato(icono: "envelope.fill", etiqueta: "Email", valor: user.email),
                    Dato(icono: "phone.fill", etiqueta: "Teléfono", valor: user.phone),
                    Dato(icono: "globe", etiqueta: "Sitio web", valor: user.website)
                ])

                TarjetaDatos(titulo: "DIRECCIÓN", datos: [
                    Dato(icono: "house.fill", etiqueta: "Calle",
                         valor: user.address.map { "\($0.street), \($0.suite)" }),
                    Dato(icono: "building.2.fill", etiqueta: "Ciudad", valor: user.address?.city),
                    Dato(icono: "number", etiqueta: "Código postal", valor: user.address?.zipcode)
                ])

                TarjetaDatos(titulo: "EMPRESA", datos: [
                    Dato(icono: "briefcase.fill", etiqueta: "Nombre", valor: user.company?.name),
                    Dato(icono: "quote.opening", etiqueta: "Lema", valor: user.company?.catchPhrase)
                ])

                if user.phone == nil && user.address == nil {
                    Text("Este usuario fue creado en la app, por eso solo tiene nombre y email.")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.grisSuave)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding(20)
        }
        .background(Color.fondoApp.ignoresSafeArea())
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.light)
    }
}

struct Dato {
    let icono: String
    let etiqueta: String
    let valor: String?
}

struct TarjetaDatos: View {
    let titulo: String
    let datos: [Dato]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(titulo)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.5)
                .foregroundColor(.grisSuave)

            ForEach(datos, id: \.etiqueta) { dato in
                HStack(spacing: 12) {
                    Image(systemName: dato.icono)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.coral)
                        .frame(width: 34, height: 34)
                        .background(Color.coral.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(dato.etiqueta)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.grisSuave)
                        Text(dato.valor ?? "Sin información")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(dato.valor == nil ? .grisSuave : .tinta)
                    }
                    Spacer()
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
