//
//  CalculoCuentas.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import Foundation

/// Resultado de un indicador: o tiene valor, o explica por qué no se pudo calcular.
enum ValorIndicador {
    case valor(Double, sustitucion: String)
    case noCalculable(String)

    /// El número, si se pudo calcular (para usarlo en otro indicador).
    var numero: Double? {
        if case .valor(let n, _) = self { return n }
        return nil
    }
}

enum Unidad {
    case soles, veces, dias, porcentaje
}

struct Indicador: Identifiable {
    let id = UUID()
    let nombre: String
    let formula: String
    let unidad: Unidad
    let resultado: ValorIndicador
}

enum ResultadoCuentas {
    case calculado(cobrar: [Indicador], pagar: [Indicador], ciclo: Indicador)
    case error(String)
}

/// Se lanza cuando un campo tiene texto o un número negativo.
struct DatoInvalido: Error {
    let campo: String
}

enum CalculoCuentas {

    static let dias = Parametros.diasPeriodo   // 360 según el PDF

    static func calcular(cxcInicial: String, cxcFinal: String, ventasCredito: String,
                         cxcVencidas: String, porcentajeIncobrable: String,
                         cxpInicial: String, cxpFinal: String, comprasCredito: String,
                         pasivosTotales: String) -> ResultadoCuentas {
        do {
            // 1. Leer los campos (vacío = nil, texto o negativo = error)
            let ci = try leer(cxcInicial, "Saldo inicial por cobrar")
            let cf = try leer(cxcFinal, "Saldo final por cobrar")
            let ventas = try leer(ventasCredito, "Ventas a crédito")
            let vencidas = try leer(cxcVencidas, "CxC vencidas")
            let pct = try leer(porcentajeIncobrable, "% de incobrabilidad")
            let pi = try leer(cxpInicial, "Saldo inicial por pagar")
            let pf = try leer(cxpFinal, "Saldo final por pagar")
            let compras = try leer(comprasCredito, "Compras a crédito")
            let pasivos = try leer(pasivosTotales, "Pasivos totales")

            // 2. Reglas que bloquean el cálculo
            if let vencidas, let cf, vencidas > cf {
                return .error("Las CxC vencidas no pueden ser mayores que el saldo final por cobrar.")
            }
            if let pf, let pasivos, pf > pasivos {
                return .error("Las CxP no pueden ser mayores que los pasivos totales.")
            }
            if let pct, pct > 100 {
                return .error("El % de incobrabilidad debe estar entre 0 y 100.")
            }

            // 3. Cuentas por cobrar
            let promCxC = promedio(ci, cf)
            let rotCxC = division(ventas, promCxC.numero, por: 1,
                                  faltaArriba: "Falta ventas a crédito.",
                                  faltaAbajo: "Faltan los saldos inicial y final.",
                                  abajoCero: "El promedio es 0: no hay cuentas por cobrar.")
            let edadCobro = division(promCxC.numero, ventas, por: dias,
                                     faltaArriba: "Faltan los saldos inicial y final.",
                                     faltaAbajo: "Falta ventas a crédito.",
                                     abajoCero: "Ventas a crédito = 0: no se puede dividir.")
            let morosidad = division(vencidas, cf, por: 100,
                                     faltaArriba: "Falta CxC vencidas.",
                                     faltaAbajo: "Falta el saldo final por cobrar.",
                                     abajoCero: "Saldo final = 0: no hay cuentas por cobrar.")
            let provision: ValorIndicador
            if let cf, let pct {
                provision = .valor(cf * pct / 100,
                                   sustitucion: "\(Formato.soles(cf)) × \(Formato.porcentaje(pct / 100))")
            } else {
                provision = .noCalculable("Falta el saldo final o el % de incobrabilidad.")
            }

            // 4. Cuentas por pagar
            let promCxP = promedio(pi, pf)
            let rotCxP = division(compras, promCxP.numero, por: 1,
                                  faltaArriba: "Falta compras a crédito.",
                                  faltaAbajo: "Faltan los saldos inicial y final.",
                                  abajoCero: "El promedio es 0: no hay cuentas por pagar.")
            let edadPago = division(promCxP.numero, compras, por: dias,
                                    faltaArriba: "Faltan los saldos inicial y final.",
                                    faltaAbajo: "Falta compras a crédito.",
                                    abajoCero: "Compras a crédito = 0: no se puede dividir.")
            let endeudamiento = division(pf, pasivos, por: 100,
                                         faltaArriba: "Falta el saldo final por pagar.",
                                         faltaAbajo: "Faltan los pasivos totales.",
                                         abajoCero: "Pasivos totales = 0: no se puede dividir.")

            // 5. Ciclo financiero
            let ciclo: ValorIndicador
            if let cobro = edadCobro.numero, let pago = edadPago.numero {
                ciclo = .valor(cobro - pago,
                               sustitucion: String(format: "%.2f − %.2f", cobro, pago))
            } else {
                ciclo = .noCalculable("Se necesitan la edad de cobro y la edad de pago.")
            }

            return .calculado(
                cobrar: [
                    Indicador(nombre: "CxC promedio", formula: "(inicial + final) ÷ 2", unidad: .soles, resultado: promCxC),
                    Indicador(nombre: "Rotación CxC", formula: "ventas a crédito ÷ promedio", unidad: .veces, resultado: rotCxC),
                    Indicador(nombre: "Edad promedio de cobro", formula: "promedio ÷ ventas × 360", unidad: .dias, resultado: edadCobro),
                    Indicador(nombre: "Índice de morosidad", formula: "vencidas ÷ saldo final × 100", unidad: .porcentaje, resultado: morosidad),
                    Indicador(nombre: "Provisión incobrables", formula: "saldo final × % incobrable", unidad: .soles, resultado: provision)
                ],
                pagar: [
                    Indicador(nombre: "CxP promedio", formula: "(inicial + final) ÷ 2", unidad: .soles, resultado: promCxP),
                    Indicador(nombre: "Rotación CxP", formula: "compras a crédito ÷ promedio", unidad: .veces, resultado: rotCxP),
                    Indicador(nombre: "Edad promedio de pago", formula: "promedio ÷ compras × 360", unidad: .dias, resultado: edadPago),
                    Indicador(nombre: "Endeudamiento proveedores", formula: "CxP final ÷ pasivos × 100", unidad: .porcentaje, resultado: endeudamiento)
                ],
                ciclo: Indicador(nombre: "Ciclo financiero", formula: "edad de cobro − edad de pago", unidad: .dias, resultado: ciclo)
            )
        } catch let error as DatoInvalido {
            return .error("“\(error.campo)” debe ser un número de 0 o más.")
        } catch {
            return .error("Hay un dato inválido.")
        }
    }

