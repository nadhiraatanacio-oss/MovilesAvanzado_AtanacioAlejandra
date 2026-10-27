//
//  InstructorView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import SwiftUI

struct InstructorView: View {
    // Datos que ingresa el usuario
    @State private var horas = ""
    @State private var sistema: SistemaPension = .afp

    // Resultado (nil = todavía no se calculó)
    @State private var resultado: ResultadoInstructor?

    var body: some View {
        Form {
            Section {
                TextField("Horas semanales (1 a \(Parametros.horasMaximasSemana))", text: $horas)
                    .keyboardType(.numberPad)
                Picker("Sistema de pensiones", selection: $sistema) {
                    ForEach(SistemaPension.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Datos del instructor")
            } footer: {
                Text("Pago por hora: \(Formato.soles(Parametros.pagoPorHora)) · Mes = 4 semanas")
            }

            Section {
                Button("Calcular pago") { calcular() }
                    .bold()
                    .frame(maxWidth: .infinity)
                Button("Limpiar", role: .destructive) { limpiar() }
                    .frame(maxWidth: .infinity)
            }

            if let resultado {
                seccionResultado(resultado)
            }
        }
        .navigationTitle("Pago de instructores")
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Resultado

    @ViewBuilder
    func seccionResultado(_ resultado: ResultadoInstructor) -> some View {
        switch resultado {
        case .error(let mensaje):
            Section {
                Label(mensaje, systemImage: "xmark.octagon.fill")
                    .foregroundStyle(.red)
            }

        case .calculado(let d):
            Section("1. Sueldo bruto") {
                FilaMonto(nombre: "\(d.horas) h × S/ 50 × 4 semanas", valor: d.bruto, destacado: true)
            }

            Section {
                FilaMonto(nombre: "Proyección anual (bruto × 14)", valor: d.proyeccionAnual)
                FilaMonto(nombre: "(−) Deducción 7 UIT", valor: d.deduccion)
                FilaMonto(nombre: "Renta neta anual", valor: d.rentaNeta)
                if d.tramos.isEmpty {
                    Text("No supera las 7 UIT: no paga impuesto.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                ForEach(d.tramos.indices, id: \.self) { i in
                    let tramo = d.tramos[i]
                    FilaMonto(nombre: "\(Formato.soles(tramo.base)) × \(Formato.porcentaje(tramo.tasa))",
                              valor: tramo.impuesto)
                }
                FilaMonto(nombre: "IR anual", valor: d.irAnual)
                FilaMonto(nombre: "IR mensual (anual ÷ 12)", valor: d.irMensual, destacado: true)
            } header: {
                Text("2. Impuesto a la Renta 5ta categoría")
            } footer: {
                Text("Cálculo académico: proyección de 14 sueldos (12 + 2 gratificaciones) e IR anual ÷ 12.")
            }

            Section("3. Descuentos al trabajador") {
                FilaMonto(nombre: "\(d.sistema.rawValue) (\(Formato.porcentaje(d.sistema.tasa)))", valor: d.pension)
                FilaMonto(nombre: "IR 5ta categoría", valor: d.irMensual)
                FilaMonto(nombre: "Total descuentos", valor: d.pension + d.irMensual, destacado: true)
            }

            Section {
                HStack {
                    Text("Sueldo neto").font(.headline)
                    Spacer()
                    Text(Formato.soles(d.neto))
                        .font(.title2).bold()
                        .foregroundStyle(.green)
                }
                FilaMonto(nombre: "EsSalud 9% (lo paga el empleador)", valor: d.essalud)
                    .foregroundStyle(.secondary)
            } header: {
                Text("4. Resultado")
            } footer: {
                Text("Neto = bruto − pensión − IR. EsSalud no se descuenta al trabajador (Ley 26790).")
            }
        }
    }

    // MARK: - Acciones

    func calcular() {
        resultado = CalculoInstructor.calcular(horasTexto: horas, sistema: sistema)
    }

    func limpiar() {
        horas = ""
        sistema = .afp
        resultado = nil
    }
}

#Preview {
    NavigationStack {
        InstructorView()
    }
}
