//
//  ViewControllerCultivos.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 27/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerCultivos: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    //Variable de pantalla
    @IBOutlet weak var tablaCultivosDisponibles: UITableView!
    //Objetos provenientes de la pantalla anterior, el usuario con sus características y las diferentes listas de los cultivos con sus ordenaciones
    var usuario : Usuario!
    var cultivos:Array<Cultivo>!
    var cultivosLocalizacion:Array<Cultivo>!
    var cultivosTemporada:Array<Cultivo>!
    var cultivosAlfabetico:Array<Cultivo>!
    var cultivo: Cultivo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Obtención del delegado y del dataSource
        tablaCultivosDisponibles.dataSource = self;
        tablaCultivosDisponibles.delegate = self;
        //Creación de los botones de la barra de navegación para que el usuario pueda ordenar la lista en función de la localización, la temporada y alfebéticamente
        let derechaLocalizacion: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Localizacion", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.localizacion))
        let derechaTemporada: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Temporada", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.temporada))
        let derechaAlfabetico: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Alfabetico", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.alfabetico))
        //Si no tenemos la fila de localización es que el usuario no permite acceder a su localización por lo tando no se debe mostrar dicho botón
        if(cultivosLocalizacion != nil){
            self.navigationItem.setRightBarButtonItems([derechaLocalizacion,derechaTemporada,derechaAlfabetico], animated: true)
        }else{
            self.navigationItem.setRightBarButtonItems([derechaTemporada,derechaAlfabetico], animated: true)
        }
    }
    
    
  @objc  func localizacion() {
        //Si el usuario permite acceder a su localización se muestra la lista de cultivos ordenada por dicha localización
        if(cultivosLocalizacion != nil){
            cultivos = cultivosLocalizacion
            tablaCultivosDisponibles.reloadData()
        }
    }
    
    @objc func temporada() {
        //Se muestra la lista de cultivos ordenados por la temporada
        cultivos = cultivosTemporada
        tablaCultivosDisponibles.reloadData()
    }
    
  @objc  func alfabetico() {
        //Se muestra la lista de cultivos ordenados alfabéticamentes
        cultivos = cultivosAlfabetico
        tablaCultivosDisponibles.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //La tabla sólo tiene una sección
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Se devuelve el tamaño de la lista
        return cultivos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Carga de la celda del tipo TableViewCellCultivo
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cultivo", for: indexPath) as! TableViewCellCultivo
        //En función del idioma del sistema se muestra el texto de la celda en un idioma u otro
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
        //Carga del cultivo seleccionado en cultivo para pasarlo a la pantalla "Cultivos disponibles"
        cultivo = cultivos[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue (withIdentifier: "verCultivo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "verCultivo"){
            //Carga de objetos necesarios para la pantalla "Cultivo disponible"
            let cultivo = segue.destination as! ViewControllerCulDisponible
            cultivo.usuario = self.usuario;
            cultivo.cultivo = self.cultivo;
        }
    }
}

