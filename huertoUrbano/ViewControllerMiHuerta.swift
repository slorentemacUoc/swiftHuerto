//
//  ViewControllerMiHuerta.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerMiHuerta: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Variable de pantalla
    @IBOutlet weak var tablaHuerta: UITableView!
    //Objetos recibidos de la pantalla anterior, configuración del usuario y la lista con los culitvos de dicho usuario
    var usuario : Usuario!
    var miHuerta = [CultivoUsuario]()
    var cultivoUsuario = CultivoUsuario()
    //Idioma del sistema
    let idioma = Locale.current.languageCode
    var detCultivoUsuario = DetCultivoUsuario()
    var cultivo = Cultivo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Obtención del delegado y del datasource
        tablaHuerta.dataSource = self
        tablaHuerta.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "miCultivo"){
            //Si voy a miCultivo se le pasa a la siguiente pantalla los objetos usuarios con la configuración del usuario, el detCultivoUsuario con las especificaciones del cultivo para el usuario y el cultivo para tener las características generales del mismo
            let cultivo = segue.destination as! ViewControllerDetalle
            cultivo.usuario = self.usuario;
            cultivo.cultivoUsuario = self.cultivoUsuario;
            cultivo.detCultivoUsuario = self.detCultivoUsuario;
            cultivo.cultivo = self.cultivo;
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Devuelve el tamaño de la tabla
        return miHuerta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Creación de las filas de la tabla el texto a mostrar variará en función de si el idioma del sistema es ingles o español
        let cell = tableView.dequeueReusableCell(withIdentifier: "cultivo", for: indexPath) as! TableViewCellHuerta
        let texto = self.miHuerta[indexPath.row].nombre.split(separator: ";")
        if(idioma == "en"){
             cell.cultivoHuerta.text = String.init(texto[1])
        }else{
             cell.cultivoHuerta.text = String.init(texto[0])
        }
        return cell
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Si el usuario desea eleminar una fila se realiza la acción y se sincroniza el servicio web con el método eliminarFila
        if(editingStyle == .delete){
            let miCultivo = self.miHuerta[indexPath.row]
            self.miHuerta.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            eliminaFila(miCultivo: miCultivo)

        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cultivoUsuario = miHuerta[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        obtenDetalleCultivoUsuario()
    }
    
    func eliminaFila(miCultivo: CultivoUsuario){
        //La fila se debe eliminar de dos datas, la tabla cultivoUsuario que relaciona el usuario con los cultivos que tiene en "mi huerta" y en la tabla DetCultivoUsuario con las características que el usuario a guardado para ese cultivo en concreto
        let urlString = "https://huerto.herokuapp.com/cultivoUsuario/" + miCultivo.id;
        print(urlString)
        //Creación de la url
        let url = URL(string: urlString);
        //Creación del URLRequest de tipo delete
        var request = URLRequest(url: url!);
        request.httpMethod = "DELETE";
        //Lanzamiento de la petición
        let sesion = URLSession.shared
        let task = sesion.dataTask(with: request){
            (data,response, error ) in
            if(error == nil){
                //Si el borrado en la tabla cultivoUsuario ha sido correcto, se borrar el registro también en la tabla DetCultivoUsuario
                let urlStringDet = "https://huerto.herokuapp.com/detCultivoUsuario/" + miCultivo.idCultivoUsuario;
                //Creación de la url
                let urlDet = URL(string: urlStringDet);
                //Creación del URLRequest de tipo delete
                var requestDet = URLRequest(url: urlDet!);
                requestDet.httpMethod = "DELETE";
                //Lanzo la petición
                let task2 = URLSession.shared.dataTask(with: requestDet){
                    (data,response,error) in
                    if(error != nil){
                    }
                }
                task2.resume()
            }
        }
        task.resume()
    }
    
    
    
    func obtenDetalleCultivoUsuario(){
        //Para pasar a la siguiente pantalla necesito obtener las propiedades que el usuario ha guardado para su cultivo en la tabla detCultivoUsuario y las propiedades generales del cultivo que se encuentran en la tabla Cultivo
        let urlString = "https://huerto.herokuapp.com/detCultivoUsuario?id=" + cultivoUsuario.idCultivoUsuario;
        //Creación de la petición
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
                //Obtención del registro detCultivoUsuario en formato json, tras lo cual se trata y se rellena con el el objteo self.detCultivoUsuario
                let miscultivosJson = result.object(forKey: "detCultivoUsuario") as! NSArray
                let miCultivoJson = miscultivosJson[0] as! NSMutableDictionary
                let id = miCultivoJson["_id"] as! String
                let fecha = miCultivoJson["fechaInicio"] as! String
                let cosecha = miCultivoJson["cosecha"] as! Bool
                let siembra = miCultivoJson["siembra"] as! Bool
                let crecimiento = miCultivoJson["crecimiento"] as! Bool
                let trasplantar = miCultivoJson["transplantar"] as! Bool
                let notificarRegar = miCultivoJson["notificarRegar"] as! Bool
                let notificarPoda = miCultivoJson["notificarPoda"] as! Bool
                let notificarTrasplantar = miCultivoJson["notificarTransplantar"] as! Bool
                //Actualización del objeto self.detCultivoUsuario
                self.detCultivoUsuario = DetCultivoUsuario.init(idCultivoUsuario: id, fechaInicio: fecha, cosecha: cosecha, siembra: siembra, crecimiento: crecimiento, trasplantar: trasplantar, notificarRegar: notificarRegar, notificarPoda: notificarPoda, notificarTrasplantar: notificarTrasplantar)
                let urlString = "https://huerto.herokuapp.com/cultivos?id=" + self.cultivoUsuario.idCultivo;
                //Creación de la url
                let url = URL(string: urlString);
                //Creación de la peticion get al servicio web
                let request = NSMutableURLRequest(url: url!);
                    request.httpMethod = "GET";
                //Lanzamiento de la petición al servicio web
                let task = URLSession.shared.dataTask(with: url!){
                        (data,response, error ) in
                    if(error == nil){
                         //Obtención de la respuesta en formato json
                        let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        let result = json as! NSMutableDictionary
                        //Obtención del registro cultivo en formato json, tras lo cual se trata y se rellena con el el objteo self.cultivo
                        let cultivosJson = result.object(forKey: "cultivo") as! NSArray
                        var i = 0
                        repeat{
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
                                self.cultivo = cultivo
                            //Desde un hilo diferente al principal accedo a miCultivo
                            DispatchQueue.main.async {
                                self.performSegue (withIdentifier: "miCultivo", sender: self)
                            }
                            i = i + 1;
                        }while(i < cultivosJson.count)
                    }
                }
                    task.resume()
                
            }
        }
        task.resume()
    }
}
