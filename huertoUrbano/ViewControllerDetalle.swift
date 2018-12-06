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

    
    var usuario : Usuario!
    var cultivoUsuario: CultivoUsuario!
    var detCultivoUsuario: DetCultivoUsuario!
    var cultivo: Cultivo!
    @IBOutlet weak var swSiembra: UISwitch!
    @IBOutlet weak var descSiembra: UILabel!
    @IBOutlet weak var nombre: UILabel!
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
        
        var permiteNot = true
        if(usuario.permiteNotificaciones == false){permiteNot = false}
        else{
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler:{(granted, error) in
                permiteNot = granted
            });
        }
        if(permiteNot == false){
            swPoda.isEnabled = false;
            swPoda.isOn = false;
            swRiego.isOn = false;
            swRiego.isEnabled = false;
            swNotTras.isEnabled = false;
            swNotTras.isOn = false;
        }else{
            if(detCultivoUsuario.notificarPoda){swPoda.isOn = true}else{swPoda.isOn = false}
            if(detCultivoUsuario.notificarRegar){swRiego.isOn = true}else{swRiego.isOn = false}
            if(detCultivoUsuario.notificarTrasplantar){swNotTras.isOn = true}else{swNotTras.isOn = false}
            if(cultivo.necesitaPoda == "no"){
                swPoda.isEnabled = false;
                swPoda.isOn = false;
            }
        }
        
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
        ajustarCampos()
    }
    

    @IBAction func modificaSiembra(_ sender: Any) {
        if(swSiembra.isOn){
            modificarEstado(modificado: "siembra")
        }else{
            descSiembra.isHidden = true
            self.altDescSiembra.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        actualizaDetalle()
    }
    
    @IBAction func modificarTras(_ sender: Any) {
        if(swTras.isOn){
            modificarEstado(modificado: "tras")
        }else{
            desTras.isHidden = true
            self.altDescTras.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        actualizaDetalle()
    }
    
    @IBAction func modificarCuidar(_ sender: Any) {
        if(swCuidar.isOn){
            modificarEstado(modificado: "cuidar")
        }else{
            desCuidar.isHidden = true
            self.altDescCuidar.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        actualizaDetalle()
    }
    
    @IBAction func actualizaRiego(_ sender: Any) {
        if(swRiego.isOn){
            let center = UNUserNotificationCenter.current()
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto regar", comment: "")
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            let date = Date(timeIntervalSinceNow: 3600)
            var triggerFrecuencia = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
            let freRiego = cultivo.frecuenciaRiego.split(separator: ";")
            if(freRiego[2] == "1"){
                triggerFrecuencia = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
            }else if (freRiego[2] == "2"){
                triggerFrecuencia = Calendar.current.dateComponents([.weekOfMonth,.minute,.second], from: date)
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerFrecuencia, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Regar", content: contenido, trigger: trigger)
            
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            let borraNotificacion = UNNotificationAction(identifier: "BorraRegar", title: "BorraRegar", options:[])
            let category = UNNotificationCategory(identifier: "Regar", actions: [borraNotificacion], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
        actualizaDetalle()
    }
    
    @IBAction func actualizaNotTras(_ sender: Any) {
        if(swNotTras.isOn){
            let center = UNUserNotificationCenter.current()
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto trasplantar", comment: "")
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            let intervalo: Double = 60 * 60 * 24 * Double.init(cultivo.numMesesSiembra)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalo, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Trasplantar", content: contenido, trigger: trigger)
            
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            let borraNotificacion = UNNotificationAction(identifier: "BorraTras", title: "BorraTras", options:[])
            let category = UNNotificationCategory(identifier: "Trasplantar", actions: [borraNotificacion], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
        actualizaDetalle()
    }
    
    
    @IBAction func actualizaPoda(_ sender: Any) {
        if(swPoda.isOn){
            let center = UNUserNotificationCenter.current()
            let contenido = UNMutableNotificationContent()
            contenido.title = NSLocalizedString("Huerto urbana", comment: "")
            contenido.body = NSLocalizedString("Huerto podar", comment: "")
            if(usuario.permiteSonido){
                contenido.sound = UNNotificationSound.default
            }else{
                contenido.sound = nil
            }
            contenido.badge = 1
            let intervalo1: Double = 60 * 60 * 24 * (Double.init(cultivo.numMesesCrecimiento)/2)
            let intervalo2: Double = 60 * 60 * 24 * Double.init(cultivo.numMesesSiembra)
            let intervalo = intervalo1 + intervalo2
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalo, repeats: false)
            let peticion = UNNotificationRequest.init(identifier: "Podar", content: contenido, trigger: trigger)
            
            center.add(peticion, withCompletionHandler: {(error) in
            })
        }else{
            let borraNotificacion = UNNotificationAction(identifier: "BorraPoda", title: "BorraPoda", options:[])
            let category = UNNotificationCategory(identifier: "Podar", actions: [borraNotificacion], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
        actualizaDetalle()
    }
    
    @IBAction func modificarCosechar(_ sender: Any) {
        if(swCosechar.isOn){
            modificarEstado(modificado: "cosechar")
        }else{
            desCosechar.isHidden = true
            self.altDesCosechar.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsUpdateConstraints()
        }
        actualizaDetalle()
    }
    
    
    
    func modificarEstado(modificado:String){
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
        self.view.layoutIfNeeded()
        self.view.setNeedsUpdateConstraints()
    }
    
    func ajustarCampos(){
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
