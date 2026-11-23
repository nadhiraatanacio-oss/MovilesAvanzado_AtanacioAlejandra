import SwiftUI

struct UserFormView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var name: String
    @State var email: String
    var isEditing: Bool
    var onSubmit: (String, String) -> Void

    // Validación del formulario
    private var esValido: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && email.contains("@") && email.contains(".")
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.fondoApp.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {
                    Text(isEditing ? "Editar Usuario" : "Nuevo Usuario")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.tinta)

                    CampoFormulario(etiqueta: "NOMBRE", placeholder: "Ej. Ana Torres", texto: $name)
                    CampoFormulario(etiqueta: "EMAIL", placeholder: "ana@correo.com", texto: $email, esEmail: true)

                    if !email.isEmpty && !email.contains("@") {
                        Text("Ingresa un email válido")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.coral)
                    }

                    Spacer()

                    Button {
                        onSubmit(name, email)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Guardar")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.tinta)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(!esValido)
                    .opacity(esValido ? 1 : 0.4)
                }
                .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.coral)
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

struct CampoFormulario: View {
    let etiqueta: String
    let placeholder: String
    @Binding var texto: String
    var esEmail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(etiqueta)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(1.5)
                .foregroundColor(.grisSuave)
            TextField(placeholder, text: $texto)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .keyboardType(esEmail ? .emailAddress : .default)
                .textInputAutocapitalization(esEmail ? .never : .words)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
