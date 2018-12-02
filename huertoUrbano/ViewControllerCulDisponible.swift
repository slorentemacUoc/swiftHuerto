//
//  ViewControllerCulDisponible.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 29/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerCulDisponible: UIViewController {

    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var nombreCult: UILabel!
    @IBOutlet weak var verano: UILabel!
    @IBOutlet weak var otono: UILabel!
    @IBOutlet weak var invierno: UILabel!
    @IBOutlet weak var primavera: UILabel!
    @IBOutlet weak var siembra: UILabel!
    @IBOutlet weak var cosecha: UILabel!
    @IBOutlet weak var verSiembra: UILabel!
    @IBOutlet weak var otoSiembra: UILabel!
    @IBOutlet weak var invSiembra: UILabel!
    @IBOutlet weak var priSiembra: UILabel!
    @IBOutlet weak var verCosecha: UILabel!
    @IBOutlet weak var otoCosecha: UILabel!
    @IBOutlet weak var invCosecha: UILabel!
    @IBOutlet weak var priCosecha: UILabel!
    @IBOutlet weak var tipoTierra: UILabel!
    @IBOutlet weak var espacio: UILabel!
    @IBOutlet weak var poda: UILabel!
    @IBOutlet weak var frecuenciaRiego: UILabel!
    @IBOutlet weak var abono: UILabel!
    @IBOutlet weak var sol: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var btCultivar: UIButton!
    
    var cultivo:Cultivo!
    var usuario:Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let idioma = Locale.current.languageCode
        let nombre = cultivo.nombre.split(separator: ";")
        let desc = cultivo.descripcion.split(separator: ";")
        let tTierra = cultivo.tipoTierra.split(separator: ";")
        let espPla = cultivo.espacioEntrePlantas.split(separator: ";")
        let podNec = cultivo.necesitaPoda.split(separator: ";")
        let fre = cultivo.frecuenciaRiego.split(separator: ";")
        let abo = cultivo.abonos.split(separator: ";")
        let solS = cultivo.solSombra.split(separator:";")
        temp.text = NSLocalizedString("Temperatura", comment: "") + String.init(cultivo.tempMin) + " - " + String.init(cultivo.tempMax)
        btCultivar.setTitle(NSLocalizedString("Cultivar", comment: ""), for: .normal)
        if(idioma == "en"){
            nombreCult.text = String.init(nombre[1])
            descripcion.text = String.init(desc[1])
            tipoTierra.text = NSLocalizedString("Tipo tierra", comment: "") + String.init(tTierra[1])
            espacio.text = NSLocalizedString("Espacio", comment: "") + String.init(espPla[1])
            poda.text = NSLocalizedString("Poda", comment: "") + String.init(podNec[1])
            frecuenciaRiego.text = NSLocalizedString("Frecuencia", comment: "") + String.init(fre[1])
            abono.text = NSLocalizedString("Abono", comment: "") + String.init(abo[1])
            sol.text = NSLocalizedString("Sol", comment: "") + String.init(solS[1])
        }else{
            nombreCult.text = String.init(nombre[0])
            descripcion.text = String.init(desc[0])
            tipoTierra.text = NSLocalizedString("Tipo tierra", comment: "") + String.init(tTierra[0])
            espacio.text = NSLocalizedString("Espacio", comment: "") + String.init(espPla[0])
            poda.text = NSLocalizedString("Poda", comment: "") + String.init(podNec[0])
            frecuenciaRiego.text = NSLocalizedString("Frecuencia", comment: "") + String.init(fre[0])
            abono.text = NSLocalizedString("Abono", comment: "") + String.init(abo[0])
            sol.text = NSLocalizedString("Sol", comment: "") + String.init(solS[0])
        }
        
        
        ajustaCampos()
        
        verSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "JL,AG,SP")
        otoSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "OC,NO,DC")
        invSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "EN,FE,MR")
        priSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "AB,MY,JN")
        
        verCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "JL,AG,SP")
        otoCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "OC,NO,DC")
        invCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "EN,FE,MR")
        priCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "AB,MY,JN")
        
    }
    
    @IBAction func cultivar(_ sender: Any) {
        let urlString = "https://huerto.herokuapp.com/detCultivoUsuario";
        //Creo la url
        let fecha = Date()
        let fechaString = fecha.description
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "fechaInicio=" + fechaString + "&cosecha=false&siembra=false&crecimiento=false&transplantar=false" + "&notificarRegar=false&notificarPoda=false&notificarTransplantar=false&descSiembra=" + self.cultivo.descrSiembra + "&descCosecha=" + self.cultivo.descCosechar + "&descTrasplantar=" + self.cultivo.descTrasplantar + "&descCrecimiento=" + self.cultivo.descCrecimiento
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo los usuarios que me devuelve el servicio web
                let detCultivoUsuario = result.object(forKey: "detCultivoUsuario") as! NSMutableDictionary
                let id = detCultivoUsuario["_id"] as! String
                let urlStringCulUsuario = "https://huerto.herokuapp.com/cultivoUsuario";
                let urlCulUsuario = URL(string: urlStringCulUsuario);
                var requestCulUsuario = URLRequest(url: urlCulUsuario!);
                requestCulUsuario.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                requestCulUsuario.httpMethod = "POST"
                let postString = "idCultivoUsuario=" + id + "&idUsuario=" + self.usuario.id + "&idCultivo=" + self.cultivo.id + "&nombre=" + self.cultivo.nombre + "&imgCultivo=" + self.cultivo.imgCultivo
                requestCulUsuario.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: requestCulUsuario){ (data, response, error) in
                    if(error == nil){
                        self.muestraAlert(titulo: "Informacion", texto: "Anadido")
                    }else{
                        self.muestraAlert(titulo: "Error", texto: "Error agregando")
                    }
                }
                task.resume()
            }else{
                self.muestraAlert(titulo: "Error", texto: "Error agregando")
            }
        }
        task.resume()
    }
    
    
    func muestraAlert(titulo:String, texto:String){
        DispatchQueue.main.async {
            //Si no ha devuelto ningún usuario es porque no esta dado de alta por lo tanto muestro un mensaje de error
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ajustaCampos(){
        
        verano.text = "  " + NSLocalizedString("Verano", comment: "")
        primavera.text = "  " + NSLocalizedString("Primavera", comment: "")
        otono.text = "  " + NSLocalizedString("Otono", comment: "")
        invierno.text = "  " + NSLocalizedString("Invierno", comment: "")
        siembra.text = "  " + NSLocalizedString("Siembra", comment: "")
        cosecha.text = "  " + NSLocalizedString("Cosecha", comment: "")
        
    }

    func devuelveCadena(tipo: String, cadenaBuscar:String) -> String{
        var cadena = ""
        var cadenaBuscada = cadenaBuscar.split(separator: ",")
        if(tipo == "siembra"){
            if(cultivo.mesesSiembra.contains(cadenaBuscada[0]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
            if(cultivo.mesesSiembra.contains(cadenaBuscada[1]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
            if(cultivo.mesesSiembra.contains(cadenaBuscada[2]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
        }else{
            if(cultivo.mesesCosecha.contains(cadenaBuscada[0]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
            if(cultivo.mesesCosecha.contains(cadenaBuscada[1]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
            if(cultivo.mesesCosecha.contains(cadenaBuscada[2]))
            {
                cadena = cadena + " X"
            }else{
                cadena = cadena + " _ "
            }
        }
        return cadena
    }


}
