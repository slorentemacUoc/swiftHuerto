//
//  ViewControllerMiHuerta.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerMiHuerta: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tablaHuerta: UITableView!
    var usuario : Usuario!
    var miHuerta = [CultivoUsuario]()
    var cultivoUsuario = CultivoUsuario()
    let idioma = Locale.current.languageCode
    var detCultivoUsuario = DetCultivoUsuario()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaHuerta.dataSource = self
        tablaHuerta.delegate = self
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "miCultivo"){
            let cultivo = segue.destination as! ViewControllerDetalle
            cultivo.usuario = self.usuario;
            cultivo.cultivoUsuario = self.cultivoUsuario;
            cultivo.detCultivoUsuario = self.detCultivoUsuario;
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miHuerta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        obtenDetalleCultivoUsuario()
        
    }
    
    func eliminaFila(miCultivo: CultivoUsuario){
        let urlString = "https://huerto.herokuapp.com/cultivoUsuario/" + miCultivo.id;
        print(urlString)
        //Creo la url
        let url = URL(string: urlString);
        //Creo la peticion get al servicio web
        var request = URLRequest(url: url!);
        request.httpMethod = "DELETE";
        //Lanzo la petición
        let sesion = URLSession.shared
        let task = sesion.dataTask(with: request){
            (data,response, error ) in
            if(error == nil){
                let urlStringDet = "https://huerto.herokuapp.com/detCultivoUsuario/" + miCultivo.idCultivoUsuario;
                //Creo la url
                let urlDet = URL(string: urlStringDet);
                //Creo la peticion get al servicio web
                var requestDet = URLRequest(url: urlDet!);
                requestDet.httpMethod = "DELETE";
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
        let urlString = "https://huerto.herokuapp.com/detCultivoUsuario?id=" + cultivoUsuario.idCultivoUsuario;
        //Creo la url
        let url = URL(string: urlString);
        //Creo la peticion get al servicio web
        let request = NSMutableURLRequest(url: url!);
        request.httpMethod = "GET";
        //Lanzo la petición
        
        
        let task = URLSession.shared.dataTask(with: url!){
            (data,response, error ) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Obtengo los usuarios que me devuelve el servicio web
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
                let descCosecha = miCultivoJson["descCosecha"] as! String
                let descSiembra = miCultivoJson["descSiembra"] as! String
                let descTrasplantar = miCultivoJson["descTrasplantar"] as! String
                let descCrecimiento = miCultivoJson["descCrecimiento"] as! String
                DispatchQueue.main.async {
                    self.detCultivoUsuario = DetCultivoUsuario.init(idCultivoUsuario: id, fechaInicio: fecha, cosecha: cosecha, siembra: siembra, crecimiento: crecimiento, trasplantar: trasplantar, notificarRegar: notificarRegar, notificarPoda: notificarPoda, notificarTrasplantar: notificarTrasplantar, descSiembra: descSiembra, descCosecha: descCosecha, descCrecimiento: descCrecimiento, descTrasplantar: descTrasplantar)
                    self.performSegue (withIdentifier: "miCultivo", sender: self)
                }
            }
        }
        task.resume()
    }
}
