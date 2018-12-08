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
    //Variables de pantalla
    @IBOutlet weak var btCultivosDisp: UIButton!
    @IBOutlet weak var btMiHuerta: UIButton!
    @IBOutlet weak var btConfiguracion: UIButton!
    @IBOutlet weak var btCerrarSesion: UIButton!
    //Objeto usuario del alta con todas las propiedades del usuario
    var usuario : Usuario!
    //Listas de cultivos para la visualización de los cultivos disponibles en todas las variaciones posibles (ordenadas por localizacion, temporada o alfabético) y cultivos la lista por defecto que se muestra
    var cultivos = [Cultivo]()
    var cultivosLocalizacion = [Cultivo]()
    var cultivosAlfabetica = [Cultivo]()
    //Lista de los cultivos que tiene el usuario marcados como activos
    var cultivosSiembra = [Cultivo]()
    var miHuerta = [CultivoUsuario]()
    //Objeto CLLocationManager para poder acceder a la localización del usuario
    var locationManager: CLLocationManager!
    //Variable para la gestión de la localización del usuario dentro de las localizaciones de los cultivos ( se han establecido 4 posiciones diferentes del 1 al 4 en función de la posición noreste, noroeste, sureste y suroeste de España para los diferentes cultivos
    var localizacionUsuario: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //En la barra de navegación no debe aparece el botón back
        self.navigationItem.setHidesBackButton(true, animated: true)
        //Carga de los strings en función del idioma
        btCultivosDisp.setTitle(NSLocalizedString("Cultivos disponibles", comment: ""), for: .normal)
        btMiHuerta.setTitle(NSLocalizedString("Mi huerta", comment: ""), for: .normal)
        btConfiguracion.setTitle(NSLocalizedString("Configuracion", comment: ""), for: .normal)
        btCerrarSesion.setTitle(NSLocalizedString("Cerrar sesion", comment: ""), for: .normal)
        //Si el usuario tiene activado el permiso para acceder a su gps se comprueba si lo ha facilitado y en caso contrario se le pregunta
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
        //Se realiza la tabla con la ordenación por localización si el usuario lo permite
        if((manager.location != nil) && (usuario.permiteGps)){
            ordenaPorLocalizacion(coordenada: manager.location!.coordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Vaciado e inicialinación de las listas de cultivos y de miHuerta
        miHuerta = [CultivoUsuario]()
        cultivos = [Cultivo]()
        obtenMiHuerta()
        obtenCultivos()
    }
    @IBAction func IrCultivosDisponibles(_ sender: Any) {
        //Ir a cultivos disponibles
        self.performSegue (withIdentifier: "cultivosDisponibles", sender: self)
    }
    
    @IBAction func irMiHuerta(_ sender: Any) {
        //Si el usuario tiene cultivos en su huerta se va a ella, en caso contrario se muestra un mensaje de error informando de que no tiene ningún cultivo en "mihuerta"
        if(miHuerta.count > 0){
            self.performSegue (withIdentifier: "mihuerta", sender: self)
        }else{
           muestraAlert(titulo: "Informacion", texto: "Registros huerta")
        }
        
    }
    
    func muestraAlert(titulo:String, texto:String){
        //Método para mostrar un alert fuera del hilo principal con el título y el texto proporcionados
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ordenaPorLocalizacion(coordenada: CLLocationCoordinate2D){
        //Vaciado de la lista cultivosLocaliación
        cultivosLocalizacion = [Cultivo]()
        //Obtención de la posición exacta del usuario con la cual se determina en cual de las 4 zonas geográficas se encuentra, si tenemos la coordenada del usuario
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
        //Si el cultivo tiene la localización en la que se encuentra el usuario dicho cultivo se pone al principio de la lista en caso contrario se coloca al final
        repeat{
            if(cultivos.count > 0){
                if(cultivos[i].localizacion.contains(String.init(localizacionUsuario))){
                    cultivosLocalizacion.insert(cultivos[i], at: 0)
                }else{
                    cultivosLocalizacion.insert(cultivos[i], at: cultivosLocalizacion.count)
                }
            }
            i = i + 1
        }while(i < cultivos.count)
        
    }
    
    func ordenaSiembraAlfabetica(){
        //Obtención del mes actual
        let date = Date()
        let calendar = NSCalendar.current
        let componentes = calendar.dateComponents([.year, .month, .day], from: date)
        let mes = componentes.month!
        var mesBuscar = ""
        //En el servicio web todos los meses se guardan con formato de dos dígitos por lo que se debe poner también así
        if(mes > 9 ){
            mesBuscar = String.init(mes)
        }else{
            mesBuscar = "0" + String.init(mes)
        }
        var i = 0
        //Inicialización de las listas cultivosSiembra y cultivosAlfabetica
        cultivosSiembra = [Cultivo]()
        cultivosAlfabetica = [Cultivo]()
        //Primero se realiza la ordenación de la tabla alfabética teniendo encuenta si el lenguaje es ingles o español
        let idioma = Locale.current.languageCode
        if(idioma == "en"){
            cultivosAlfabetica = cultivos.sorted(by: {$0.nombre.split(separator: ";")[1] < $1.nombre.split(separator: ";")[1]})
        }else{
            cultivosAlfabetica = cultivos.sorted(by: {$0.nombre < $1.nombre})
        }
        //Si el mes actual es uno de los posibles donde se puede sembrar se posiciona al principio de la lista en caso contrario al final
        repeat{
            if(cultivos[i].mesesSiembra.contains(mesBuscar)){
                cultivosSiembra.insert(cultivos[i], at: 0)
            }else{
                cultivosSiembra.insert(cultivos[i], at: cultivosSiembra.count)
            }
            i = i + 1
        }while(i < cultivos.count)
    }
    
    @IBAction func irConfiguracion(_ sender: Any) {
        //Ir a configuración
        self.performSegue(withIdentifier: "irConfiguracion", sender: self)
    }
    
    @IBAction func cerrarSesion(_ sender: Any) {
        //Vuelve a la pantalla inicial sin pasarle el objeto usuario
        self.performSegue(withIdentifier: "cerrarSesion", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cultivosDisponibles"){
            //Si va a la pantalla cultivos disponibles se realiza la carga de las diferentes listas con las ordenaciones disponibles
            ordenaSiembraAlfabetica()
            let listacultivos = segue.destination as! ViewControllerCultivos
            listacultivos.usuario = self.usuario;
            //Si el usuario no tiene activada o no permite la localización la lista por defecto que se mostrará es la alfabética en caso contrario la ordenada por localización
            if((self.localizacionUsuario == 0)||(self.usuario.permiteGps == false)){
                listacultivos.cultivos = self.cultivosAlfabetica
                listacultivos.cultivosLocalizacion = nil
            }else{
                listacultivos.cultivos = self.cultivosLocalizacion
                listacultivos.cultivosLocalizacion = self.cultivosLocalizacion
            }
            listacultivos.cultivosAlfabetico = self.cultivosAlfabetica
            listacultivos.cultivosTemporada = self.cultivosSiembra
        }else if (segue.identifier == "mihuerta"){
            //Carga los valores necesarios en "mihuerta"
            let listacultivos = segue.destination as! ViewControllerMiHuerta
            listacultivos.usuario = self.usuario;
            listacultivos.miHuerta = self.miHuerta;
        }else if(segue.identifier == "irConfiguracion"){
            //Carga los valores necesarios en "Configuración"
            let configuracion = segue.destination as! ViewControllerConfiguracion
            configuracion.usuario = self.usuario;
        }
    }
    
    func obtenCultivos(){
        //Carga del array con todos los cultivos disponibles para que esten accesibles para toda la aplicacion
        let urlString = "https://huerto.herokuapp.com/cultivos";
        //Creación de la url
        let url = URL(string: urlString);
        //Creación de la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzamiento de la petición
        let task = URLSession.shared.dataTask(with: url!){
            (data,response, error ) in
            if(error == nil){
                //Obtención del resultado en formato json
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo de los cultivos que devuelve el servicio web y guardado en la lista de cultivos
                let cultivosJson = result.object(forKey: "cultivo") as! NSArray
                var i = 0
                repeat{
                    //Obtengo los diferentes valores del json y los cargo en un objeto cultivo
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
        //Formación de la string del url del servicio web
        let urlString = "https://huerto.herokuapp.com/cultivoUsuario?id=" + usuario.id ;
        //Creación de la url
        let url = URL(string: urlString);
        //Creación de la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzamiento de la petición
        let task = URLSession.shared.dataTask(with: url!){
            (data,response, error ) in
            if(error == nil){
                //Obtención de la respuesta en formato json
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtención de los cultivos pertenecientes a la huerta del usuario
                let huertaJson = result.object(forKey: "cultivoUsuario") as! NSArray
                //Si obtengo datos de la huerta los voy guardando en la lista miHuerta
                if (huertaJson.count > 0){
                    //Obtengo los diferentes valores del json y los cargo en un objeto cultivoUsuario
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


