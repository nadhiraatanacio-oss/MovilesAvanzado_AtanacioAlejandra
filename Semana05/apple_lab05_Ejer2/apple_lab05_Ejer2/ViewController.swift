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
    }
