//
//  ViewControllerDetalle.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 30/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit
import UserNotifications;

class ViewControllerDetalle: UIViewController {

    //Objetos obtenidos anteriormente
    var usuario : Usuario!
    var cultivoUsuario: CultivoUsuario!
    var detCultivoUsuario: DetCultivoUsuario!
    var cultivo: Cultivo!
    //Variables de campos de pantalla
    @IBOutlet weak var swSiembra: UISwitch!
    @IBOutlet weak var descSiembra: UILabel!
    @IBOutlet weak var lbSiembra: UILabel!
    @IBOutlet weak var lbTrasplantar: UILabel!
    @IBOutlet weak var lbCuidar: UILabel!
    @IBOutlet weak var lbCosechar: UILabel!
    @IBOutlet weak var txSiembra: UILabel!
    @IBOutlet weak var txTras: UILabel!
    @IBOutlet weak var swTras: UISwitch!
    @IBOutlet weak var desTras: UILabel!
    @IBOutlet weak var altDescSiembra: NSLayoutConstraint!
    @IBOutlet weak var altDescTras: NSLayoutConstraint!
    @IBOutlet weak var txCuidar: UILabel!
    @IBOutlet weak var swCuidar: UISwitch!
    @IBOutlet weak var desCuidar: UILabel!
    @IBOutlet weak var altDescCuidar: NSLayoutConstraint!
    @IBOutlet weak var txCosechar: UILabel!
    @IBOutlet weak var swCosechar: UISwitch!
    @IBOutlet weak var desCosechar: labelParrafo!
    @IBOutlet weak var altDesCosechar: NSLayoutConstraint!
    @IBOutlet weak var lbRiego: UILabel!
    @IBOutlet weak var swRiego: UISwitch!
    @IBOutlet weak var lbNotTras: UILabel!
    @IBOutlet weak var swNotTras: UISwitch!
    @IBOutlet weak var lbPoda: UILabel!
    @IBOutlet weak var swPoda: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //En función del idioma del sistema todos los campos de la pantalla deben visualizarse en ingles o en español para eso el servicio web los devuelve siguiendo el esquema español;ingles
        let idioma = Locale.current.languageCode
        let txtNombre  = cultivoUsuario.nombre.split(separator: ";")
        let txtSiembra = cultivo.descrSiembra.split(separator: ";")
        let txtTras = cultivo.descTrasplantar.split(separator: ";")
        let txtCuidar = cultivo.descCrecimiento.split(separator: ";")
        let txtCosechar = cultivo.descCosechar.split(separator: ";")
        if(idioma == "en"){
            self.navigationItem.title = String.init(txtNombre[1])
            descSiembra.text = String.init(txtSiembra[1])
            desTras.text = String.init(txtTras[1])
            desCosechar.text = String.init(txtCosechar[1])
            desCuidar.text = String.init(txtCuidar[1])
        }else{
            self.navigationItem.title = String.init(txtNombre[0])
            descSiembra.text = String.init(txtSiembra[0])
            desTras.text = String.init(txtTras[0])
            desCosechar.text = String.init(txtCosechar[0])
            desCuidar.text = String.init(txtCuidar[0])
        }
        //Comprobación de si el usuario permite notificaciones en su configuración si es así se sólita poder acceder a ellas
        var permiteNot = true
        if(usuario.permiteNotificaciones == false){permiteNot = false}
        else{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler:{(granted, error) in
                permiteNot = granted
            });
        }
        //En caso de que no permita notificaciones, todos los switch estarán deshabilitados
        if(permiteNot == false){
            swPoda.isEnabled = false;
            swPoda.isOn = false;
            swRiego.isOn = false;
            swRiego.isEnabled = false;
            swNotTras.isEnabled = false;
            swNotTras.isOn = false;
        }else{
            //Si el usuario permite notificaciones, se mostrarán activas o no en función de los datos proporcionados por el servicio web
            if(detCultivoUsuario.notificarPoda){swPoda.isOn = true}else{swPoda.isOn = false}
            if(detCultivoUsuario.notificarRegar){swRiego.isOn = true}else{swRiego.isOn = false}
            if(detCultivoUsuario.notificarTrasplantar){swNotTras.isOn = true}else{swNotTras.isOn = false}
            //Si el cultivo no necesita poda el switch de la poda estará deshabilitado
            if(cultivo.necesitaPoda == "No;Not"){
                swPoda.isEnabled = false;
                swPoda.isOn = false;
            }
        }
        //Los switch correspondientes al estado del cultivo se activan o desactivan en función de los datos devueltos por el servicio web, para que se visualicen correctamente se utiliza el método modificarEstado
        if(detCultivoUsuario.cosecha){
            swCosechar.isOn = true;
            modificarEstado(modificado: "cosechar")
        }else{ swCosechar.isOn = false; }
        if(detCultivoUsuario.siembra){
            swSiembra.isOn = true;
            modificarEstado(modificado: "siembra")
        }else{ swSiembra.isOn = false;}
        if(detCultivoUsuario.crecimiento){
            swCuidar.isOn = true;
            modificarEstado(modificado: "cuidar")
        }else{swCuidar.isOn = false;}
        if(detCultivoUsuario.trasplantar){
            swTras.isOn = true;
            modificarEstado(modificado: "tras")
        }else{swTras.isOn = false;}
        //Se ajustan los campos en la pantalla para su mejor visualización
        ajustarCampos()
    }
    
    @IBAction func modificaSiembra(_ sender: Any) {
        //Si el switch de siembra es activado se llama al método modificar siembra para su correcta visualización, en caso contrario la descripción de la misma se invisibiliza
        if(swSiembra.isOn){
            modificarEstado(modificado: "siembra")
        }else{
            descSiembra.isHidden = true
            self.altDescSiembra.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    @IBAction func modificarTras(_ sender: Any) {
        //Si el switch de transplantar es activado se llama al método modificar siembra para su correcta visualización, en caso contrario la descripción de la misma se invisibiliza
        if(swTras.isOn){
            modificarEstado(modificado: "tras")
        }else{
            desTras.isHidden = true
            self.altDescTras.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    @IBAction func modificarCuidar(_ sender: Any) {
        //Si el switch de cuidar es activado se llama al método modificar siembra para su correcta visualización, en caso contrario la descripción de la misma se invisibiliza
        if(swCuidar.isOn){
            modificarEstado(modificado: "cuidar")
        }else{
            desCuidar.isHidden = true
            self.altDescCuidar.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    @IBAction func actualizaRiego(_ sender: Any) {
        //Si el switch de riego se realiza la notificación en caso contrario se elimina dicha notificación
        let center = UNUserNotificationCenter.current()
        if(swRiego.isOn){
            //Se crea la notificación los texto son cargados en función del idioma del sistema
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto regar", comment: "")
            //Si el usuario permite el sonido la notificación tendra sonido sino no
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            //La frecuencia de riego viene determinada por el capo frecuencia de riego del cultivo que sigue el patrón textoEspañol;textoIngles;numFrecuencia, en función del cual se establece cuando será mandada la notificación creando el trigger según dicho campo
            let date = Date(timeIntervalSinceNow: 3600)
            var triggerFrecuencia = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
            let freRiego = cultivo.frecuenciaRiego.split(separator: ";")
            if(freRiego[2] == "1"){
                triggerFrecuencia = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
            }else if (freRiego[2] == "2"){
                triggerFrecuencia = Calendar.current.dateComponents([.weekOfMonth,.minute,.second], from: date)
            }
            //Creacción del trigger
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerFrecuencia, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Regar", content: contenido, trigger: trigger)
            //Se añade la notificación al UNUserNotificationCenter
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            //Si el usuario desactiva la notificación se regar
            center.removePendingNotificationRequests(withIdentifiers: ["Regar"])
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    @IBAction func actualizaNotTras(_ sender: Any) {
        //Si el switch de trasplantar se realiza la notificación en caso contrario se elimina dicha notificación
        let center = UNUserNotificationCenter.current()
        if(swNotTras.isOn){
            //Se crea la notificación los texto son cargados en función del idioma del sistema
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto trasplantar", comment: "")
            //Si el usuario permite el sonido la notificación tendra sonido sino no
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            //Se calcula cuando debe lanzarse la notificación en este caso cuando los meses de siembra hayan finalizado
            let intervalo: Double = 60 * 60 * 24 * Double.init(cultivo.numMesesSiembra)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalo, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Trasplantar", content: contenido, trigger: trigger)
            //Se añade la notificación al UNUserNotificationCenter
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            //Si el usuario desactiva la notificación se elimina
            center.removePendingNotificationRequests(withIdentifiers: ["Trasplantar"])
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    
    @IBAction func actualizaPoda(_ sender: Any) {
        //Si el switch de podar se realiza la notificación en caso contrario se elimina dicha notificación
        let center = UNUserNotificationCenter.current()
        if(swPoda.isOn){
            //Se crea la notificación los texto son cargados en función del idioma del sistema
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto podar", comment: "")
            //Si el usuario permite el sonido la notificación tendra sonido sino no
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            //Se calcula cuando debe lanzarse la notificación en este caso cuando los meses de siembra y crecimiento hayan finalizado
            let intervalo1: Double = 60 * 60 * 24 * (Double.init(cultivo.numMesesCrecimiento)/2)
            let intervalo2: Double = 60 * 60 * 24 * Double.init(cultivo.numMesesSiembra)
            let intervalo = intervalo1 + intervalo2
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalo, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Podar", content: contenido, trigger: trigger)
            //Se añade la notificación al UNUserNotificationCenter
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            //Si el usuario desactiva la notificación se elimina
            center.removePendingNotificationRequests(withIdentifiers: ["Trasplantar"])
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    @IBAction func modificarCosechar(_ sender: Any) {
        //Si el switch de cosechar es activado se llama al método modificar siembra para su correcta visualización, en caso contrario la descripción de la misma se invisibiliza
        if(swCosechar.isOn){
            modificarEstado(modificado: "cosechar")
        }else{
            desCosechar.isHidden = true
            self.altDesCosechar.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        //Se guada en el servicio web la modificación realizada por el usuario
        actualizaDetalle()
    }
    
    
    
    func modificarEstado(modificado:String){
        //Todos los campos descripcion de los diferentes estados del cultivo son invisibilizados también se muestran todoslos label del estado negros
        descSiembra.isHidden = true
        self.altDescSiembra.constant = 0
        desTras.isHidden = true
        self.altDescTras.constant = 0
        desCuidar.isHidden = true
        self.altDescCuidar.constant = 0
        desCosechar.isHidden = true
        self.altDesCosechar.constant = 0
        lbCosechar.textColor = UIColor.black
        lbSiembra.textColor = UIColor.black
        lbTrasplantar.textColor = UIColor.black
        lbCuidar.textColor = UIColor.black
        //La descripcion del estado que se haya activado se visibiliza y su label de estado se pone naranja
        if(modificado == "siembra"){
            lbSiembra.textColor = UIColor.orange
            swCuidar.isOn = false
            swCosechar.isOn = false
            swTras.isOn = false
            descSiembra.isHidden = false
            self.altDescSiembra.constant = 60
        }else if(modificado == "tras"){
            lbTrasplantar.textColor = UIColor.orange
            swCuidar.isOn = false
            swSiembra.isOn = false
            swCosechar.isOn = false
            desTras.isHidden = false
            self.altDescTras.constant = 60
        }else if(modificado == "cuidar"){
            lbCuidar.textColor = UIColor.orange
            swSiembra.isOn = false
            swCosechar.isOn = false
            swTras.isOn = false
            desCuidar.isHidden = false
            self.altDescCuidar.constant = 60
        }else if(modificado == "cosechar"){
            lbCosechar.textColor = UIColor.orange
            swCuidar.isOn = false
            swSiembra.isOn = false
            swTras.isOn = false
            desCosechar.isHidden = false
            self.altDesCosechar.constant = 60
        }
        //Actualización de las constraints
        self.view.layoutIfNeeded()
        self.view.setNeedsUpdateConstraints()
    }
    
    func ajustarCampos(){
        //Carga de textos en función del idioma del sistema
        lbSiembra.text = " " + NSLocalizedString("Sembrar", comment: "")
        txSiembra.text =  NSLocalizedString("Sembrar", comment: "")
        
        lbCuidar.text = " " + NSLocalizedString("Cuidar", comment: "")
        txCuidar.text = NSLocalizedString("Cuidar", comment: "")
        
        lbTrasplantar.text = " " + NSLocalizedString("Trasplantar", comment: "")
        txTras.text =  NSLocalizedString("Trasplantar", comment: "")
        
        lbCosechar.text =  NSLocalizedString("Cosechar", comment: "")
        txCosechar.text = NSLocalizedString("Cosechar", comment: "")
        
        lbRiego.text = NSLocalizedString("Notificar riego", comment: "")
        lbNotTras.text = NSLocalizedString("Notificar trasplantar", comment: "")
        lbPoda.text = NSLocalizedString("Notificar poda", comment: "")
        //Si se esta accediendo desde un dispositivo muy pequeño todos los textos de la pantalla disminuyen para que su visualiazación sea óptima
        let device: UIDevice = UIDevice.current
        if((device.name == "iPhone 5s") || (device.name == "iPhone 6s") || (device.name == "iPhone 6")){
            descSiembra.font = UIFont(name: descSiembra.font.fontName, size: 12)
            txSiembra.font = UIFont(name: descSiembra.font.fontName, size: 12)
            txCosechar.font = UIFont(name: descSiembra.font.fontName, size: 12)
            txTras.font = UIFont(name: descSiembra.font.fontName, size: 12)
            txCuidar.font = UIFont(name: descSiembra.font.fontName, size: 12)
            lbPoda.font = UIFont(name: descSiembra.font.fontName, size: 12)
            lbRiego.font = UIFont(name: descSiembra.font.fontName, size: 12)
            lbNotTras.font = UIFont(name: descSiembra.font.fontName, size: 12)
            desCuidar.font = UIFont(name: descSiembra.font.fontName, size: 12)
            descSiembra.font = UIFont(name: descSiembra.font.fontName, size: 12)
            desCosechar.font = UIFont(name: descSiembra.font.fontName, size: 12)
            desTras.font = UIFont(name: descSiembra.font.fontName, size: 12)
        }
    }
    
    

    func actualizaDetalle(){
        let urlString = "https://huerto.herokuapp.com/detCultivoUsuario/" + self.detCultivoUsuario.idCultivoUsuario;
        //Creo la url
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        var cosechar = "false"
        if (self.swCosechar.isOn){cosechar = "true"}
        var siembra = "false"
        if(self.swSiembra.isOn){siembra = "true"}
        let postString1 = "fechaInicio=" + self.detCultivoUsuario.fechaInicio + "&cosecha=" + cosechar + "&siembra=" + siembra
        var cuidar = "false"
        if(self.swCuidar.isOn){cuidar = "true"}
        var tras = "false"
        if(self.swTras.isOn){tras = "true"}
        var regar = "false"
        if(self.swRiego.isOn){regar = "true"}
        var notTras = "false"
        if(self.swNotTras.isOn){notTras = "true"}
        let postString2 = "&crecimiento=" + cuidar + "&transplantar=" + tras + "&notificarRegar=" + regar + "&notificarTransplantar=" + notTras  + "&notificarPoda="
        var poda = "false"
        if(self.swPoda.isOn){poda = "true"}
        let postString3 = poda
        let postString = postString1 + postString2 +  postString3
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
                
            }
        }
        task.resume();
    }
    
    
    
}
