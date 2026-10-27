//
//  CalculoGratificacion.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Mes en que se paga la gratificación.
enum MesGratificacion: String, CaseIterable, Identifiable {
    case julio = "Julio"
    case diciembre = "Diciembre"

    var id: String { rawValue }

    /// Semestre que se está pagando
    var semestre: String {
        self == .julio ? "enero – junio" : "julio – diciembre"
    }
}

/// Seguro de salud del trabajador (define la bonificación extraordinaria).
enum Seguro: String, CaseIterable, Identifiable {
    case essalud = "EsSalud"
    case eps = "EPS"

    var id: String { rawValue }

    /// EsSalud 9% · EPS 6.75%  (Ley 30334)
    var tasaBonificacion: Double {
        self == .essalud ? Parametros.bonificacionEssalud : Parametros.bonificacionEPS
    }
}

struct DetalleGratificacion {
    let mes: MesGratificacion
    let sueldo: Double
    let asignacion: Double
    let remuneracionComputable: Double
    let meses: Int
    let gratificacionGeneral: Double
    let factorRegimen: Double          // 1.0 general · 0.5 pequeña empresa
    let seguro: Seguro

    var gratificacion: Double { gratificacionGeneral * factorRegimen }
    var bonificacion: Double { gratificacion * seguro.tasaBonificacion }
    var total: Double { gratificacion + bonificacion }
}

enum ResultadoGratificacion {
    case calculado(DetalleGratificacion)
    case noCorresponde(String)
    case error(String)
}

enum CalculoGratificacion {

    /// RC = sueldo + asignación familiar
    /// Gratificación = RC ÷ 6 × meses completos   (pequeña empresa: × 50%)
    /// Bonificación = gratificación × 9% (EsSalud) o 6.75% (EPS)
    static func calcular(regimen: Regimen,
                         mes: MesGratificacion,
                         sueldoTexto: String,
                         tieneAsignacion: Bool,
                         meses: Int,
                         seguro: Seguro) -> ResultadoGratificacion {

        // 1. Régimen sin gratificación
        if regimen == .micro {
            return .noCorresponde("La microempresa inscrita en el REMYPE no otorga gratificación.")
        }

        // 2. Validar datos
        guard let sueldo = Formato.numero(sueldoTexto) else {
            return .error("Ingresa un sueldo válido (solo números).")
        }
        guard sueldo > 0 else {
            return .error("El sueldo debe ser mayor que 0.")
        }
        guard (0...6).contains(meses) else {
            return .error("Los meses deben estar entre 0 y 6.")
        }
        if meses == 0 {
            return .noCorresponde("Se requiere al menos un mes calendario completo en el semestre.")
        }

        // 3. Calcular
        let asignacion = tieneAsignacion ? Parametros.asignacionFamiliar : 0
        let rc = sueldo + asignacion
        let general = rc / 6 * Double(meses)
        let factor = (regimen == .pequena) ? 0.5 : 1.0

        return .calculado(DetalleGratificacion(mes: mes,
                                               sueldo: sueldo,
                                               asignacion: asignacion,
                                               remuneracionComputable: rc,
                                               meses: meses,
                                               gratificacionGeneral: general,
                                               factorRegimen: factor,
                                               seguro: seguro))
    }
}
