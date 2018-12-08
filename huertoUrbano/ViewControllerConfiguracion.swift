//
//  ViewControllerConfiguracion.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 02/12/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerConfiguracion: UIViewController {

    //Variables de pantalla
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var lbSonido: UILabel!
    @IBOutlet weak var swSonido: UISwitch!
    @IBOutlet weak var swNot: UISwitch!
    @IBOutlet weak var lbNot: UILabel!
    @IBOutlet weak var lbGps: UILabel!
    @IBOutlet weak var swGps: UISwitch!
    //Objeto usuario obtenido durante el alta
    var usuario : Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Muestro los valores en pantalla en función de lo que se encuentra en el objeto usuario
        nombre.text = usuario.nombre
        email.text = usuario.email
        if(usuario.permiteGps == true){ swGps.isOn = true}else{swGps.isOn = false}
        if(usuario.permiteSonido == true){ swSonido.isOn = true}else{swSonido.isOn = false}
        if(usuario.permiteNotificaciones == true){ swNot.isOn = true}else{swNot.isOn = false}
        //Carga de strings en funcion del idioma
        lbGps.text = NSLocalizedString("Permitir gps", comment: "")
        lbNot.text = NSLocalizedString("Permitir notificaciones", comment: "")
        lbSonido.text = NSLocalizedString("Sonido", comment: "")
    }
    
    @IBAction func modificarSonido(_ sender: Any) {
        //Guardo la modifiación hecha por el usuario sobre el permiso de sonido
        actualizaUsuario()
        self.usuario.permiteSonido = self.swSonido.isOn
    }
    
    @IBAction func modificarNotificacion(_ sender: Any) {
        //Guardo la modifiación hecha por el usuario sobre el permiso de notificaciones
        actualizaUsuario()
        self.usuario.permiteNotificaciones = self.swNot.isOn
    }
    
    @IBAction func modificarGps(_ sender: Any) {
        //Guardo la modifiación hecha por el usuario sobre el permiso de gps
        actualizaUsuario()
        self.usuario.permiteGps = self.swGps.isOn
    }
    
    func actualizaUsuario(){
        let urlString = "https://huerto.herokuapp.com/usuarios/" + self.usuario.id
        //Creación de la url para llamar al servicio web
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        //Al ser un método POST se debe inicializar con los valores correspondientes el objeto URLRequest
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        var gps = "false"
        if (self.swGps.isOn){gps = "true"}
        var not = "false"
        if(self.swNot.isOn){not = "true"}
        var sonido = "false"
        if(self.swSonido.isOn){sonido = "true"}
        let postString = "permiteGps=" + gps + "&permiteNotificaciones=" + not + "&permiteSonido=" + sonido
        //Envio en la request del string que contiene los datos a guardar
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
            }
        }
        task.resume();
    }
}
