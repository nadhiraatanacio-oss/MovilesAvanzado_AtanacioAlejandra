//
//  ResultadoViewController.swift
//  Laboratorio6_Calculadora
//
//  Created by Alejandra Atanacio on 30/09/26.
//

import UIKit

class ResultadoViewController: UIViewController {
    
    // recibe la venta calculada
    var pVenta: VentaModel = VentaModel()
    
    
    @IBOutlet weak var lblSubtotal: UILabel!
    
    @IBOutlet weak var lblIgv: UILabel!
    
    @IBOutlet weak var lblBase: UILabel!
    
    @IBOutlet weak var lblIntereses: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblCuota: UILabel!
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()

        // mostrar los valores en soles
        lblSubtotal.text = String(format: "S/. %.2f", pVenta.subtotal)
        lblIgv.text = String(format: "S/. %.2f", pVenta.igv)
        lblBase.text = String(format: "S/. %.2f", pVenta.base)
        lblIntereses.text = String(format: "S/. %.2f", pVenta.intereses)
        lblTotal.text = String(format: "S/. %.2f", pVenta.total)
        lblCuota.text = String(format: "S/. %.2f", pVenta.cuota)    }
    

 

}
