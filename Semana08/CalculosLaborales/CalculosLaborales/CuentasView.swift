//
//  CuentasView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie on 27/10/26.
//

import SwiftUI

struct CuentasView: View {
    // Cuentas por cobrar
    @State private var cxcInicial = ""
    @State private var cxcFinal = ""
    @State private var ventasCredito = ""
    @State private var cxcVencidas = ""
    @State private var porcentaje = ""
    // Cuentas por pagar
    @State private var cxpInicial = ""
    @State private var cxpFinal = ""
    @State private var comprasCredito = ""
    @State private var pasivos = ""

    @State private var resultado: ResultadoCuentas?

    var body: some View {
        Form {
            Section {
                campo("Saldo inicial", $cxcInicial)
                campo("Saldo final", $cxcFinal)
                campo("Ventas a crédito", $ventasCredito)
                campo("CxC vencidas", $cxcVencidas)
                campo("% incobrabilidad", $porcentaje, ejemplo: "0 a 100")
            } header: {
                Text("Cuentas por cobrar (S/)")
            } footer: {
                Text("Saldo final = CxC totales. Si no tienes un dato, déjalo vacío.")
            }

            Section("Cuentas por pagar (S/)") {
                campo("Saldo inicial", $cxpInicial)
                campo("Saldo final", $cxpFinal)
                campo("Compras a crédito", $comprasCredito)
                campo("Pasivos totales", $pasivos)
            }

            Section {
                Button("Calcular indicadores") { calcular() }
                    .bold()
                    .frame(maxWidth: .infinity)
                Button("Limpiar", role: .destructive) { limpiar() }
                    .frame(maxWidth: .infinity)
            }

            if let resultado {
                seccionResultado(resultado)
            }
        }
        .navigationTitle("Cuentas")
        .scrollDismissesKeyboard(.interactively)
    }

    /// Una fila con el nombre a la izquierda y el campo a la derecha.
    func campo(_ titulo: String, _ texto: Binding<String>, ejemplo: String = "0.00") -> some View {
        HStack {
            Text(titulo)
            Spacer()
            TextField(ejemplo, text: texto)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 150)
        }
    }

    // MARK: - Resultado

    @ViewBuilder
    func seccionResultado(_ resultado: ResultadoCuentas) -> some View {
        switch resultado {
        case .error(let mensaje):
            Section {
                Label(mensaje, systemImage: "xmark.octagon.fill")
                    .foregroundStyle(.red)
            }

        case .calculado(let cobrar, let pagar, let ciclo):
            Section("Indicadores · por cobrar") {
                ForEach(cobrar) { indicador in
                    FilaIndicador(indicador: indicador)
                }
            }
            Section("Indicadores · por pagar") {
                ForEach(pagar) { indicador in
                    FilaIndicador(indicador: indicador)
                }
            }
            Section {
                FilaIndicador(indicador: ciclo)
                if let dias = ciclo.resultado.numero {
                    Text(interpretacion(dias))
                        .font(.callout)
                }
            } header: {
                Text("Comparación")
            } footer: {
                Text("Días del periodo: 360 (dato del laboratorio).")
            }
        }
    }

    func interpretacion(_ dias: Double) -> String {
        if dias < 0 { return "Negativo: los proveedores financian las operaciones." }
        if dias > 0 { return "Positivo: la empresa financia \(String(format: "%.2f", dias)) días con recursos propios." }
        return "Cobro y pago están equilibrados."
    }

    // MARK: - Acciones

    func calcular() {
        resultado = CalculoCuentas.calcular(cxcInicial: cxcInicial, cxcFinal: cxcFinal,
                                            ventasCredito: ventasCredito, cxcVencidas: cxcVencidas,
                                            porcentajeIncobrable: porcentaje,
                                            cxpInicial: cxpInicial, cxpFinal: cxpFinal,
                                            comprasCredito: comprasCredito, pasivosTotales: pasivos)
    }

    func limpiar() {
        cxcInicial = ""; cxcFinal = ""; ventasCredito = ""; cxcVencidas = ""; porcentaje = ""
        cxpInicial = ""; cxpFinal = ""; comprasCredito = ""; pasivos = ""
        resultado = nil
    }
}

/// Muestra un indicador: nombre, valor (o "—"), fórmula y sustitución (o el motivo).
struct FilaIndicador: View {
    let indicador: Indicador

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(indicador.nombre).bold()
                Spacer()
                switch indicador.resultado {
                case .valor(let numero, _):
                    Text(texto(numero)).bold().foregroundStyle(.green)
                case .noCalculable:
                    Text("—").foregroundStyle(.secondary)
                }
            }
            Text(indicador.formula)
                .font(.caption)
                .foregroundStyle(.secondary)
            switch indicador.resultado {
            case .valor(_, let sustitucion):
                Text(sustitucion).font(.caption)
            case .noCalculable(let motivo):
                Label(motivo, systemImage: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
    }

    /// Da formato según la unidad del indicador.
    func texto(_ n: Double) -> String {
        switch indicador.unidad {
        case .soles:      return Formato.soles(n)
        case .veces:      return String(format: "%.2f veces", n)
        case .dias:       return String(format: "%.2f días", n)
        case .porcentaje: return String(format: "%.2f%%", n)
        }
    }
}

#Preview {
    NavigationStack {
        CuentasView()
    }
}
