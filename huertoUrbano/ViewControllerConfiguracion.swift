//
//  ViewControllerConfiguracion.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 02/12/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerConfiguracion: UIViewController {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var email: UILabel!
    var usuario : Usuario!
    @IBOutlet weak var lbSonido: UILabel!
    @IBOutlet weak var swSonido: UISwitch!
    @IBOutlet weak var swNot: UISwitch!
    @IBOutlet weak var lbNot: UILabel!
    @IBOutlet weak var lbGps: UILabel!
    @IBOutlet weak var swGps: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombre.text = usuario.nombre
        email.text = usuario.email
        if(usuario.permiteGps == true){ swGps.isOn = true}else{swGps.isOn = false}
        if(usuario.permiteSonido == true){ swSonido.isOn = true}else{swSonido.isOn = false}
        if(usuario.permiteNotificaciones == true){ swNot.isOn = true}else{swNot.isOn = false}
        lbGps.text = NSLocalizedString("Permitir gps", comment: "")
        lbNot.text = NSLocalizedString("Permitir notificaciones", comment: "")
        lbSonido.text = NSLocalizedString("Sonido", comment: "")
    }
    
    @IBAction func modificarSonido(_ sender: Any) {
        actualizaUsuario()
        self.usuario.permiteNotificaciones = self.swNot.isOn
        self.usuario.permiteSonido = self.swSonido.isOn
        self.usuario.permiteGps = self.swGps.isOn
    }
    
    @IBAction func modificarNotificacion(_ sender: Any) {
        actualizaUsuario()
        self.usuario.permiteNotificaciones = self.swNot.isOn
        self.usuario.permiteSonido = self.swSonido.isOn
        self.usuario.permiteGps = self.swGps.isOn
    }
    
    @IBAction func modificarGps(_ sender: Any) {
        actualizaUsuario()
        self.usuario.permiteNotificaciones = self.swNot.isOn
        self.usuario.permiteSonido = self.swSonido.isOn
        self.usuario.permiteGps = self.swGps.isOn
    }
    
    func actualizaUsuario(){
        let urlString = "https://huerto.herokuapp.com/usuarios/" + self.usuario.id
        //Creo la url
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        var gps = "false"
        if (self.swGps.isOn){gps = "true"}
        var not = "false"
        if(self.swNot.isOn){not = "true"}
        var sonido = "false"
        if(self.swSonido.isOn){sonido = "true"}
        let postString = "permiteGps=" + gps + "&permiteNotificaciones=" + not + "&permiteSonido=" + sonido
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
                
            }
        }
        task.resume();
    }
}
