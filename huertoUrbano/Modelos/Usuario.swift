//
//  Usuario.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 25/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import Foundation

class Usuario: NSObject{
    var id = "";
    var contrasena = "";
    var email = "";
    var nombre = "";
    var permiteGps = false;
    var permiteNotificaciones = false;
    var permiteSonido = false;
    
    
    init(id: String, contrasena: String, email: String,nombre: String, permiteGps:Bool, permiteNotificaciones:Bool, permiteSonido:Bool){
        self.id = id;
        self.contrasena = contrasena;
        self.email = email;
        self.nombre = nombre;
        self.permiteGps = permiteGps;
        self.permiteNotificaciones = permiteNotificaciones;
        self.permiteSonido = permiteSonido;
        super.init();
    }
    
    convenience override init(){
        self.init(id: "", contrasena: "", email: "", nombre: "", permiteGps: false, permiteNotificaciones: false, permiteSonido: false)
    }
}
