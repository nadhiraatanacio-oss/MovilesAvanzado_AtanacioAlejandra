import Foundation

/// Los 4 escenarios de vacaciones.
enum EscenarioVacaciones: String, CaseIterable, Identifiable {
    case completas = "Completas"
    case fraccionadas = "Fraccionadas"
    case truncas = "Truncas"
    case reduccion = "Reducción"

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
    let diasCompensados: Int       // reducción: 15 general · 8 MYPE
    let diasDescanso: Int          // reducción: 15 general · 7 MYPE
    let monto: Double              // lo que se paga en el escenario
    let totalMes: Double?          // solo reducción en régimen general: RC + compensación
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
        } else {
            // El fraccionamiento (D. Leg. 1405) no aplica a regímenes especiales
            if regimen != .general && escenario == .fraccionadas {
                return .noCorresponde("El fraccionamiento (D. Leg. 1405) es solo del régimen general.")
            }
            // Récord vacacional: general y MYPE (Ley MYPE art. 48 → art. 10 D. Leg. 713)
            guard let record = Formato.numero(recordTexto) else {
                return .error("Ingresa los días efectivos trabajados en el año.")
            }
            if record < jornada.recordMinimo {
                return .noCorresponde("No cumple el récord vacacional (mínimo \(Int(jornada.recordMinimo)) días efectivos).")
            }
        }

        // 3. Calcular
        let esGeneral = (regimen == .general)
        let diasDerecho = esGeneral ? Parametros.diasVacacionesGeneral : Parametros.diasVacacionesMype
        let asignacion = tieneAsignacion ? Parametros.asignacionFamiliar : 0
        let rc = sueldo + asignacion

        // Reducción: general 30→15 (compensa 15) · MYPE 15→7 (compensa 8, D.S. 008-2008-TR art. 37)
        let diasCompensados = esGeneral ? 15 : 8
        let diasDescanso = esGeneral ? 15 : 7

        var monto = 0.0
        var totalMes: Double? = nil

        switch escenario {
        case .completas, .fraccionadas:
            // Fraccionar NO cambia el monto
            monto = rc / 30 * Double(diasDerecho)
        case .truncas:
            // MYPE: proporcional a 15 días (art. 48 Ley MYPE + art. 22 D. Leg. 713)
            monto = (rc / 12 * Double(meses) + rc / 360 * Double(dias)) * Double(diasDerecho) / 30
        case .reduccion:
            // Compensación por los días que trabaja en vez de descansar
            monto = rc / 30 * Double(diasCompensados)
            if esGeneral { totalMes = rc + monto }
        }

        return .calculado(DetalleVacaciones(escenario: escenario,
                                            regimen: regimen,
                                            diasDerecho: diasDerecho,
                                            sueldo: sueldo,
                                            asignacion: asignacion,
                                            remuneracionComputable: rc,
                                            meses: meses,
                                            dias: dias,
                                            diasCompensados: diasCompensados,
                                            diasDescanso: diasDescanso,
                                            monto: monto,
                                            totalMes: totalMes))
    }
}
