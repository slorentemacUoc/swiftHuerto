//
//  File.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 01/12/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import Foundation

class Rest{
    
    static func getUsuario(usuario:String, contrasena:String)-> Usuario?{
        var objUsuario:Usuario? = Usuario()
        //Formo la string del url del servicio web
        let urlString = "https://huerto.herokuapp.com/usuarios?email=" + usuario + "&contrasena=" + contrasena;
        //Creo la url
        let url = URL(string: urlString);
        //Creo la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzo la petición
        var encontrado = false
        let task = URLSession.shared.dataTask(with: url!, completionHandler:{(data,response, error ) in
        //let task = URLSession.shared.dataTask(with: url!){
            //(data,response, error ) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo los usuarios que me devuelve el servicio web
                let usuariosJson = result.object(forKey: "usuario") as! NSArray
                //Si llegan los datos del usuario los guardo en la variable usuario
                if (usuariosJson.count > 0){
                    //Obtengo los diferentes valores del json y los cargo en un objeto Usuario
                    let usuarioJson = usuariosJson[0] as! NSMutableDictionary;
                    let nombre = usuarioJson["nombre"] as! String
                    let id = usuarioJson["_id"] as! String
                    let contrasena = usuarioJson["contrasena"] as! String
                    let email = usuarioJson["email"] as! String
                    let permiteGps = usuarioJson["permiteGps"] as! Bool
                    let permiteNotificaciones = usuarioJson["permiteNotificaciones"] as! Bool
                    let permiteSonido = usuarioJson["permiteSonido"] as! Bool
                    objUsuario  = Usuario.init(id: id, contrasena: contrasena, email: email, nombre: nombre, permiteGps: permiteGps, permiteNotificaciones: permiteNotificaciones, permiteSonido: permiteSonido)
                    print("usuario")
                    print(objUsuario)
                    encontrado = true
                    
                }
            }
        })
        task.resume()
        if(encontrado)
        {
            return objUsuario
        }else{
            return nil
        }
    }
    
}
