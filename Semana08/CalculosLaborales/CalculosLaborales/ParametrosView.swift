//
//  ParametrosView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import SwiftUI

/// Muestra los valores legales que usa la app y la norma de cada uno.
struct ParametrosView: View {
    var body: some View {
        List {
            Section("Valores de referencia 2026") {
                FilaParametro(nombre: "UIT", valor: Formato.soles(Parametros.uit),
                              norma: "D.S. 301-2025-EF")
                FilaParametro(nombre: "Remuneración Mínima Vital", valor: Formato.soles(Parametros.rmv),
                              norma: "D.S. 015-2026-TR (desde 01/10/2026)")
                FilaParametro(nombre: "Asignación familiar", valor: Formato.soles(Parametros.asignacionFamiliar),
                              norma: "10% de la RMV · Ley 25129")
            }

            Section("Pensiones (se descuentan al trabajador)") {
                FilaParametro(nombre: "ONP", valor: Formato.porcentaje(Parametros.tasaONP),
                              norma: "D.L. 19990")
                FilaParametro(nombre: "AFP – aporte obligatorio", valor: Formato.porcentaje(Parametros.tasaAFPAporte),
                              norma: "SBS · Sistema Privado de Pensiones")
                FilaParametro(nombre: "AFP – prima de seguro", valor: Formato.porcentaje(Parametros.tasaAFPSeguro),
                              norma: "SBS · devengue octubre 2026")
                FilaParametro(nombre: "AFP – total usado", valor: Formato.porcentaje(Parametros.tasaAFP),
                              norma: "Aporte + seguro (comisión sobre saldo)")
            }

            Section("Aportes del empleador") {
                FilaParametro(nombre: "EsSalud", valor: Formato.porcentaje(Parametros.tasaEssalud),
                              norma: "Ley 26790 · no se resta al trabajador")
            }

            Section("Gratificación – bonificación extraordinaria") {
                FilaParametro(nombre: "Con EsSalud", valor: Formato.porcentaje(Parametros.bonificacionEssalud),
                              norma: "Ley 30334")
                FilaParametro(nombre: "Con EPS", valor: Formato.porcentaje(Parametros.bonificacionEPS),
                              norma: "D.S. 012-2016-TR")
            }

            Section("Impuesto a la Renta de 5ta categoría") {
                FilaParametro(nombre: "Deducción (7 UIT)",
                              valor: Formato.soles(Parametros.deduccionEnUIT * Parametros.uit),
                              norma: "TUO Ley del Impuesto a la Renta, art. 46")

                // Una fila por cada tramo de la lista tramosIR
                ForEach(Parametros.tramosIR.indices, id: \.self) { i in
                    HStack {
                        Text(textoTramo(i))
                        Spacer()
                        Text(Formato.porcentaje(Parametros.tramosIR[i].tasa)).bold()
                    }
                }
            }

            Section("Pago de instructores") {
                FilaParametro(nombre: "Pago por hora", valor: Formato.soles(Parametros.pagoPorHora),
                              norma: "Dato del laboratorio")
                FilaParametro(nombre: "Máximo semanal", valor: "\(Parametros.horasMaximasSemana) horas",
                              norma: "Dato del laboratorio")
            }

            Section("Vacaciones por año completo") {
                FilaParametro(nombre: "Régimen general", valor: "\(Parametros.diasVacacionesGeneral) días",
                              norma: "D. Leg. 713")
                FilaParametro(nombre: "Micro y pequeña empresa", valor: "\(Parametros.diasVacacionesMype) días",
                              norma: "D.S. 013-2013-PRODUCE, art. 55")
            }

            Section {
                FilaParametro(nombre: "Días del periodo", valor: "\(Int(Parametros.diasPeriodo)) días",
                              norma: "Dato del laboratorio")
            } header: {
                Text("Contabilidad")
            } footer: {
                Text("Valores vigentes en Perú a octubre de 2026.")
            }
        }
        .navigationTitle("Parámetros legales")
    }

    /// Arma el texto de cada tramo: "Hasta 5 UIT", "Más de 5 hasta 20 UIT", "Más de 45 UIT"
    func textoTramo(_ i: Int) -> String {
        let hasta = Int(Parametros.tramosIR[i].hastaUIT)
        if i == 0 { return "Hasta \(hasta) UIT" }
        let desde = Int(Parametros.tramosIR[i - 1].hastaUIT)
        if i == Parametros.tramosIR.count - 1 { return "Más de \(desde) UIT" }
        return "Más de \(desde) hasta \(hasta) UIT"
    }
}

/// Una fila: nombre a la izquierda, valor a la derecha y la norma en gris debajo.
struct FilaParametro: View {
    let nombre: String
    let valor: String
    let norma: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(nombre)
                Spacer()
                Text(valor).bold()
            }
            Text(norma)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ParametrosView()
    }
}
