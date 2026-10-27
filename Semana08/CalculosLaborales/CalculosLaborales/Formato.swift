//
//  Formato.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Funciones para mostrar y leer números de forma ordenada en toda la app.
enum Formato {

    /// Muestra un monto en soles con 2 decimales.
    /// Ejemplo: 1286.5 → "S/ 1,286.50"
    static func soles(_ valor: Double) -> String {
        let texto = valor.formatted(
            .number
                .precision(.fractionLength(2))
                .rounded(rule: .toNearestOrAwayFromZero)
                .locale(Locale(identifier: "en_US"))
        )
        return "S/ " + texto
    }

    /// Muestra una tasa como porcentaje.
    /// Ejemplo: 0.1137 → "11.37%"
    static func porcentaje(_ tasa: Double) -> String {
        let texto = (tasa * 100).formatted(
            .number
                .precision(.fractionLength(0...2))
                .locale(Locale(identifier: "en_US"))
        )
        return texto + "%"
    }

    /// Convierte lo que escribe el usuario en número.
    /// Acepta "1500.50" o "1500,50". Si no es un número válido, devuelve nil.
    static func numero(_ texto: String) -> Double? {
        let limpio = texto
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(limpio)
    }
}
