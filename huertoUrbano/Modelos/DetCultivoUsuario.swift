//
//  DetCultivoUsuario.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 30/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import Foundation

class DetCultivoUsuario: NSObject{
    var idCultivoUsuario = "";
    var fechaInicio = "";
    var cosecha = false;
    var siembra = false;
    var crecimiento = false;
    var trasplantar = false;
    var notificarRegar = false;
    var notificarPoda = false;
    var notificarTrasplantar = false;
    var descSiembra = "";
    var descCosecha = "";
    var descCrecimiento = "";
    var descTrasplantar = "";
    
    init(idCultivoUsuario:String, fechaInicio:String, cosecha:Bool, siembra:Bool, crecimiento:Bool, trasplantar:Bool, notificarRegar:Bool, notificarPoda:Bool, notificarTrasplantar:Bool, descSiembra:String, descCosecha:String, descCrecimiento:String, descTrasplantar:String){
        self.idCultivoUsuario = idCultivoUsuario;
        self.fechaInicio = fechaInicio;
        self.cosecha = cosecha;
        self.crecimiento = crecimiento;
        self.trasplantar = trasplantar;
        self.siembra = siembra;
        self.notificarRegar = notificarRegar;
        self.notificarPoda = notificarPoda;
        self.notificarTrasplantar = notificarTrasplantar;
        self.descSiembra = descSiembra;
        self.descCosecha = descCosecha;
        self.descCrecimiento = descCrecimiento;
        self.descTrasplantar = descTrasplantar;
        super.init();
    }
    
    convenience override init(){
        self.init(idCultivoUsuario: "", fechaInicio: "", cosecha: false, siembra: false, crecimiento: false, trasplantar: false, notificarRegar: false, notificarPoda: false, notificarTrasplantar: false, descSiembra: "", descCosecha: "", descCrecimiento: "", descTrasplantar: "")
    }
}
