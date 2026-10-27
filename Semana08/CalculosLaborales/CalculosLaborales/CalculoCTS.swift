//
//  CalculoCTS.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Régimen laboral de la empresa. Lo usarán CTS, gratificación y vacaciones.
enum Regimen: String, CaseIterable, Identifiable {
    case general = "General"
    case pequena = "Pequeña empresa"
    case micro = "Microempresa"

    var id: String { rawValue }
}

/// Todos los montos que salen del cálculo, para mostrarlos paso a paso.
struct DetalleCTS {
    let sueldo: Double
    let asignacion: Double
    let gratificacion: Double
    let sextoGratificacion: Double
    let remuneracionComputable: Double
    let porMeses: Double
    let porDias: Double
    let factorRegimen: Double          // 1.0 = general, 0.5 = pequeña empresa

    var ctsRegimenGeneral: Double { porMeses + porDias }
    var total: Double { ctsRegimenGeneral * factorRegimen }
}

/// Los 3 resultados posibles al calcular.
enum ResultadoCTS {
    case calculado(DetalleCTS, avisos: [String])
    case noCorresponde(String)
    case error(String)
}

enum CalculoCTS {

    /// CTS noviembre 2026 (semestre mayo–octubre).
    /// RC = sueldo + asignación familiar + gratificación / 6
    /// CTS = RC / 12 × meses + RC / 360 × días   (pequeña empresa: × 50%)
    static func calcular(regimen: Regimen,
                         jornadaMinima: Bool,
                         sueldoTexto: String,
                         tieneAsignacion: Bool,
                         gratificacionTexto: String,
                         meses: Int,
                         dias: Int) -> ResultadoCTS {

        // 1. Casos donde la ley no da CTS
        if regimen == .micro {
            return .noCorresponde("Los trabajadores de microempresa inscrita en el REMYPE no tienen CTS.")
        }
        if !jornadaMinima {
            return .noCorresponde("La CTS solo corresponde con una jornada de al menos 4 horas diarias.")
        }

        // 2. Validar el sueldo
        guard let sueldo = Formato.numero(sueldoTexto) else {
            return .error("Ingresa un sueldo válido (solo números).")
        }
        guard sueldo > 0 else {
            return .error("El sueldo debe ser mayor que 0.")
        }

        // 3. Validar la gratificación (vacía = 0, con aviso)
        var avisos: [String] = []
        var gratificacion = 0.0
        if gratificacionTexto.trimmingCharacters(in: .whitespaces).isEmpty {
            avisos.append("No se ingresó gratificación: se consideró S/ 0.00.")
        } else {
            guard let valor = Formato.numero(gratificacionTexto), valor >= 0 else {
                return .error("Ingresa una gratificación válida (0 o más).")
            }
            gratificacion = valor
        }

        // 4. Validar meses y días
        guard (0...6).contains(meses) else {
            return .error("Los meses deben estar entre 0 y 6.")
        }
        guard (0...29).contains(dias) else {
            return .error("Los días deben estar entre 0 y 29.")
        }
        if meses == 6 && dias > 0 {
            return .error("Con 6 meses el semestre está completo: los días deben ser 0.")
        }
        if meses == 0 {
            return .noCorresponde("No genera CTS: se requiere al menos un mes completo de labores.")
        }

        // 5. Calcular
        let asignacion = tieneAsignacion ? Parametros.asignacionFamiliar : 0
        let sexto = gratificacion / 6
        let rc = sueldo + asignacion + sexto
        let porMeses = rc / 12 * Double(meses)
        let porDias = rc / 360 * Double(dias)
        let factor = (regimen == .pequena) ? 0.5 : 1.0

        if sueldo < Parametros.rmv {
            avisos.append("El sueldo es menor a la RMV (\(Formato.soles(Parametros.rmv))).")
        }

        let detalle = DetalleCTS(sueldo: sueldo,
                                 asignacion: asignacion,
                                 gratificacion: gratificacion,
                                 sextoGratificacion: sexto,
                                 remuneracionComputable: rc,
                                 porMeses: porMeses,
                                 porDias: porDias,
                                 factorRegimen: factor)
        return .calculado(detalle, avisos: avisos)
    }
}
