//
//  ViewController.swift
//  apple_lab05_Ejer2
//
//  Created by Naomi Solanch Veliz Pie on 23/09/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var capitalTextField: UITextField!
    
    @IBOutlet weak var tasaTextField: UITextField!
    
    @IBOutlet weak var plazoTextField: UITextField!
    
    @IBOutlet weak var cuotaLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuotaLabel.text = "Ingresa los datos del préstamo"
        totalLabel.text = ""
    }
    @IBAction func CalcularPrestamo(_ sender: Any) {
        // Obtener los valores ingresados
        let capital = Double(capitalTextField.text ?? "") ?? 0
        let tasaAnual = Double(tasaTextField.text ?? "") ?? -1
        let anios = Double(plazoTextField.text ?? "") ?? 0

        // Validar los datos
        if capital <= 0 || tasaAnual < 0 || anios <= 0 {
            cuotaLabel.text = "Por favor, ingresa valores válidos."
            totalLabel.text = ""
            return
        }

        // r = tasa mensual, n = número total de pagos
        let r = (tasaAnual / 100) / 12
        let n = anios * 12

        // Calcular la cuota mensual
        var cuota = 0.0
        if r == 0 {
            cuota = capital / n
        } else {
            let factor = pow(1 + r, n)
            cuota = capital * (r * factor) / (factor - 1)
        }

        // Monto total a pagar
        let total = cuota * n

        // Mostrar resultados
        cuotaLabel.text = "Cuota mensual: S/ \(String(format: "%.2f", cuota))"
        totalLabel.text = "Monto total: S/ \(String(format: "%.2f", total))"
    }
    }
    
    

