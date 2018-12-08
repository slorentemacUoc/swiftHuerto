//
//  Cultivo.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import Foundation

class Cultivo: NSObject{
    //Campos del objeto cultivo
    var id = "";
    var nombre = "";
    var descripcion = "";
    var mesesSiembra = "";
    var mesesCosecha = "";
    var tipoTierra = "";
    var espacioEntrePlantas = "";
    var necesitaPoda = "";
    var frecuenciaRiego = "";
    var tempMax = 0;
    var tempMin = 0;
    var numMesesSiembra = 0;
    var numMesesCrecimiento = 0;
    var descCosechar = "";
    var descCrecimiento = "";
    var imgCultivo = "";
    var imgMeses = "";
    var abonos = "";
    var solSombra = "";
    var descTrasplantar = "";
    var descrSiembra = "";
    var localizacion = "";
    
    //Constructor del objeto cultivo
    init(id: String, nombre: String, descripcion: String,mesesSiembra: String, mesesCosecha:String,
         tipoTierra:String, espacioEntrePlantas: String, necesitaPoda:String, frecuenciaRiego:String,
         tempMax: Int, tempMin:Int, numMesesSiembra:Int, numMesesCrecimiento:Int, descCosechar:String,
         descCrecimiento: String, imgCultivo:String, imgMeses:String, abonos:String, solSombra:String, descTrasplantar:String, descSiembra:String, localizacion: String){
        self.id = id;
        self.nombre = nombre;
        self.descripcion = descripcion;
        self.mesesSiembra = mesesSiembra;
        self.mesesCosecha = mesesCosecha;
        self.tipoTierra = tipoTierra;
        self.espacioEntrePlantas = espacioEntrePlantas;
        self.necesitaPoda = necesitaPoda;
        self.frecuenciaRiego = frecuenciaRiego;
        self.tempMax = tempMax;
        self.tempMin = tempMin;
        self.numMesesSiembra = numMesesSiembra;
        self.numMesesCrecimiento = numMesesCrecimiento;
        self.descCosechar = descCosechar;
        self.descCrecimiento = descCrecimiento;
        self.imgCultivo = imgCultivo;
        self.imgMeses = imgMeses;
        self.abonos = abonos;
        self.solSombra = solSombra;
        self.descTrasplantar = descTrasplantar;
        self.descrSiembra = descSiembra;
        self.localizacion = localizacion;
        super.init();
    }
    
    //Constructor vacío del objeto cultivo
    convenience override init(){
        self.init(id: "", nombre: "", descripcion: "", mesesSiembra: "", mesesCosecha: "", tipoTierra: "", espacioEntrePlantas: "", necesitaPoda: "", frecuenciaRiego: "", tempMax: 0, tempMin: 0, numMesesSiembra: 0, numMesesCrecimiento: 0, descCosechar: "", descCrecimiento: "", imgCultivo: "", imgMeses: "", abonos: "", solSombra: "", descTrasplantar: "", descSiembra: "", localizacion: "")
    }
}
