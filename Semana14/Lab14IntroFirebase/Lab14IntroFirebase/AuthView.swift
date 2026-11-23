//
//  AuthView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

// Cambia aquí el nombre de tu app
let nombreApp = "Lab 14 Registro"

// MARK: - Paleta negro / blanco / morado
extension Color {
    static let fondo = Color(red: 0.04, green: 0.03, blue: 0.06)
    static let tarjeta = Color(red: 0.10, green: 0.08, blue: 0.15)
    static let morado = Color(red: 0.58, green: 0.33, blue: 0.98)
    static let moradoOscuro = Color(red: 0.32, green: 0.16, blue: 0.60)
    static let lavanda = Color(red: 0.70, green: 0.66, blue: 0.80)
    static let dorado = Color(red: 1.0, green: 0.72, blue: 0.22)
}

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var authStateListener: AuthStateDidChangeListenerHandle?

    var body: some View {
        Group {
            if isSignedIn {
                // Actividad 2: chat en tiempo real
                MessagesView(onSignOut: signOut)
            } else {
                NavigationView {
                    ZStack {
                        Color.fondo.ignoresSafeArea()

                        ScrollView {
                            VStack(alignment: .leading, spacing: 36) {
                                encabezado
                                formulario
                            }
                            .padding(.horizontal, 26)
                            .padding(.top, 30)
                            .padding(.bottom, 40)
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
        }
        .preferredColorScheme(.dark)
        .alert("Aviso", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            checkAuthState()
        }
        .onDisappear {
            if let handle = authStateListener {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
        .onChange(of: isSignedIn) {
            if !isSignedIn {
                email = ""
                password = ""
            }
        }
    }

    // MARK: - Partes de la vista

    private var encabezado: some View {
        ZStack(alignment: .topTrailing) {
            // Triángulos decorativos de fondo
            TriangulosFondo()
                .frame(height: 200)

            VStack(alignment: .leading, spacing: 14) {
                Text("LAB 14 · FIREBASE")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(1.5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(Capsule().stroke(Color.morado.opacity(0.6), lineWidth: 1))

                (Text(nombreApp).foregroundColor(.white)
                 + Text(".").foregroundColor(.morado))
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .padding(.trailing, 70)
                    .shadow(color: .morado.opacity(0.9), radius: 14)

                Text("Conecta, escribe y conversa\nen tiempo real.")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.lavanda)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            StickerEstrella()
                .offset(x: 6, y: 34)
        }
    }

    private var formulario: some View {
        VStack(alignment: .leading, spacing: 18) {
            CampoMorado(icono: "at", placeholder: "tu correo", texto: $email)
            CampoMorado(icono: "lock", placeholder: "tu clave", texto: $password, esClave: true)

            // Extra: recuperar contraseña
            HStack {
                Spacer()
                Button("¿Olvidaste tu clave?") {
                    resetPassword()
                }
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.morado)
            }

            VStack(spacing: 12) {
                Button("Entrar") {
                    signIn()
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Crear cuenta") {
                    signUp()
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.top, 10)
        }
    }

    // MARK: - Authentication Functions

    func checkAuthState() {
        authStateListener = Auth.auth().addStateDidChangeListener { _, user in
            isSignedIn = (user != nil)
        }
    }

    func signIn() {
        guard validarCampos() else { return }
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                mostrarAviso(error.localizedDescription)
                return
            }
            isSignedIn = true
        }
    }

    func signUp() {
        guard validarCampos() else { return }
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                mostrarAviso(error.localizedDescription)
                return
            }
            mostrarAviso("Cuenta creada. ¡Bienvenida!")
            isSignedIn = true
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
        } catch {
            mostrarAviso(error.localizedDescription)
        }
    }

    // Extra: envía un correo para restablecer la contraseña
    func resetPassword() {
        guard !email.isEmpty else {
            mostrarAviso("Escribe tu correo primero.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                mostrarAviso(error.localizedDescription)
                return
            }
            mostrarAviso("Te enviamos un correo para cambiar tu clave.")
        }
    }

    private func validarCampos() -> Bool {
        if email.isEmpty || password.isEmpty {
            mostrarAviso("Completa tu correo y tu clave.")
            return false
        }
        if password.count < 6 {
            mostrarAviso("La clave debe tener al menos 6 caracteres.")
            return false
        }
        return true
    }

    private func mostrarAviso(_ mensaje: String) {
        alertMessage = mensaje
        showAlert = true
    }
}

// MARK: - Componentes de diseño

struct Triangulo: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct TriangulosFondo: View {
    var body: some View {
        ZStack {
            Triangulo()
                .fill(Color.moradoOscuro.opacity(0.55))
                .frame(width: 120, height: 105)
                .rotationEffect(.degrees(-12))
                .offset(x: 120, y: -30)

            Triangulo()
                .fill(Color.morado.opacity(0.35))
                .frame(width: 60, height: 52)
                .rotationEffect(.degrees(180))
                .offset(x: 40, y: 70)

            Triangulo()
                .fill(Color.moradoOscuro.opacity(0.4))
                .frame(width: 34, height: 30)
                .rotationEffect(.degrees(20))
                .offset(x: -40, y: -60)

            Triangulo()
                .stroke(Color.morado.opacity(0.5), lineWidth: 1.5)
                .frame(width: 80, height: 70)
                .rotationEffect(.degrees(8))
                .offset(x: 150, y: 80)
        }
    }
}

struct StickerEstrella: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 74, height: 74)
                .shadow(color: .morado.opacity(0.8), radius: 12)
            Image(systemName: "sparkle")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.morado)
        }
        .rotationEffect(.degrees(-10))
    }
}

struct CampoMorado: View {
    let icono: String
    let placeholder: String
    @Binding var texto: String
    var esClave = false

    @FocusState private var enfocado: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icono)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(enfocado ? .morado : .lavanda)
                .frame(width: 22)

            Group {
                if esClave {
                    SecureField("", text: $texto,
                                prompt: Text(placeholder).foregroundColor(.lavanda.opacity(0.7)))
                } else {
                    TextField("", text: $texto,
                              prompt: Text(placeholder).foregroundColor(.lavanda.opacity(0.7)))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .focused($enfocado)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(Color.tarjeta)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(enfocado ? Color.morado : Color.white.opacity(0.08), lineWidth: 1.5)
        )
        .shadow(color: enfocado ? .morado.opacity(0.5) : .clear, radius: 10)
        .animation(.easeOut(duration: 0.2), value: enfocado)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(Color.morado)
            .clipShape(Capsule())
            .shadow(color: .morado.opacity(0.6), radius: 12, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1.5))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

struct SignOutButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.moradoOscuro)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
}

#Preview {
    AuthView()
}
