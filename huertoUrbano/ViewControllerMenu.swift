//
//  ViewControllerMenu.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 26/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit
import CoreLocation

class ViewControllerMenu: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var btCultivosDisp: UIButton!
    @IBOutlet weak var btMiHuerta: UIButton!
    @IBOutlet weak var btConfiguracion: UIButton!
    @IBOutlet weak var btCerrarSesion: UIButton!
    
    var usuario : Usuario!
    var cultivos = [Cultivo]()
    var cultivosLocalizacion = [Cultivo]()
    var cultivosSiembra = [Cultivo]()
    var miHuerta = [CultivoUsuario]()
    var locationManager: CLLocationManager!
    var localizacionUsuario: Int = 0
    var cultivosAlfabetica = [Cultivo]()
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        super.viewDidLoad()
        obtenCultivos()
        //Cargo strings en funcion del idioma
        btCultivosDisp.setTitle(NSLocalizedString("Cultivos disponibles", comment: ""), for: .normal)
        btMiHuerta.setTitle(NSLocalizedString("Mi huerta", comment: ""), for: .normal)
        btConfiguracion.setTitle(NSLocalizedString("Configuracion", comment: ""), for: .normal)
        btCerrarSesion.setTitle(NSLocalizedString("Cerrar sesion", comment: ""), for: .normal)
        
        if(usuario.permiteGps){
            if(CLLocationManager.locationServicesEnabled()){
                locationManager = CLLocationManager();
                locationManager.delegate = self;
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(manager.location != nil){
            ordenaPorLocalizacion(coordenada: manager.location!.coordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        miHuerta = [CultivoUsuario]()
        obtenMiHuerta()
    }
    @IBAction func IrCultivosDisponibles(_ sender: Any) {
        self.performSegue (withIdentifier: "cultivosDisponibles", sender: self)
    }
    
    @IBAction func irMiHuerta(_ sender: Any) {
        if(miHuerta.count > 0){
            self.performSegue (withIdentifier: "mihuerta", sender: self)
        }else{
           muestraAlert(titulo: "Informacion", texto: "Registros huerta")
            
        }
        
    }
    
    func muestraAlert(titulo:String, texto:String){
        DispatchQueue.main.async {
            //Si no ha devuelto ningún usuario es porque no esta dado de alta por lo tanto muestro un mensaje de error
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ordenaPorLocalizacion(coordenada: CLLocationCoordinate2D){
        let latitud = coordenada.latitude
        let longitud = coordenada.latitude
        if((latitud < 40) && (longitud > -3.99)){
            localizacionUsuario = 4
        }else if((latitud > 40) && (longitud > -3.99)){
            localizacionUsuario = 2
        }else if((latitud > 40) && (longitud < -3.99)){
            localizacionUsuario = 1
        }else{ localizacionUsuario = 3}
        var i = 0;
        cultivosLocalizacion = [Cultivo]()
        repeat{
            if(cultivos[i].localizacion.contains(String.init(localizacionUsuario))){
                cultivosLocalizacion.insert(cultivos[i], at: 0)
            }else{
                cultivosLocalizacion.insert(cultivos[i], at: cultivosLocalizacion.count)
            }
            i = i + 1
        }while(i < cultivos.count)
    }
    
    func ordenaSiembraAlfabetica(){
        let date = Date()
        let calendar = NSCalendar.current
        let componentes = calendar.dateComponents([.year, .month, .day], from: date)
        let mes = componentes.month!
        var mesBuscar = ""
        switch mes{
        case 1: mesBuscar = "EN"; break;
        case 2: mesBuscar = "FE"; break;
        case 3: mesBuscar = "MA"; break;
        case 4: mesBuscar = "AB"; break;
        case 5: mesBuscar = "MY"; break;
        case 6: mesBuscar = "JN"; break;
        case 7: mesBuscar = "JL"; break;
        case 8: mesBuscar = "AG"; break;
        case 9: mesBuscar = "SP"; break;
        case 10: mesBuscar = "OC"; break;
        case 11: mesBuscar = "NO"; break;
        case 12: mesBuscar = "DC"; break;
        default: break
        }
        var i = 0
        cultivosSiembra = [Cultivo]()
        cultivosAlfabetica = [Cultivo]()
        cultivosAlfabetica = cultivos.sorted(by: {$0.nombre < $1.nombre})
        repeat{
            if(cultivos[i].mesesSiembra.contains(String.init(mesBuscar))){
                cultivosSiembra.insert(cultivos[i], at: 0)
            }else{
                cultivosSiembra.insert(cultivos[i], at: cultivosSiembra.count)
            }
            i = i + 1
        }while(i < cultivos.count)
    }
    
    @IBAction func irConfiguracion(_ sender: Any) {
        self.performSegue(withIdentifier: "irConfiguracion", sender: self)
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        self.performSegue(withIdentifier: "cerrarSesion", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cultivosDisponibles"){
            ordenaSiembraAlfabetica()
            let listacultivos = segue.destination as! ViewControllerCultivos
            listacultivos.usuario = self.usuario;
            if(self.localizacionUsuario == 0){
                listacultivos.cultivos = self.cultivosAlfabetica
                listacultivos.cultivosLocalizacion = nil
            }else{
                listacultivos.cultivos = self.cultivosLocalizacion
                listacultivos.cultivosLocalizacion = self.cultivosLocalizacion
            }
            listacultivos.cultivosAlfabetico = self.cultivosAlfabetica
            listacultivos.cultivosTemporada = self.cultivosSiembra
            
        }else if (segue.identifier == "mihuerta"){
            
            let listacultivos = segue.destination as! ViewControllerMiHuerta
            listacultivos.usuario = self.usuario;
            listacultivos.miHuerta = self.miHuerta;
        }else if(segue.identifier == "irConfiguracion"){
            let configuracion = segue.destination as! ViewControllerConfiguracion
            configuracion.usuario = self.usuario;
        }
        
    }
    
    func obtenCultivos(){
        //Cargo el array con todos los cultivos disponibles para que esten accesibles para toda la aplicacion
        let urlString = "https://huerto.herokuapp.com/cultivos";
        //Creo la url
        let url = URL(string: urlString);
        //Creo la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzo la petición
        
        
        let task = URLSession.shared.dataTask(with: url!){
            (data,response, error ) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo los usuarios que me devuelve el servicio web
                let cultivosJson = result.object(forKey: "cultivo") as! NSArray
                var i = 0
                repeat{
                    let cultivoJson = cultivosJson[i] as! NSMutableDictionary
                    let abonos = cultivoJson["abonos"] as! String
                    let id = cultivoJson["_id"] as! String
                    let descCosechar = cultivoJson["descCosechar"] as! String
                    let descCrecimiento = cultivoJson["descCrecimiento"] as! String
                    let descripcion = cultivoJson["descripcion"] as! String
                    let espacioEntrePlantas = cultivoJson["espacioEntrePlantas"] as! String
                    let frecuenciaRiego = cultivoJson["frecuenciaRiego"] as! String
                    let imgCultivo = cultivoJson["imgCultivo"] as! String
                    let imgMeses = cultivoJson["imgMeses"] as! String
                    let mesesCosecha = cultivoJson["mesesCosecha"] as! String
                    let mesesSiembra = cultivoJson["mesesSiembra"] as! String
                    let necesitaPoda = cultivoJson["necesitaPoda"] as! String
                    let nombre = cultivoJson["nombre"] as! String
                    let numMesesCrecimiento = cultivoJson["numMesesCrecimiento"] as! Int
                    let numMesesSiembra = cultivoJson["numMesesSiembra"] as! Int
                    let tempMax = cultivoJson["tempMax"] as! Int
                    let tempMin = cultivoJson["tempMin"] as! Int
                    let tipoTierra = cultivoJson["tipoTierra"] as! String
                    let solSombra = cultivoJson["solSombra"] as! String
                    let descTrasplantar = cultivoJson["descrTransplantar"] as! String
                    let descSiembra = cultivoJson["descSiembra"] as! String
                    let localizacion = cultivoJson["localizacion"] as! String
                    let cultivo = Cultivo.init(id: id, nombre: nombre, descripcion: descripcion, mesesSiembra: mesesSiembra, mesesCosecha: mesesCosecha, tipoTierra: tipoTierra, espacioEntrePlantas: espacioEntrePlantas, necesitaPoda: necesitaPoda, frecuenciaRiego: frecuenciaRiego, tempMax: tempMax, tempMin: tempMin, numMesesSiembra: numMesesSiembra, numMesesCrecimiento: numMesesCrecimiento, descCosechar: descCosechar, descCrecimiento: descCrecimiento, imgCultivo: imgCultivo, imgMeses: imgMeses,abonos: abonos,solSombra:solSombra, descTrasplantar:descTrasplantar, descSiembra:descSiembra, localizacion: localizacion)
                    self.cultivos.append(cultivo)
                    i = i + 1;
                }while(i < cultivosJson.count)
            }
        }
        task.resume()
    }
    
    func obtenMiHuerta(){
        //Formo la string del url del servicio web
        let urlString = "https://huerto.herokuapp.com/cultivoUsuario?id=" + usuario.id ;
        //Creo la url
        let url = URL(string: urlString);
        //Creo la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzo la petición
        
        let task = URLSession.shared.dataTask(with: url!){
            (data,response, error ) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo los usuarios que me devuelve el servicio web
                let huertaJson = result.object(forKey: "cultivoUsuario") as! NSArray
                //Si llegan los datos del usuario los guardo en la variable usuario
                if (huertaJson.count > 0){
                    //Obtengo los diferentes valores del json y los cargo en un objeto Usuario
                    var i = 0;
                    repeat{
                        let cultivoUsuarioJson = huertaJson[i] as! NSMutableDictionary;
                        let idCultivoUsuario = cultivoUsuarioJson["idCultivoUsuario"] as! String
                        let id = cultivoUsuarioJson["_id"] as! String
                        let idCutlivo = cultivoUsuarioJson["idCultivo"] as! String
                        let idUsuario = cultivoUsuarioJson["idUsuario"] as! String
                        let nombre = cultivoUsuarioJson["nombre"] as! String
                        let imgCultivo = cultivoUsuarioJson["imgCultivo"] as! String
                        i = i + 1;
                        let cultivoUsuario = CultivoUsuario.init(id: id, idCultivoUsuario: idCultivoUsuario, idCultivo: idCutlivo, idUsuario: idUsuario, nombre: nombre, imgCultivo: imgCultivo)
                        self.miHuerta.append(cultivoUsuario)
                    }while(i < huertaJson.count)
                }
            }
        }
        task.resume()
    }
}


