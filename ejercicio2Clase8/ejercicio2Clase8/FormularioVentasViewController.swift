//
//  ViewController.swift
//  ejercicio2Clase8
//
//  Created by sebas  on 20/12/22.
//

import UIKit

struct Venta {
    let nombre: String
    let valorVenta: Int
    let cantidadLibros: Int
    let medioDePago: UIImage
}

class FormularioVentasViewController: UIViewController {
    
    enum EstadoFormulario {
        case nombreValido, valorVentaValido, cantidadLibrosValido, nombreVacio, valorVentaVacio, cantidadLibrosVacio, medioDePagoValido, medioDePagoVacio, medioDePagoAceptado
    }
    
    struct Constantes {
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
    
    var nombre: String?
    var valorVenta: String?
    var cantidadLibros: String?
    var medioDePago: String?
    var resultado: String?
    
    var imagenMedioDePago: UIImage?
    
    var alerta: UIAlertController?
    var aceptarAcción: UIAlertAction?
    
    var resultadosDeValidacion: [EstadoFormulario] = []
    
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
        validacionDeCampos()
        determinarColoresCamposDeFormulario()
        procesarCampos()
        crearAlerta()
    }
    
    func limpiarResultadosDeValidacion() {
        resultadosDeValidacion = []
    }
    
    func extraerDatos() {
        nombre = nombreCampoDeTexto.text ?? ""
        valorVenta = valorVentaCampoDeTexto.text ?? ""
        cantidadLibros = cantidadLibrosCampoDeTexto.text ?? ""
        medioDePago = medioPagoCampoDeTexto.text ?? ""
    }
    
    func validarCampoNombre() {
        if let nombreSeguro = nombre {
            if nombreSeguro.isEmpty {
                resultadosDeValidacion.append(.nombreVacio)
            } else {
                resultadosDeValidacion.append(.nombreValido)
            }
        }
    }
    
    func validarCampoValorVenta() {
        if let valorVentaSeguro = valorVenta {
            if valorVentaSeguro.isEmpty {
                resultadosDeValidacion.append(.valorVentaVacio)
            } else {
                resultadosDeValidacion.append(.valorVentaValido)
            }
        }
    }
    
    func validarCampoCantidadLibros() {
        if let cantidadLibrosSeguro = cantidadLibros {
            if cantidadLibrosSeguro.isEmpty {
                resultadosDeValidacion.append(.cantidadLibrosVacio)
            } else {
                resultadosDeValidacion.append(.cantidadLibrosValido)
            }
        }
    }
    
    func validarCampoMedioDePago() {
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
    
    func validacionDeCampos(){
        validarCampoNombre()
        validarCampoValorVenta()
        validarCampoCantidadLibros()
        validarCampoMedioDePago()
    }
    
    func procesarCampos() {
        if let medioDePagoSeguro = medioDePago {
            let lasCredencialesSonValidas = validarMedioDePago(efectivo: medioDePagoSeguro, tarjeta: medioDePagoSeguro)
            procesoResultadoDeLaValidación(resultado: lasCredencialesSonValidas)
        }
    }
    
    func validarMedioDePago(efectivo: String, tarjeta: String) -> Bool {
        let condicion = efectivo == Constantes.medioDePagoEnEfectivo || tarjeta == Constantes.medioDePagoConTarjeta
        if  condicion {
            return true
        } else {
            return false
        }
    }
    
    func procesoResultadoDeLaValidación(resultado: Bool) {
        if resultado {
            aplicarProbabilidadDeErrorAlActulizarContador()
        }
    }
    
    func determinarColorCampoNombre() {
        nombreCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.nombreValido) ? .systemBackground : .orange
    }
    
    func determinarColorCampoValorVenta() {
        valorVentaCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.valorVentaValido) ? .systemBackground : .orange
    }
    
    func determinarColorCampoCantidadDeLibros() {
        cantidadLibrosCampoDeTexto.backgroundColor = resultadosDeValidacion.contains(.cantidadLibrosValido) ? .systemBackground : .orange
    }
    
    func determinarColorCampoMedioDePago() {
        if resultadosDeValidacion.contains(.medioDePagoValido){
            medioPagoCampoDeTexto.backgroundColor = .orange
        } else if resultadosDeValidacion.contains(.medioDePagoVacio){
            medioPagoCampoDeTexto.backgroundColor = .orange
        } else {
            medioPagoCampoDeTexto.backgroundColor = .systemBackground
        }
    }
    
    func determinarColoresCamposDeFormulario() {
        determinarColorCampoNombre()
        determinarColorCampoValorVenta()
        determinarColorCampoCantidadDeLibros()
        determinarColorCampoMedioDePago()
    }
    
    func navegarHaciaResumenDeVenta() {
        performSegue(withIdentifier: Constantes.nombreDelSegueHaciaResumenDeVenta, sender: self)
    }
    
    func generarNumeroAleatorio() -> Int{
        return Int.random(in: 1 ... 7)
    }
    
    func aplicarProbabilidadDeErrorAlActulizarContador(){
        let numeroAleatorio = generarNumeroAleatorio()
        switch (numeroAleatorio) {
        case 1 ... 4 :
            presentarAlerta()
        default :
            navegarHaciaResumenDeVenta()
        }
    }
    
    func crearAlerta() {
        alerta = UIAlertController(title: Constantes.tituloDeLaAlerta, message: Constantes.cuerpoDeLaAlerta , preferredStyle: .alert)
        aceptarAcción = UIAlertAction(title: Constantes.nombreDelBottonDeLaAlerta, style: .default)
        if let alertaSegura = alerta, let aceptarActionSegura = aceptarAcción  {
            alertaSegura.addAction(aceptarActionSegura)
        }
    }
    
    func presentarAlerta() {
        if let alertaSegura = alerta {
            present(alertaSegura, animated: true)
        }
    }
}




