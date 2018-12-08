//
//  ViewControllerAlta.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 02/12/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class ViewControllerAlta: UIViewController , UITextFieldDelegate{
    
    //Variables de pantalla
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var contrasena: UITextField!
    @IBOutlet weak var repetirContrasena: UITextField!
    @IBOutlet weak var darAlta: BotonAplicacion!
    //Objecto usuario proveniente de la pantalla anterior
    var usuarioWeb : Usuario!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Carga de strings en funcion del idioma
        darAlta.setTitle(NSLocalizedString("Dar de alta", comment: ""), for: .normal)
        nombre.placeholder = NSLocalizedString("Nombre", comment: "")
        email.placeholder = NSLocalizedString("Email", comment: "")
        contrasena.placeholder = NSLocalizedString("Contrasena", comment: "")
        repetirContrasena.placeholder = NSLocalizedString("Repetir contrasena", comment: "")
        //Obtención del delegado
        nombre.delegate = self
        email.delegate = self
        contrasena.delegate = self
        repetirContrasena.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*En función del campo de texto que acabe de ser rellenado es redirijido al siguiente
         campo o a comprobar la contraseña
         */
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
        //Al pulsar el botón dar de alta se va a comprobar la contraseña
        compruebaContrasena()
    }
    

    func compruebaContrasena(){
        //Se comprueba que la contraseña de los dos campos sea la misa en caso contrario se muestra un alert con el error
        if(contrasena.text == repetirContrasena.text){
            //Se comprueba ninguno de los campos este vacío en caso contrario se muestra un alert con el error
            if((nombre.text != nil) && (email.text != nil) && (contrasena.text != nil)){
                //Si todos los campos estan rellenados correctamente se realiza el ata
                alta()
                //Tras realizar el alta se visualiza la pantalla de nuevo vacía
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
        //Creación de la url
        let urlString = "https://huerto.herokuapp.com/usuarios";
        let url = URL(string: urlString);
        var request = URLRequest(url: url!);
        //Al ser un método POST se debe inicializar con los valores correspondientes el objeto URLRequest
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "nombre=" + nombre.text! + "&email=" + email.text! +
            "&contrasena=" + contrasena.text!
        //Envio en la request del string que contiene los datos a guardar
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            if(error == nil){
                //Obtención de json con la respuesta del servicio web
                let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let result = json as! NSMutableDictionary
                //Si el servicio web no devuelve ningún usuario pero da una respuesta ok se debe a que el email esta repetido, lo cual se le indica al usuario en caso contrario se le indica de que el alta se ha realizado correctamente
                if(result.object(forKey: "usuario") == nil){
                    self.muestraAlert(titulo: "Error", texto: "Email repetido")
                }else{
                    self.muestraAlert(titulo: "Informacion", texto: "Alta ok")
                }
            }else{
                //Si no se ha podido realizar el alta se muestra un alert para indicárselo al usuario
                self.muestraAlert(titulo: "Error", texto: "Alta erronea")
            }
        }
        
        task.resume()
    }
    
    
    func muestraAlert(titulo:String, texto:String){
        //Mostramos un alert con el título y texto que se pase a la función, dicho alert se muestra fuera del hilo principal ya que es invocado desde una consulta / guardado a un servicio web
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: NSLocalizedString(titulo, comment: ""), message: NSLocalizedString(texto, comment: ""), preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
