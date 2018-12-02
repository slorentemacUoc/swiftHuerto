//
//  ViewController.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 25/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btInicio: UIButton!
    @IBOutlet weak var txUsuario: UITextField!
    @IBOutlet weak var txContrasena: UITextField!
    @IBOutlet weak var btRegistrar: UIButton!
    
    var usuarioWeb : Usuario!;
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        super.viewDidLoad()
        //Cargo strings en funcion del idioma
        btInicio.setTitle(NSLocalizedString("Iniciar sesion", comment: ""), for: .normal)
        txUsuario.placeholder = NSLocalizedString("Usuario", comment: "")
        txContrasena.placeholder = NSLocalizedString("Contrasena", comment: "")
        btRegistrar.setTitle(NSLocalizedString("Registrarse", comment: ""), for: .normal)
        
        //Obtengo el delegado
        txUsuario.delegate = self
        txContrasena.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case txUsuario:
            txContrasena.becomeFirstResponder()
        case txContrasena:
            view.endEditing(true)
            intentaIniciarSesion()
        default:
            view.endEditing(true)
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToMain"){
            let menu = segue.destination as! ViewControllerMenu
            menu.usuario = usuarioWeb;
        }
    }
    
    
    @IBAction func irAlta(_ sender: Any) {
        self.performSegue (withIdentifier: "alta", sender: self)
    }
    
    @IBAction func IniciarSesion(_ sender: Any) {
        intentaIniciarSesion()
    }
    
    func intentaIniciarSesion(){
        //Obtengo los valores del usuario y la contraseña
        let usuario = txUsuario.text! as String
        let contrasena = txContrasena.text! as String
        
        //Formo la string del url del servicio web
        let urlString = "https://huerto.herokuapp.com/usuarios?email=" + usuario + "&contrasena=" + contrasena;
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
                    DispatchQueue.main.async {
                        self.usuarioWeb = Usuario.init(id: id, contrasena: contrasena, email: email, nombre: nombre, permiteGps: permiteGps, permiteNotificaciones: permiteNotificaciones, permiteSonido: permiteSonido)
                        self.performSegue (withIdentifier: "segueToMain", sender: self)
                    }
                }else{
                    //El alert lo debe mostrar de forma asincrona
                    DispatchQueue.main.async {
                        //Si no ha devuelto ningún usuario es porque no esta dado de alta por lo tanto muestro un mensaje de error
                        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Usuario no valido", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    
}

