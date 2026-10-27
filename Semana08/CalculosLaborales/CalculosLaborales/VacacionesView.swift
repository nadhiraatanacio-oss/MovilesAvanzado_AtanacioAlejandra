import SwiftUI

struct VacacionesView: View {
    // Datos que ingresa el usuario
    @State private var regimen: Regimen = .general
    @State private var escenario: EscenarioVacaciones = .completas
    @State private var sueldo = ""
    @State private var tieneAsignacion = false
    @State private var jornada: JornadaSemanal = .cinco
    @State private var record = ""
    @State private var meses = 1
    @State private var dias = 0

    @State private var resultado: ResultadoVacaciones?

    var body: some View {
        Form {
            Section("Trabajador") {
                Picker("Régimen", selection: $regimen) {
                    ForEach(Regimen.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                Picker("Escenario", selection: $escenario) {
                    ForEach(EscenarioVacaciones.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                TextField("Sueldo mensual (S/)", text: $sueldo)
                    .keyboardType(.decimalPad)
                Toggle("Asignación familiar (\(Formato.soles(Parametros.asignacionFamiliar)))",
                       isOn: $tieneAsignacion)
            }

            // Solo se piden los datos que el escenario necesita
            if escenario == .truncas {
                Section("Tiempo de servicios (truncas)") {
                    Stepper("Meses completos: \(meses)", value: $meses, in: 0...11)
                    Stepper("Días adicionales: \(dias)", value: $dias, in: 0...29)
                }
            } else {
                Section {
                    Picker("Jornada semanal", selection: $jornada) {
                        ForEach(JornadaSemanal.allCases) { opcion in
                            Text(opcion.rawValue).tag(opcion)
                        }
                    }
                    .pickerStyle(.segmented)
                    TextField("Días efectivos trabajados en el año", text: $record)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Récord vacacional")
                } footer: {
                    Text("Mínimo \(Int(jornada.recordMinimo)) días efectivos (D. Leg. 713 art. 10; en MYPE por la Ley MYPE art. 48).")
                }
            }

            Section {
                Button("Calcular vacaciones") { calcular() }
                    .bold()
                    .frame(maxWidth: .infinity)
                Button("Limpiar", role: .destructive) { limpiar() }
                    .frame(maxWidth: .infinity)
            }

            if let resultado {
                seccionResultado(resultado)
            }

            Section {
                Text("• **MYPE:** 15 días son todo su derecho anual. Puede reducir a 7 por acuerdo escrito y se le compensan 8 días.")
                Text("• **Fraccionar (general):** toma 15 ahora y 15 después. Sin pago extra.")
                Text("• **Reducir 30→15 (general):** descansa 15, trabaja 15 y se le pagan 15 días adicionales.")
            } header: {
                Text("Los casos de «15 días»")
            } footer: {
                Text("Ley MYPE art. 48 · D.S. 008-2008-TR art. 37 · D. Leg. 713 arts. 17 y 19 · D.S. 002-2019-TR.")
            }
            .font(.callout)
        }
        .navigationTitle("Vacaciones")
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Resultado

    @ViewBuilder
    func seccionResultado(_ resultado: ResultadoVacaciones) -> some View {
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

            Section("2. Cálculo · \(d.escenario.rawValue)") {
                switch d.escenario {
                case .completas, .fraccionadas:
                    FilaMonto(nombre: "RC ÷ 30 × \(d.diasDerecho) días", valor: d.monto)
                    if d.escenario == .fraccionadas {
                        Text("Mismo monto que completas: fraccionar no genera pago extra.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                case .truncas:
                    FilaMonto(nombre: "(RC ÷ 12 × \(d.meses) + RC ÷ 360 × \(d.dias)) × \(d.diasDerecho)/30",
                              valor: d.monto)
                    if d.regimen != .general {
                        Text("MYPE: proporcional a 15 días (Ley MYPE art. 48 + D. Leg. 713 art. 22).")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                case .reduccion:
                    Text("Descansa \(d.diasDescanso) días y trabaja \(d.diasCompensados).")
                        .font(.callout)
                    FilaMonto(nombre: "Compensación: RC ÷ 30 × \(d.diasCompensados)", valor: d.monto)
                    if let total = d.totalMes {
                        FilaMonto(nombre: "Total del mes (sueldo y medio)", valor: total)
                    }
                }
            }

            Section {
                HStack {
                    Text(d.escenario == .reduccion ? "Pago adicional" : "Monto a pagar")
                        .font(.headline)
                    Spacer()
                    Text(Formato.soles(d.monto))
                        .font(.title2).bold()
                        .foregroundStyle(.green)
                }
            } header: {
                Text("3. Resultado")
            } footer: {
                Text(d.escenario == .reduccion && d.regimen != .general
                     ? "MYPE: reducción de 15 a 7 días por acuerdo escrito (D.S. 008-2008-TR, art. 37)."
                     : "\(d.regimen.rawValue): \(d.diasDerecho) días de vacaciones por año completo.")
            }
        }
    }

    // MARK: - Acciones

    func calcular() {
        resultado = CalculoVacaciones.calcular(regimen: regimen,
                                               escenario: escenario,
                                               sueldoTexto: sueldo,
                                               tieneAsignacion: tieneAsignacion,
                                               jornada: jornada,
                                               recordTexto: record,
                                               meses: meses,
                                               dias: dias)
    }

    func limpiar() {
        regimen = .general
        escenario = .completas
        sueldo = ""
        tieneAsignacion = false
        jornada = .cinco
        record = ""
        meses = 1
        dias = 0
        resultado = nil
    }
}

#Preview {
    NavigationStack {
        VacacionesView()
    }
}
