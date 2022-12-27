//
//  ResumenVentaViewController.swift
//  ejercicio2Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

class ResumenVentaViewController: UIViewController {
    
    @IBOutlet weak var medioDePagoImagen: UIImageView!
    @IBOutlet weak var tituloDelLibroVendido: UILabel!
    @IBOutlet weak var totalDeDineroRecaudadoLabel: UILabel!
    
    var venta: Venta?
    var imagenTipoDeVenta: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ventaSegura = self.venta {
            let nombre = ventaSegura.nombre
            let totalDeDineroRecaudado = (ventaSegura.cantidadLibros * ventaSegura.valorVenta)
            let medioDePago = ventaSegura.medioDePago
            tituloDelLibroVendido.text = nombre
            totalDeDineroRecaudadoLabel.text = String(totalDeDineroRecaudado)
            medioDePagoImagen.image = medioDePago
        }
    }
}
