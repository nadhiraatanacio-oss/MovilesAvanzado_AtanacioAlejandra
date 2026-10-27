//
//  CTSView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import SwiftUI

struct CTSView: View {
    // Datos que ingresa el usuario
    @State private var regimen: Regimen = .general
    @State private var jornadaMinima = true
    @State private var sueldo = ""
    @State private var tieneAsignacion = false
    @State private var gratificacion = ""
    @State private var meses = 6
    @State private var dias = 0

    // Resultado (nil = todavía no se calculó)
    @State private var resultado: ResultadoCTS?
    // Con qué meses y días se hizo el último cálculo
    @State private var mesesUsados = 0
    @State private var diasUsados = 0

    var body: some View {
        Form {
            Section("Trabajador") {
                Picker("Régimen", selection: $regimen) {
                    ForEach(Regimen.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                Toggle("Jornada de 4 h diarias o más", isOn: $jornadaMinima)
            }

            Section {
                TextField("Sueldo al 31 de octubre (S/)", text: $sueldo)
                    .keyboardType(.decimalPad)
                Toggle("Asignación familiar (\(Formato.soles(Parametros.asignacionFamiliar)))",
                       isOn: $tieneAsignacion)
                TextField("Gratificación de julio recibida (S/)", text: $gratificacion)
                    .keyboardType(.decimalPad)
            } header: {
                Text("Remuneración")
            } footer: {
                Text("Si no recibió gratificación en julio, deja el campo vacío.")
            }

            Section("Tiempo trabajado (mayo – octubre)") {
                Stepper("Meses completos: \(meses)", value: $meses, in: 0...6)
                Stepper("Días adicionales: \(meses == 6 ? 0 : dias)", value: $dias, in: 0...29)
                    .disabled(meses == 6)
            }

            Section {
                Button("Calcular CTS") { calcular() }
                    .bold()
                    .frame(maxWidth: .infinity)
                Button("Limpiar", role: .destructive) { limpiar() }
                    .frame(maxWidth: .infinity)
            }

            if let resultado {
                seccionResultado(resultado)
            }
        }
        .navigationTitle("CTS")
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Resultado

    @ViewBuilder
    func seccionResultado(_ resultado: ResultadoCTS) -> some View {
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

        case .calculado(let d, let avisos):
            Section("1. Remuneración computable (RC)") {
                FilaMonto(nombre: "Sueldo", valor: d.sueldo)
                FilaMonto(nombre: "Asignación familiar", valor: d.asignacion)
                FilaMonto(nombre: "1/6 de gratificación (\(Formato.soles(d.gratificacion)) ÷ 6)",
                          valor: d.sextoGratificacion)
                FilaMonto(nombre: "RC", valor: d.remuneracionComputable, destacado: true)
            }

            Section("2. CTS por tiempo trabajado") {
                FilaMonto(nombre: "Meses: RC ÷ 12 × \(mesesUsados)", valor: d.porMeses)
                FilaMonto(nombre: "Días: RC ÷ 360 × \(diasUsados)", valor: d.porDias)
                if d.factorRegimen < 1 {
                    FilaMonto(nombre: "Régimen general", valor: d.ctsRegimenGeneral)
                    Text("Pequeña empresa: corresponde el 50%.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                HStack {
                    Text("CTS a depositar").font(.headline)
                    Spacer()
                    Text(Formato.soles(d.total))
                        .font(.title2).bold()
                        .foregroundStyle(.green)
                }
                ForEach(avisos, id: \.self) { aviso in
                    Label(aviso, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            } header: {
                Text("3. Resultado")
            } footer: {
                Text("Base legal: D.S. 001-97-TR (TUO de la Ley de CTS).")
            }
        }
    }

    // MARK: - Acciones

    func calcular() {
        resultado = CalculoCTS.calcular(regimen: regimen,
                                        jornadaMinima: jornadaMinima,
                                        sueldoTexto: sueldo,
                                        tieneAsignacion: tieneAsignacion,
                                        gratificacionTexto: gratificacion,
                                        meses: meses,
                                        dias: meses == 6 ? 0 : dias)
        mesesUsados = meses
        diasUsados = meses == 6 ? 0 : dias
    }

    func limpiar() {
        regimen = .general
        jornadaMinima = true
        sueldo = ""
        tieneAsignacion = false
        gratificacion = ""
        meses = 6
        dias = 0
        resultado = nil
    }
}

/// Fila reutilizable: concepto a la izquierda, monto en soles a la derecha.
struct FilaMonto: View {
    let nombre: String
    let valor: Double
    var destacado = false

    var body: some View {
        HStack {
            Text(nombre)
            Spacer()
            Text(Formato.soles(valor))
                .fontWeight(destacado ? .bold : .regular)
        }
    }
}

#Preview {
    NavigationStack {
        CTSView()
    }
}
