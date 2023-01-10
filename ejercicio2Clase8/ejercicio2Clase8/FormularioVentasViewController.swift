//
//  ViewController.swift
//  ejercicio2Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

public struct Venta {
    let nombre: String
    let valorVenta: Int
    let cantidadLibros: Int
    let medioDePago: UIImage
}

class FormularioVentasViewController: UIViewController {
    
    private enum EstadoFormulario {
        case nombreValido, valorVentaValido, cantidadLibrosValido, nombreVacio, valorVentaVacio, cantidadLibrosVacio, medioDePagoValido, medioDePagoVacio, medioDePagoAceptado
    }
    
    private struct Constantes {
        static let medioDePagoEnEfectivo = "efectivo"
        static let medioDePagoConTarjeta = "tarjeta"
        static let nombreDelSegueHaciaResumenDeVenta = "navegarHaciaResumenDeVenta"
        static let tituloDeLaAlerta = "Error"
        static let cuerpoDeLaAlerta = "Fue Imposible Enviar Informacion Al Servidor"
        static let nombreDelBottonDeLaAlerta = "Aceptar"
    }
    
    @IBOutlet weak var nombreCampoDeTexto: UITextField!
    @IBOutlet weak var valorVentaCampoDeTexto: UITextField!
    @IBOutlet weak var cantidadLibrosCampoDeTexto: UITextField!
    @IBOutlet weak var medioPagoCampoDeTexto: UITextField!
    
    private var nombre: String?
    private var valorVenta: String?
    private var cantidadLibros: String?
    private var medioDePago: String?
    private var resultado: String?
    private var imagenMedioDePago: UIImage?
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
        if let resumenVentaViewController = segue.destination as? ResumenVentaViewController {
            
            if let nombre = self.nombreCampoDeTexto?.text,
               let valorVenta = Int(valorVentaCampoDeTexto.text!),
               let cantidadLibros = Int(cantidadLibrosCampoDeTexto.text!),
               let imagenMedioDePago = UIImage(named: medioDePago ?? "")
            {
                resumenVentaViewController.venta = Venta(nombre: nombre, valorVenta: valorVenta, cantidadLibros: cantidadLibros, medioDePago: imagenMedioDePago)
            }
        }
    }
    
    @IBAction func accionDelBotonVender(_ sender: UIButton) {
        limpiarResultadosDeValidacion()
        extraerDatos()
        validarCamposDelFormulario()
        determinarColoresCamposDeFormulario()
        procesarCampos()
    }
    
    private func limpiarResultadosDeValidacion() {
        resultadosDeValidacion = []
    }
    
    private func extraerDatos() {
        nombre = nombreCampoDeTexto.text ?? ""
        valorVenta = valorVentaCampoDeTexto.text ?? ""
        cantidadLibros = cantidadLibrosCampoDeTexto.text ?? ""
        medioDePago = medioPagoCampoDeTexto.text ?? ""
    }
    
    private func validarCamposDelFormulario(){
        validarCampoNombre()
        validarCampoValorVenta()
        validarCampoCantidadLibros()
        validarCampoMedioDePago()
    }
    
    private func validarCampoNombre() {
        if let nombreSeguro = nombre {
            if nombreSeguro.isEmpty {
                resultadosDeValidacion.append(.nombreVacio)
            } else {
                resultadosDeValidacion.append(.nombreValido)
            }
        }
    }
    
    private func validarCampoValorVenta() {
        if let valorVentaSeguro = valorVenta {
            if valorVentaSeguro.isEmpty {
                resultadosDeValidacion.append(.valorVentaVacio)
            } else {
                resultadosDeValidacion.append(.valorVentaValido)
            }
        }
    }
    
    private func validarCampoCantidadLibros() {
        if let cantidadLibrosSeguro = cantidadLibros {
            if cantidadLibrosSeguro.isEmpty {
                resultadosDeValidacion.append(.cantidadLibrosVacio)
            } else {
                resultadosDeValidacion.append(.cantidadLibrosValido)
            }
        }
    }
    
    private func validarCampoMedioDePago() {
        if let medioDePagoSeguro = medioDePago {
            if medioDePagoSeguro.isEmpty {
                resultadosDeValidacion.append(.medioDePagoVacio)
            } else if medioDePago == Constantes.medioDePagoEnEfectivo {
                resultadosDeValidacion.append(.medioDePagoAceptado)
            } else if medioDePago == Constantes.medioDePagoConTarjeta {
                resultadosDeValidacion.append(.medioDePagoAceptado)
            } else {
                resultadosDeValidacion.append(.medioDePagoValido)
            }
        }
    }
    
    private func determinarColoresCamposDeFormulario() {
        determinarColorCampoNombre()
        determinarColorCampoValorVenta()
        determinarColorCampoCantidadDeLibros()
        determinarColorCampoMedioDePago()
    }
    
    private func determinarColorCampoNombre() {
        nombreCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.nombreValido) ? .systemBackground : .orange
    }
    
    private func determinarColorCampoValorVenta() {
        valorVentaCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.valorVentaValido) ? .systemBackground : .orange
    }
    
    private func determinarColorCampoCantidadDeLibros() {
        cantidadLibrosCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.cantidadLibrosValido) ? .systemBackground : .orange
    }
    
    private func determinarColorCampoMedioDePago() {
        if resultadosDeValidacion.contains(.medioDePagoValido){
            medioPagoCampoDeTexto.backgroundColor = .orange
        } else if resultadosDeValidacion.contains(.medioDePagoVacio){
            medioPagoCampoDeTexto.backgroundColor = .orange
        } else {
            medioPagoCampoDeTexto.backgroundColor = .systemBackground
        }
    }
    
    private func procesarCampos() {
        if let medioDePagoSeguro = medioDePago {
            let lasCredencialesSonValidas = validarMedioDePago(efectivo: medioDePagoSeguro, tarjeta: medioDePagoSeguro)
            procesarResultadoDeLaValidación(resultado: lasCredencialesSonValidas)
        }
    }
    
    private func validarMedioDePago(efectivo: String, tarjeta: String) -> Bool {
        let condicion = efectivo == Constantes.medioDePagoEnEfectivo || tarjeta == Constantes.medioDePagoConTarjeta
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
    
    private func tratarDeMostrarAlertaDeResulado(){
        let seObtuvoError = obtenerPosibleError()
        if seObtuvoError {
            presentarAlertaDeError()
        } else {
            navegarHaciaResumenDeVenta()
        }
    }
    
    private func obtenerPosibleError() -> Bool {
        let numeroAleatorio = generarNumeroAleatorio()
        switch (numeroAleatorio) {
        case 1...4 :
            return true
        default :
            return false
        }
    }
    
    func generarNumeroAleatorio() -> Int{
        return Int.random(in: 1 ... 7)
    }
    
    private func presentarAlertaDeError() {
        if let alertaSegura = alerta {
            present(alertaSegura, animated: true)
        }
    }
    
    private func navegarHaciaResumenDeVenta() {
        performSegue(withIdentifier: Constantes.nombreDelSegueHaciaResumenDeVenta, sender: self)
    }
}




