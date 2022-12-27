//
//  HomeViewController.swift
//  ejercicio1Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var correoDelUsuarioLabel: UILabel!
    @IBOutlet weak var nombreDelUsuarioLabel: UILabel!
    @IBOutlet weak var apellidoDelUsuarioLabel: UILabel!
    @IBOutlet weak var fotoDePerfilImageView: UIImageView!
    
    var usuario: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let seguroUsuario = self.usuario {
            let correo = seguroUsuario.correo
            let nombre = seguroUsuario.nombre
            let apellido = seguroUsuario.apellido
            let fotoPerfil = seguroUsuario.foto
            correoDelUsuarioLabel.text = correo
            nombreDelUsuarioLabel.text = nombre
            apellidoDelUsuarioLabel.text = apellido
            fotoDePerfilImageView.image = fotoPerfil
        }
    }
    
    @IBAction func cerrarSesionBotonAccion(_ sender: UIButton) {
        cerrarVistaHome()
    }
    
    func cerrarVistaHome() {
        dismiss(animated: true)
    }
}
