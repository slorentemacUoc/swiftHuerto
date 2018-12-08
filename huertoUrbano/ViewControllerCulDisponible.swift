//
//  ViewControllerCulDisponible.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 29/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerCulDisponible: UIViewController {

    //Variables de pantalla
    @IBOutlet weak var descripcion: UILabel!
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
    //Objetos de la pantalla anterior
    var cultivo:Cultivo!
    var usuario:Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //En función del idioma del sistema todos los campos de la pantalla deben visualizarse en ingles o en español para eso el servicio web los devuelve siguiendo el esquema español;ingles 
        let idioma = Locale.current.languageCode
        let nombre = cultivo.nombre.split(separator: ";")
        let desc = cultivo.descripcion.split(separator: ";")
        let tTierra = cultivo.tipoTierra.split(separator: ";")
        let espPla = cultivo.espacioEntrePlantas.split(separator: ";")
        let podNec = cultivo.necesitaPoda.split(separator: ";")
        let fre = cultivo.frecuenciaRiego.split(separator: ";")
        let abo = cultivo.abonos.split(separator: ";")
        let solS = cultivo.solSombra.split(separator:";")
        //Carga de strings en funcion del idioma
        temp.text = NSLocalizedString("Temperatura", comment: "") + String.init(cultivo.tempMin) + " - " + String.init(cultivo.tempMax)
        btCultivar.setTitle(NSLocalizedString("Cultivar", comment: ""), for: .normal)
        if(idioma == "en"){
            self.navigationItem.title = String.init(nombre[1])
            descripcion.text = String.init(desc[1])
            tipoTierra.text = NSLocalizedString("Tipo tierra", comment: "") + String.init(tTierra[1])
            espacio.text = NSLocalizedString("Espacio", comment: "") + String.init(espPla[1])
            poda.text = NSLocalizedString("Poda", comment: "") + String.init(podNec[1])
            frecuenciaRiego.text = NSLocalizedString("Frecuencia", comment: "") + String.init(fre[1])
            abono.text = NSLocalizedString("Abono", comment: "") + String.init(abo[1])
            sol.text = NSLocalizedString("Sol", comment: "") + String.init(solS[1])
        }else{
            self.navigationItem.title = String.init(nombre[0])
            descripcion.text = String.init(desc[0])
            tipoTierra.text = NSLocalizedString("Tipo tierra", comment: "") + String.init(tTierra[0])
            espacio.text = NSLocalizedString("Espacio", comment: "") + String.init(espPla[0])
            poda.text = NSLocalizedString("Poda", comment: "") + String.init(podNec[0])
            frecuenciaRiego.text = NSLocalizedString("Frecuencia", comment: "") + String.init(fre[0])
            abono.text = NSLocalizedString("Abono", comment: "") + String.init(abo[0])
            sol.text = NSLocalizedString("Sol", comment: "") + String.init(solS[0])
        }
        
        //LLamada al métedo ajusta campos para que se visualizen correctamente todos los campos de la pantalla
        ajustaCampos()
        //Inicialización de las cadenas de los meses de siembra que se visualizan en la pantalla
        verSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "07,08,09")
        otoSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "10,11,12")
        invSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "01,02,03")
        priSiembra.text = devuelveCadena(tipo: "siembra", cadenaBuscar: "04,05,06")
        //Inicialización de las cadenas de los meses de cosecha que se visualizan en la pantalla
        verCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "07,08,09")
        otoCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "10,11,12")
        invCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "01,02,03")
        priCosecha.text = devuelveCadena(tipo: "cosecha", cadenaBuscar: "04,05,06")
    }
    
    @IBAction func cultivar(_ sender: Any) {
        //Cuando un usuario pulsa cultivar se deben actualizar dos tablas, la primera es DetCultivoUsuario que guarda el cultivo en el apartado "mi huerta" del usuario con sus parámetros de cultivo y la segunda es la tabla CultivoUsuario que relaciona el usuario con todos sus cultivos
        let urlString = "https://huerto.herokuapp.com/detCultivoUsuario";
        //Creación de la url
        let fecha = Date()
        let fechaString = fecha.description
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        //Creacción de la cadena que se envía al servicio web para el guardado del cultivo al usuario
        let postString1 = "fechaInicio=" + fechaString + "&cosecha=false&siembra=false&crecimiento=false&transplantar=false" + "&notificarRegar=false&notificarPoda=false&notificarTransplantar=false&descSiembra=" + self.cultivo.descrSiembra + "&descCosecha=" + self.cultivo.descCosechar
        let postString2 = "&descTrasplantar=" + self.cultivo.descTrasplantar + "&descCrecimiento=" + self.cultivo.descCrecimiento + "&numMesesSiembra="
        let postString3 = String.init(self.cultivo.numMesesSiembra) + "&numMesesCrecimiento=" + String.init(self.cultivo.numMesesCrecimiento)
        let postString = postString1 + postString2 + postString3
        //Al ser un método POST se debe inicializar con los valores correspondientes el objeto URLRequest
        request.httpBody = postString.data(using: .utf8)
        //Lanzamiento de la petición
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            //Si el guardado se ha realizado correctamente, se hace la inserción del registro en la otra tabla en caso contrario se muestra un mensaje de error
            if(error == nil){
                //Obtención de la respuesta en formato json
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtención del nuevo registro de la tabla detCultivoUsuario recien creado
                let detCultivoUsuario = result.object(forKey: "detCultivoUsuario") as! NSMutableDictionary
                //Obtención del id de la tabla detCultivoUsuario para su guardado en la tabla cultivoUsuario
                let id = detCultivoUsuario["_id"] as! String
                let urlStringCulUsuario = "https://huerto.herokuapp.com/cultivoUsuario";
                //Creacción de la url
                let urlCulUsuario = URL(string: urlStringCulUsuario);
                var requestCulUsuario = URLRequest(url: urlCulUsuario!);
                requestCulUsuario.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                requestCulUsuario.httpMethod = "POST"
                //Creacción de la cadena que se envía al servicio web para el guardado del registro
                let postString = "idCultivoUsuario=" + id + "&idUsuario=" + self.usuario.id + "&idCultivo=" + self.cultivo.id + "&nombre=" + self.cultivo.nombre + "&imgCultivo=" + self.cultivo.imgCultivo
                //Al ser un método POST se debe inicializar con los valores correspondientes el objeto URLRequest
                requestCulUsuario.httpBody = postString.data(using: .utf8)
                //Lanzamiento de la petición
                let task = URLSession.shared.dataTask(with: requestCulUsuario){ (data, response, error) in
                    //Se muestra un mensaje al usuario informándole de si el proceso ha terminado correctamente o no
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
        //Método para mostrar un alert fuera del hilo principal con el título y el texto proporcionados
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ajustaCampos(){
        //Carga de strings en funcion del idioma
        verano.text = "  " + NSLocalizedString("Verano", comment: "")
        primavera.text = "  " + NSLocalizedString("Primavera", comment: "")
        otono.text = "  " + NSLocalizedString("Otono", comment: "")
        invierno.text = "  " + NSLocalizedString("Invierno", comment: "")
        siembra.text = "  " + NSLocalizedString("Siembra", comment: "")
        cosecha.text = "  " + NSLocalizedString("Cosecha", comment: "")
        //Si el dispositivo de acceso es pequeño se modifica el tamaño de todos los textos para una mejor visualización
        let device: UIDevice = UIDevice.current
        if((device.name == "iPhone 5s") || (device.name == "iPhone 6s") || (device.name == "iPhone 6")){
            descripcion.font = UIFont(name: descripcion.font.fontName, size: 12)
            tipoTierra.font = UIFont(name: descripcion.font.fontName, size: 12)
            espacio.font = UIFont(name: descripcion.font.fontName, size: 12)
            poda.font = UIFont(name: descripcion.font.fontName, size: 12)
            sol.font = UIFont(name: descripcion.font.fontName, size: 12)
            frecuenciaRiego.font = UIFont(name: descripcion.font.fontName, size: 12)
            temp.font = UIFont(name: descripcion.font.fontName, size: 12)
            abono.font = UIFont(name: descripcion.font.fontName, size: 12)
        }
    }

    func devuelveCadena(tipo: String, cadenaBuscar:String) -> String{
        //Para crear las cadenas de siembra / cosecha (X _ _ ) se compara los meses de siembra/cosecha del cultivo con las proporcionadas en el método en función de la estación
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
