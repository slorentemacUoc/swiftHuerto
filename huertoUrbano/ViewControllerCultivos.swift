//
//  ViewControllerCultivos.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerCultivos: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tablaCultivosDisponibles: UITableView!
    var usuario : Usuario!
    var cultivos:Array<Cultivo>!
    var cultivo: Cultivo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablaCultivosDisponibles.dataSource = self
        tablaCultivosDisponibles.delegate = self

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultivos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cultivo", for: indexPath) as! TableViewCellCultivo
        print(self.cultivos[indexPath.row])
        let idioma = Locale.current.languageCode
        let texto = self.cultivos[indexPath.row].nombre.split(separator: ";")
        if(idioma == "en"){
            cell.nombreCultivo.text = String.init(texto[1])
        }else{
            cell.nombreCultivo.text = String.init(texto[0])
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cultivo = cultivos[indexPath.row]
        self.performSegue (withIdentifier: "verCultivo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "verCultivo"){
            let cultivo = segue.destination as! ViewControllerCulDisponible
            cultivo.usuario = self.usuario;
            cultivo.cultivo = self.cultivo;
        }
    }
}