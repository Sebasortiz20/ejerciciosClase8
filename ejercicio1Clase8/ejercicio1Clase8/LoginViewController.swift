//
//  ViewController.swift
//  ejercicio1Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

struct Usuario {
    let correo: String
    let nombre: String
    let apellido: String
    let foto: UIImage
}

class LoginViewController: UIViewController {
    
    enum EstadoFormulario {
        case correoValido, contraseñaValida, correoVacio, contraseñaVacia
    }
    
    struct Constantes {
        static let correoRegistrado = "sebas@hotmail.co"
        static let contraseñaRegistrada = "123"
        static let nombreDelSegueHaciaHome = "navegarHaciaHome"
        static let tituloDeLaAlerta = "Error"
        static let cuerpoDeLaAlerta = "Fue Imposible Enviar Informacion Al Servidor"
        static let nombreDelBottonDeLaAlerta = "Aceptar"
        static let nombreDeLaFotoDePerfil = "fotoDePerfil"
        static let nombreDelUsuario = "Sebastian"
        static let apellidoDelUsuario = "Ortiz"
    }
    
    @IBOutlet weak var correoCampoDeTexto: UITextField!
    @IBOutlet weak var contraseñaCampoDeTexto: UITextField!
    
    var correo: String?
    var contraseña: String?
    var alerta: UIAlertController?
    var aceptarAction: UIAlertAction?
    
    var resultadosDeValidacion: [EstadoFormulario] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeViewController = segue.destination as? HomeViewController {
            if let correo = self.correoCampoDeTexto?.text,
               let fotoDePerfilSegura = UIImage(named: Constantes.nombreDeLaFotoDePerfil)
            {
                homeViewController.usuario = Usuario(correo: correo, nombre: Constantes.nombreDelUsuario, apellido: Constantes.apellidoDelUsuario, foto: fotoDePerfilSegura)
            }
        }
    }
    
    @IBAction func accionDelBotonIngresar(_ sender: UIButton) {
        limpiarResultadosDeValidacion()
        extraerDatos()
        validacioDeCampoCorreoYContraseña()
        determinarColoresCamposDeFormulario()
        procesarCredenciales()
        crearAlerta()
    }
    
    func limpiarResultadosDeValidacion() {
        resultadosDeValidacion = []
    }
    
    func extraerDatos() {
        correo = correoCampoDeTexto.text ?? ""
        contraseña = contraseñaCampoDeTexto.text ?? ""
    }
    
    func validarCampoCorreo() {
        if let correoSeguro = correo {
            if correoSeguro.isEmpty {
                resultadosDeValidacion.append(.correoVacio)
            } else {
                resultadosDeValidacion.append(.correoValido)
            }
        }
    }
    
    func validarCampoContraseña() {
        if let contraseñaSegura = contraseña {
            if contraseñaSegura.isEmpty {
                resultadosDeValidacion.append(.contraseñaVacia)
            } else {
                resultadosDeValidacion.append(.contraseñaValida)
            }
        }
    }
    
    func validacioDeCampoCorreoYContraseña(){
        validarCampoCorreo()
        validarCampoContraseña()
    }
    
    func procesarCredenciales() {
        if let correoSeguro = correo, let contraseñaSegura = contraseña {
            let lasCredencialesSonValidas = validarCredenciales(correo: correoSeguro, contraseña: contraseñaSegura)
            procesarResultadoDeLaValidación(resultado: lasCredencialesSonValidas)
        }
    }
    
    func validarCredenciales(correo: String, contraseña: String) -> Bool {
        let condicion = correo == Constantes.correoRegistrado && contraseña == Constantes.contraseñaRegistrada
        if  condicion {
            return true
        } else {
            return false
        }
    }
    
    func procesarResultadoDeLaValidación(resultado: Bool) {
        if resultado {
            aplicarProbalidadDeErroraAlActulizarContador()
        }
    }
    
    func determinarColorCampoDeCorreo() {
        correoCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.correoValido) ? .systemBackground : .red
    }
    
    func determinarColorCampoDeContraseña() {
        contraseñaCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.contraseñaValida) ? .systemBackground : .red
    }
    
    func determinarColoresCamposDeFormulario() {
        determinarColorCampoDeCorreo()
        determinarColorCampoDeContraseña()
    }
    
    func navegarHaciaHomeViewController() {
        performSegue(withIdentifier: Constantes.nombreDelSegueHaciaHome, sender: self)
    }
    
    func generarNumeroAleatorio() -> Int{
        return Int.random(in: 1 ... 5)
    }
    
    func aplicarProbalidadDeErroraAlActulizarContador(){
        let numeroAleatorio = generarNumeroAleatorio()
        switch (numeroAleatorio) {
        case 1 ... 3 :
            presentarAlerta()
        default :
            navegarHaciaHomeViewController()
        }
    }
    
    func crearAlerta() {
        alerta = UIAlertController(title: Constantes.tituloDeLaAlerta, message: Constantes.cuerpoDeLaAlerta , preferredStyle: .alert)
        aceptarAction = UIAlertAction(title: Constantes.nombreDelBottonDeLaAlerta, style: .default)
        if let alertaSegura = alerta, let aceptarActionSegura = aceptarAction  {
            alertaSegura.addAction(aceptarActionSegura)
        }
    }
    
    func presentarAlerta() {
        if let alertaSegura = alerta {
            present(alertaSegura, animated: true)
        }
    }
}
