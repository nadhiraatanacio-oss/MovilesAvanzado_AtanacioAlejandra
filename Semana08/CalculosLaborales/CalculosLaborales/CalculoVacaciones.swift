//
//  CalculoVacaciones.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Los 4 escenarios de vacaciones.
enum EscenarioVacaciones: String, CaseIterable, Identifiable {
    case completas = "Completas"
    case fraccionadas = "Fraccionadas"
    case truncas = "Truncas"
    case reduccion = "Reducción 30 a 15"

    var id: String { rawValue }
}

/// Jornada semanal: define el récord vacacional mínimo (D. Leg. 713, art. 10).
enum JornadaSemanal: String, CaseIterable, Identifiable {
    case cinco = "5 días"
    case seis = "6 días"

    var id: String { rawValue }

    /// Días efectivos mínimos trabajados en el año
    var recordMinimo: Double {
        self == .cinco ? 210 : 260
    }
}

struct DetalleVacaciones {
    let escenario: EscenarioVacaciones
    let regimen: Regimen
    let diasDerecho: Int           // 30 general · 15 MYPE
    let sueldo: Double
    let asignacion: Double
    let remuneracionComputable: Double
    let meses: Int
    let dias: Int
    let monto: Double              // lo que se paga en el escenario
    let totalMes: Double?          // solo en reducción: RC + compensación
}

enum ResultadoVacaciones {
    case calculado(DetalleVacaciones)
    case noCorresponde(String)
    case error(String)
}

enum CalculoVacaciones {

    static func calcular(regimen: Regimen,
                         escenario: EscenarioVacaciones,
                         sueldoTexto: String,
                         tieneAsignacion: Bool,
                         jornada: JornadaSemanal,
                         recordTexto: String,
                         meses: Int,
                         dias: Int) -> ResultadoVacaciones {

        // 1. Validar el sueldo
        guard let sueldo = Formato.numero(sueldoTexto) else {
            return .error("Ingresa un sueldo válido (solo números).")
        }
        guard sueldo > 0 else {
            return .error("El sueldo debe ser mayor que 0.")
        }

        // 2. Reglas según el escenario
        if escenario == .truncas {
            guard (0...11).contains(meses) else {
                return .error("Los meses deben estar entre 0 y 11.")
            }
            guard (0...29).contains(dias) else {
                return .error("Los días deben estar entre 0 y 29.")
            }
            if meses == 0 {
                return .noCorresponde("Las vacaciones truncas requieren al menos un mes de servicios.")
            }
        } else if regimen != .general {
            // MYPE: solo vacaciones completas de 15 días
            if escenario != .completas {
                return .noCorresponde("El fraccionamiento y la reducción 30→15 son solo del régimen general.")
            }
        } else {
            // Régimen general: se exige récord vacacional
            guard let record = Formato.numero(recordTexto) else {
                return .error("Ingresa los días efectivos trabajados en el año.")
            }
            if record < jornada.recordMinimo {
                return .noCorresponde("No cumple el récord vacacional (mínimo \(Int(jornada.recordMinimo)) días efectivos).")
            }
        }

        // 3. Calcular
        let diasDerecho = (regimen == .general) ? Parametros.diasVacacionesGeneral : Parametros.diasVacacionesMype
        let asignacion = tieneAsignacion ? Parametros.asignacionFamiliar : 0
        let rc = sueldo + asignacion

        var monto = 0.0
        var totalMes: Double? = nil

        switch escenario {
        case .completas, .fraccionadas:
            // Fraccionar NO cambia el monto
            monto = rc / 30 * Double(diasDerecho)
        case .truncas:
            // MYPE: proporcional a 15 días (supuesto académico)
            monto = (rc / 12 * Double(meses) + rc / 360 * Double(dias)) * Double(diasDerecho) / 30
        case .reduccion:
            // Compensación por los 15 días que trabaja en vez de descansar
            monto = rc / 30 * 15
            totalMes = rc + monto
        }

        return .calculado(DetalleVacaciones(escenario: escenario,
                                            regimen: regimen,
                                            diasDerecho: diasDerecho,
                                            sueldo: sueldo,
                                            asignacion: asignacion,
                                            remuneracionComputable: rc,
                                            meses: meses,
                                            dias: dias,
                                            monto: monto,
                                            totalMes: totalMes))
    }
}
