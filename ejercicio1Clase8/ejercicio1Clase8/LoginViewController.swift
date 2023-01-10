//
//  ViewController.swift
//  ejercicio1Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

public struct Usuario {
    let correo: String
    let nombre: String
    let apellido: String
    let foto: UIImage
}

class LoginViewController: UIViewController {
    
    private enum EstadoFormulario {
        case correoValido, contraseñaValida, correoVacio, contraseñaVacia
    }
    
    private struct Constantes {
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
    
    private var correo: String?
    private var contraseña: String?
    private var alerta: UIAlertController?
    private var accionAceptar: UIAlertAction?
    private var resultadosDeValidacion: [EstadoFormulario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearAlerta()
    }
    
    private func crearAlerta() {
        alerta = UIAlertController(title: Constantes.tituloDeLaAlerta, message: Constantes.cuerpoDeLaAlerta , preferredStyle: .alert)
        accionAceptar = UIAlertAction(title: Constantes.nombreDelBottonDeLaAlerta, style: .default)
        if let alertaSegura = alerta, let aceptarActionSegura = accionAceptar  {
            alertaSegura.addAction(aceptarActionSegura)
        }
    }
    
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
        validarCampoDeCorreoYContraseña()
        determinarColoresCamposDeFormulario()
        procesarCredenciales()
    }
    
    private func limpiarResultadosDeValidacion() {
        resultadosDeValidacion = []
    }
    
    private func extraerDatos() {
        correo = correoCampoDeTexto.text ?? ""
        contraseña = contraseñaCampoDeTexto.text ?? ""
    }
    
    private func validarCampoDeCorreoYContraseña(){
        validarCampoCorreo()
        validarCampoContraseña()
    }
    
    private func validarCampoCorreo() {
        if let correoSeguro = correo {
            if correoSeguro.isEmpty {
                resultadosDeValidacion.append(.correoVacio)
            } else {
                resultadosDeValidacion.append(.correoValido)
            }
        }
    }
    
    private func validarCampoContraseña() {
        if let contraseñaSegura = contraseña {
            if contraseñaSegura.isEmpty {
                resultadosDeValidacion.append(.contraseñaVacia)
            } else {
                resultadosDeValidacion.append(.contraseñaValida)
            }
        }
    }
    
    private func determinarColoresCamposDeFormulario() {
        determinarColorCampoDeCorreo()
        determinarColorCampoDeContraseña()
    }
    
    private func determinarColorCampoDeCorreo() {
        correoCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.correoValido) ? .systemBackground : .red
    }
    
    private func determinarColorCampoDeContraseña() {
        contraseñaCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.contraseñaValida) ? .systemBackground : .red
    }
    
    private func procesarCredenciales() {
        if let correoSeguro = correo, let contraseñaSegura = contraseña {
            let lasCredencialesSonValidas = validarCredenciales(correo: correoSeguro, contraseña: contraseñaSegura)
            procesarResultadoDeLaValidación(resultado: lasCredencialesSonValidas)
        }
    }
    
    private func validarCredenciales(correo: String, contraseña: String) -> Bool {
        let condicion = correo == Constantes.correoRegistrado && contraseña == Constantes.contraseñaRegistrada
        if  condicion {
            return true
        } else {
            return false
        }
    }
    
    private func procesarResultadoDeLaValidación(resultado: Bool) {
        if resultado {
            tratarDeMostrarAlertaDeResulado()
        }
    }
    
    private func tratarDeMostrarAlertaDeResulado() {
        let seObtuvoError = obtenerPosibleError()
        if seObtuvoError {
            presentarAlertaDeError()
        } else {
            navegarHaciaHomeViewController()
        }
    }
    
    private func obtenerPosibleError() -> Bool {
        let numeroAleatorio = generarNumeroAleatorio()
        switch (numeroAleatorio) {
        case 1...3 :
            return true
        default :
            return false
        }
    }
    
    private func generarNumeroAleatorio() -> Int{
        return Int.random(in: 1 ... 5)
    }
    
    private func presentarAlertaDeError() {
        if let alertaSegura = alerta {
            present(alertaSegura, animated: true)
        }
    }
    
    private func navegarHaciaHomeViewController() {
        performSegue(withIdentifier: Constantes.nombreDelSegueHaciaHome, sender: self)
    }
}
