//
//  DatabaseService.swift
//  Lab14IntroFirebase
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth

struct Mensaje: Identifiable {
    let id: String
    let texto: String
    let autorId: String
    let autorEmail: String
    let fecha: Double
}

class DatabaseService: ObservableObject {
    @Published var mensajes: [Mensaje] = []

    // 👉 URL de tu Realtime Database
    private let ref = Database.database(url: "https://app01-lab14-6ee17-default-rtdb.firebaseio.com")
        .reference()
        .child("mensajes")

    private var handle: DatabaseHandle?

    // Escucha los mensajes en tiempo real
    func escucharMensajes() {
        handle = ref.queryOrdered(byChild: "fecha").observe(.value) { [weak self] snapshot in
            var lista: [Mensaje] = []

            for case let hijo as DataSnapshot in snapshot.children {
                guard let datos = hijo.value as? [String: Any],
                      let texto = datos["texto"] as? String else { continue }

                lista.append(Mensaje(
                    id: hijo.key,
                    texto: texto,
                    autorId: datos["autorId"] as? String ?? "",
                    autorEmail: datos["autorEmail"] as? String ?? "anónimo",
                    fecha: datos["fecha"] as? Double ?? 0
                ))
            }

            DispatchQueue.main.async {
                self?.mensajes = lista
            }
        }
    }

    func dejarDeEscuchar() {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
    }

    // Guarda un mensaje nuevo en Firebase
    func enviarMensaje(_ texto: String) {
        guard let usuario = Auth.auth().currentUser else { return }
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !limpio.isEmpty else { return }

        let datos: [String: Any] = [
            "texto": limpio,
            "autorId": usuario.uid,
            "autorEmail": usuario.email ?? "anónimo",
            "fecha": ServerValue.timestamp()
        ]

        ref.childByAutoId().setValue(datos)
    }

    // Extra: elimina un mensaje propio
    func eliminarMensaje(_ id: String) {
        ref.child(id).removeValue()
    }
}
