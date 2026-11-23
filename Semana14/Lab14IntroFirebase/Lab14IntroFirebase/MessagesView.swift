//
//  MessagesView.swift
//  Lab14IntroFirebase
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var db = DatabaseService()
    @State private var nuevoMensaje = ""
    var onSignOut: () -> Void

    private var miId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    var body: some View {
        VStack(spacing: 0) {
            // Encabezado
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    (Text(nombreApp).foregroundColor(.white)
                     + Text(".").foregroundColor(.morado))
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .shadow(color: .morado.opacity(0.8), radius: 10)

                    Text(Auth.auth().currentUser?.email ?? "")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.lavanda)
                }
                Spacer()
                Button {
                    onSignOut()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.moradoOscuro)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Rectangle()
                .fill(Color.morado.opacity(0.3))
                .frame(height: 1)

            // Lista de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if db.mensajes.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "sparkle")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.morado)
                                Text("Aún no hay mensajes.\n¡Escribe el primero!")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .foregroundColor(.lavanda)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 80)
                        }

                        ForEach(db.mensajes) { mensaje in
                            let esMio = (mensaje.autorId == miId)

                            BurbujaMensaje(mensaje: mensaje, esMio: esMio)
                                .id(mensaje.id)
                                // Extra: mantener presionado para eliminar (solo mensajes propios)
                                .contextMenu {
                                    if esMio {
                                        Button(role: .destructive) {
                                            db.eliminarMensaje(mensaje.id)
                                        } label: {
                                            Label("Eliminar", systemImage: "trash")
                                        }
                                    }
                                }
                        }
                    }
                    .padding(16)
                }
                .onChange(of: db.mensajes.count) {
                    if let ultimo = db.mensajes.last {
                        withAnimation {
                            proxy.scrollTo(ultimo.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Barra para escribir
            HStack(spacing: 10) {
                TextField("", text: $nuevoMensaje,
                          prompt: Text("escribe algo...").foregroundColor(.lavanda.opacity(0.7)))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color.tarjeta)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.morado.opacity(0.3), lineWidth: 1))
                    .submitLabel(.send)
                    .onSubmit { enviar() }

                Button {
                    enviar()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.morado)
                        .clipShape(Circle())
                        .shadow(color: .morado.opacity(0.6), radius: 8)
                }
                .disabled(nuevoMensaje.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(nuevoMensaje.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.fondo.ignoresSafeArea())
        .onAppear { db.escucharMensajes() }
        .onDisappear { db.dejarDeEscuchar() }
    }

    private func enviar() {
        db.enviarMensaje(nuevoMensaje)
        nuevoMensaje = ""
    }
}

struct BurbujaMensaje: View {
    let mensaje: Mensaje
    let esMio: Bool

    var body: some View {
        HStack {
            if esMio { Spacer(minLength: 50) }

            VStack(alignment: esMio ? .trailing : .leading, spacing: 4) {
                if !esMio {
                    Text(mensaje.autorEmail)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.morado)
                }
                Text(mensaje.texto)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                Text(hora)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(esMio ? .white.opacity(0.7) : .lavanda.opacity(0.7))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(esMio ? Color.morado : Color.tarjeta)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            if !esMio { Spacer(minLength: 50) }
        }
    }

    private var hora: String {
        guard mensaje.fecha > 0 else { return "" }
        let formato = DateFormatter()
        formato.dateFormat = "HH:mm"
        return formato.string(from: Date(timeIntervalSince1970: mensaje.fecha / 1000))
    }
}
