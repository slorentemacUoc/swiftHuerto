//
//  ViewControllerAlta.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 02/12/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerAlta: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contrasena: UITextField!
    @IBOutlet weak var repetirContrasena: UITextField!
    @IBOutlet weak var darAlta: BotonAplicacion!
    var usuarioWeb : Usuario!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darAlta.setTitle(NSLocalizedString("Dar de alta", comment: ""), for: .normal)
        nombre.placeholder = NSLocalizedString("Nombre", comment: "")
        email.placeholder = NSLocalizedString("Email", comment: "")
        contrasena.placeholder = NSLocalizedString("Contrasena", comment: "")
        repetirContrasena.placeholder = NSLocalizedString("Repetir contrasena", comment: "")
        nombre.delegate = self
        email.delegate = self
        contrasena.delegate = self
        repetirContrasena.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nombre:
            email.becomeFirstResponder()
        case email:
            contrasena.becomeFirstResponder()
        case contrasena:
            repetirContrasena.becomeFirstResponder()
        case repetirContrasena:
            view.endEditing(true)
            compruebaContrasena()
        default:
            view.endEditing(true)
        }
        return false
    }
    

    @IBAction func irDarAlta(_ sender: Any) {
        compruebaContrasena()
            
    }
    

    func compruebaContrasena(){
        if(contrasena.text == repetirContrasena.text){
            if((nombre.text != nil) && (email.text != nil) && (contrasena.text != nil)){
                alta()
                self.nombre.text = ""
                self.email.text = ""
                self.contrasena.text = ""
                self.repetirContrasena.text = ""
                self.nombre.becomeFirstResponder()
            }else{
                muestraAlert(titulo: "Error", texto: "Debe rellenar todos los campos")
            }
        }else{
            muestraAlert(titulo: "Error", texto: "Contrasena coincidir")
        }
    }
    
    func alta(){
        let urlString = "https://huerto.herokuapp.com/usuarios";
        //Creo la url
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "nombre=" + nombre.text! + "&email=" + email.text! +
            "&contrasena=" + contrasena.text!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                if(result.object(forKey: "usuario") == nil){
                    self.muestraAlert(titulo: "Error", texto: "Email repetido")
                }else{
                    
                    //Obtengo los usuarios que me devuelve el servicio web
                    //let usuarioJson = result.object(forKey: "usuario") as! NSMutableDictionary
                       /* let nombre = usuarioJson["nombre"] as! String
                        let id = usuarioJson["_id"] as! String
                        let contrasena = usuarioJson["contrasena"] as! String
                        let email = usuarioJson["email"] as! String
                        let permiteGps = usuarioJson["permiteGps"] as! Bool
                        let permiteNotificaciones = usuarioJson["permiteNotificaciones"] as! Bool
                        let permiteSonido = usuarioJson["permiteSonido"] as! Bool*/
                    self.muestraAlert(titulo: "Informacion", texto: "Alta ok")
                }
            }else{
                self.muestraAlert(titulo: "Error", texto: "Alta erronea")
            }
        }
        
        task.resume()
    }
    
    
    func muestraAlert(titulo:String, texto:String){
        DispatchQueue.main.async {
            //Si no ha devuelto ningún usuario es porque no esta dado de alta por lo tanto muestro un mensaje de error
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