    // MARK: - Ayudantes

    /// Vacío → nil · número ≥ 0 → número · otra cosa → error
    static func leer(_ texto: String, _ campo: String) throws -> Double? {
        let limpio = texto.trimmingCharacters(in: .whitespaces)
        if limpio.isEmpty { return nil }
        guard let n = Formato.numero(limpio), n >= 0 else {
            throw DatoInvalido(campo: campo)
        }
        return n
    }

    static func promedio(_ inicial: Double?, _ final: Double?) -> ValorIndicador {
        guard let inicial, let final else {
            return .noCalculable("Faltan los saldos inicial y final.")
        }
        return .valor((inicial + final) / 2,
                      sustitucion: "(\(Formato.soles(inicial)) + \(Formato.soles(final))) ÷ 2")
    }

    /// arriba ÷ abajo × factor, revisando que no falten datos ni se divida entre 0.
    static func division(_ arriba: Double?, _ abajo: Double?, por factor: Double,
                         faltaArriba: String, faltaAbajo: String, abajoCero: String) -> ValorIndicador {
        guard let arriba else { return .noCalculable(faltaArriba) }
        guard let abajo else { return .noCalculable(faltaAbajo) }
        guard abajo != 0 else { return .noCalculable(abajoCero) }

        var texto = "\(Formato.soles(arriba)) ÷ \(Formato.soles(abajo))"
        if factor != 1 { texto += " × \(Int(factor))" }
        return .valor(arriba / abajo * factor, sustitucion: texto)
    }
}
