//
//  Parametros.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Valores legales y académicos usados en toda la app.
/// Si una norma cambia, solo se modifica este archivo.
enum Parametros {

    // MARK: - Valores de referencia
    static let uit: Double = 5_500       // D.S. 301-2025-EF (año 2026)
    static let rmv: Double = 1_230       // D.S. 015-2026-TR (desde 01/10/2026)
    static let asignacionFamiliar: Double = rmv * 0.10   // 10% de la RMV = S/ 123

    // MARK: - Pensiones (se descuentan al trabajador)
    static let tasaONP: Double = 0.13
    static let tasaAFPAporte: Double = 0.10
    static let tasaAFPSeguro: Double = 0.0137
    static var tasaAFP: Double { tasaAFPAporte + tasaAFPSeguro }   // 11.37%

    // MARK: - Aportes del empleador (NO se descuentan al trabajador)
    static let tasaEssalud: Double = 0.09

    // MARK: - Bonificación extraordinaria de gratificación (Ley 30334)
    static let bonificacionEssalud: Double = 0.09
    static let bonificacionEPS: Double = 0.0675

    // MARK: - Impuesto a la Renta de 5ta categoría
    static let deduccionEnUIT: Double = 7          // 7 UIT = S/ 38,500
    static let tramosIR: [(hastaUIT: Double, tasa: Double)] = [
        (5, 0.08),
        (20, 0.14),
        (35, 0.17),
        (45, 0.20),
        (.infinity, 0.30)
    ]

    // MARK: - Pago de instructores (datos del laboratorio)
    static let pagoPorHora: Double = 50
    static let horasMaximasSemana = 23
    static let semanasPorMes: Double = 4

    // MARK: - Vacaciones (días por año completo)
    static let diasVacacionesGeneral = 30
    static let diasVacacionesMype = 15

    // MARK: - Contabilidad (días del periodo según el PDF)
    static let diasPeriodo: Double = 360
}
