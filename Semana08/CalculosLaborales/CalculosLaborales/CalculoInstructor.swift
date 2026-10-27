//
//  CalculoInstructor.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Sistema de pensiones del trabajador.
enum SistemaPension: String, CaseIterable, Identifiable {
    case afp = "AFP"
    case onp = "ONP"

    var id: String { rawValue }

    /// AFP 11.37% (10% aporte + 1.37% seguro) · ONP 13%
    var tasa: Double {
        self == .afp ? Parametros.tasaAFP : Parametros.tasaONP
    }
}

/// Parte de la renta que cae en un tramo del IR.
struct TramoAplicado {
    let base: Double
    let tasa: Double
    var impuesto: Double { base * tasa }
}

/// Todos los montos del cálculo, para mostrarlos paso a paso.
struct DetalleInstructor {
    let horas: Int
    let sistema: SistemaPension
    let bruto: Double
    let pension: Double
    let proyeccionAnual: Double
    let deduccion: Double
    let rentaNeta: Double
    let tramos: [TramoAplicado]
    let irAnual: Double
    let irMensual: Double
    let neto: Double
    let essalud: Double
}

enum ResultadoInstructor {
    case calculado(DetalleInstructor)
    case error(String)
}

enum CalculoInstructor {

    /// 12 sueldos + 2 gratificaciones (proyección académica simplificada)
    static let sueldosAlAnio = 14.0

    /// Bruto = horas × 50 × 4
    /// Neto  = Bruto − pensión − IR mensual   (EsSalud lo paga el empleador)
    static func calcular(horasTexto: String, sistema: SistemaPension) -> ResultadoInstructor {

        // 1. Validar las horas (entero entre 1 y 23)
        let texto = horasTexto.trimmingCharacters(in: .whitespaces)
        guard let horas = Int(texto) else {
            return .error("Ingresa las horas semanales como número entero.")
        }
        guard horas >= 1 else {
            return .error("Las horas semanales deben ser al menos 1.")
        }
        guard horas <= Parametros.horasMaximasSemana else {
            return .error("El máximo es \(Parametros.horasMaximasSemana) horas semanales.")
        }

        // 2. Sueldo bruto y pensión
        let bruto = Double(horas) * Parametros.pagoPorHora * Parametros.semanasPorMes
        let pension = bruto * sistema.tasa

        // 3. Impuesto a la Renta de 5ta categoría
        let proyeccion = bruto * sueldosAlAnio
        let deduccion = Parametros.deduccionEnUIT * Parametros.uit      // 7 UIT = 38,500
        let rentaNeta = max(0, proyeccion - deduccion)
        let tramos = repartirEnTramos(rentaNeta)
        let irAnual = tramos.reduce(0) { suma, tramo in suma + tramo.impuesto }
        let irMensual = irAnual / 12

        // 4. Neto y aporte del empleador
        let neto = bruto - pension - irMensual
        let essalud = bruto * Parametros.tasaEssalud

        return .calculado(DetalleInstructor(horas: horas,
                                            sistema: sistema,
                                            bruto: bruto,
                                            pension: pension,
                                            proyeccionAnual: proyeccion,
                                            deduccion: deduccion,
                                            rentaNeta: rentaNeta,
                                            tramos: tramos,
                                            irAnual: irAnual,
                                            irMensual: irMensual,
                                            neto: neto,
                                            essalud: essalud))
    }

    /// Reparte la renta neta en los tramos 8%, 14%, 17%, 20%, 30%.
    /// Ejemplo: 25,900 cae completa en el primer tramo (hasta 5 UIT = 27,500).
    static func repartirEnTramos(_ renta: Double) -> [TramoAplicado] {
        var resultado: [TramoAplicado] = []
        var limiteAnterior = 0.0

        for tramo in Parametros.tramosIR {
            let limite = tramo.hastaUIT * Parametros.uit
            let base = min(renta, limite) - limiteAnterior
            if base <= 0 { break }
            resultado.append(TramoAplicado(base: base, tasa: tramo.tasa))
            limiteAnterior = limite
        }
        return resultado
    }
}
