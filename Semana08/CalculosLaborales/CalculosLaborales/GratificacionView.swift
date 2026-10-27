//
//  GratificacionView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import SwiftUI

struct GratificacionView: View {
    // Datos que ingresa el usuario
    @State private var regimen: Regimen = .general
    @State private var mes: MesGratificacion = .julio
    @State private var sueldo = ""
    @State private var tieneAsignacion = false
    @State private var meses = 6
    @State private var seguro: Seguro = .essalud

    @State private var resultado: ResultadoGratificacion?

    var body: some View {
        Form {
            Section("Trabajador") {
                Picker("Régimen", selection: $regimen) {
                    ForEach(Regimen.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                Picker("Gratificación de", selection: $mes) {
                    ForEach(MesGratificacion.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                TextField("Sueldo mensual (S/)", text: $sueldo)
                    .keyboardType(.decimalPad)
                Toggle("Asignación familiar (\(Formato.soles(Parametros.asignacionFamiliar)))",
                       isOn: $tieneAsignacion)
                Stepper("Meses completos: \(meses)", value: $meses, in: 0...6)
                Picker("Seguro de salud", selection: $seguro) {
                    ForEach(Seguro.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Remuneración y tiempo")
            } footer: {
                Text("Semestre \(mes.semestre). Solo cuentan meses calendario completos.")
            }

            Section {
                Button("Calcular gratificación") { calcular() }
                    .bold()
                    .frame(maxWidth: .infinity)
                Button("Limpiar", role: .destructive) { limpiar() }
                    .frame(maxWidth: .infinity)
            }

            if let resultado {
                seccionResultado(resultado)
            }
        }
        .navigationTitle("Gratificación")
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Resultado

    @ViewBuilder
    func seccionResultado(_ resultado: ResultadoGratificacion) -> some View {
        switch resultado {
        case .error(let mensaje):
            Section {
                Label(mensaje, systemImage: "xmark.octagon.fill")
                    .foregroundStyle(.red)
            }

        case .noCorresponde(let mensaje):
            Section {
                Label(mensaje, systemImage: "info.circle.fill")
                    .foregroundStyle(.orange)
            }

        case .calculado(let d):
            Section("1. Remuneración computable (RC)") {
                FilaMonto(nombre: "Sueldo", valor: d.sueldo)
                FilaMonto(nombre: "Asignación familiar", valor: d.asignacion)
                FilaMonto(nombre: "RC", valor: d.remuneracionComputable, destacado: true)
            }

            Section("2. Gratificación de \(d.mes.rawValue.lowercased())") {
                FilaMonto(nombre: "RC ÷ 6 × \(d.meses) meses", valor: d.gratificacionGeneral)
                if d.factorRegimen < 1 {
                    FilaMonto(nombre: "Pequeña empresa (50%)", valor: d.gratificacion)
                }
                FilaMonto(nombre: "Bonificación \(d.seguro.rawValue) (\(Formato.porcentaje(d.seguro.tasaBonificacion)))",
                          valor: d.bonificacion)
            }

            Section {
                HStack {
                    Text("Total a recibir").font(.headline)
                    Spacer()
                    Text(Formato.soles(d.total))
                        .font(.title2).bold()
                        .foregroundStyle(.green)
                }
            } header: {
                Text("3. Resultado")
            } footer: {
                Text("Ley 27735 y Ley 30334. La gratificación no tiene descuento de AFP/ONP; sí está afecta al IR.")
            }
        }
    }

    // MARK: - Acciones

    func calcular() {
        resultado = CalculoGratificacion.calcular(regimen: regimen,
                                                  mes: mes,
                                                  sueldoTexto: sueldo,
                                                  tieneAsignacion: tieneAsignacion,
                                                  meses: meses,
                                                  seguro: seguro)
    }

    func limpiar() {
        regimen = .general
        mes = .julio
        sueldo = ""
        tieneAsignacion = false
        meses = 6
        seguro = .essalud
        resultado = nil
    }
}

#Preview {
    NavigationStack {
        GratificacionView()
    }
}
