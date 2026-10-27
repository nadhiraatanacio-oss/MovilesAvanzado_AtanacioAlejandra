//
//  ContentView.swift
//  CalculosLaborales
//
//  Created by Naomi Solanch Veliz Pie


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                // Grupo 1: beneficios del trabajador
                Section("Beneficios laborales") {
                    NavigationLink {
                            CTSView()
                    } label: {
                        Label("CTS", systemImage: "banknote")
                    }

                    NavigationLink {
                        Text("Gratificación – en construcción")
                    } label: {
                        Label("Gratificación", systemImage: "gift")
                    }

                    NavigationLink {
                        Text("Vacaciones – en construcción")
                    } label: {
                        Label("Vacaciones", systemImage: "sun.max")
                    }
                }

                // Grupo 2: sueldos
                Section("Remuneraciones") {
                    NavigationLink {
                        Text("Pago de instructores – en construcción")
                    } label: {
                        Label("Pago de instructores", systemImage: "person.crop.rectangle")
                    }
                }

                // Grupo 3: contabilidad (trabajo grupal del PDF)
                Section("Contabilidad") {
                    NavigationLink {
                        Text("Cuentas por cobrar y pagar – en construcción")
                    } label: {
                        Label("Cuentas por cobrar y pagar", systemImage: "chart.bar")
                    }
                }

                // Grupo 4: de dónde salen los números
                Section {
                    NavigationLink {
                        ParametrosView()
                    } label: {
                        Label("Parámetros legales", systemImage: "info.circle")
                    }
                } footer: {
                    Text("Valores legales vigentes en Perú a octubre de 2026.")
                }
            }
            .navigationTitle("Cálculos Laborales")
        }
    }
}

#Preview {
    ContentView()
}
