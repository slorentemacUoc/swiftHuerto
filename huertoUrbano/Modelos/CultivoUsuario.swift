//
//  CultivoUsuario.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import Foundation

class CultivoUsuario: NSObject{
    var id = "";
    var idCultivoUsuario = "";
    var idCultivo = "";
    var idUsuario = "";
    var nombre = "";
    var imgCultivo = "";
    
    
    init(id: String, idCultivoUsuario : String, idCultivo: String,idUsuario: String, nombre:String,  imgCultivo:String){
        self.id = id;
        self.idCultivoUsuario = idCultivoUsuario;
        self.idCultivo = idCultivo;
        self.idUsuario = idUsuario;
        self.nombre = nombre;
        self.imgCultivo = imgCultivo;
        super.init();
    }
    
    convenience override init(){
        self.init(id: "", idCultivoUsuario: "", idCultivo: "", idUsuario: "", nombre: "",  imgCultivo: "")
    }
}
