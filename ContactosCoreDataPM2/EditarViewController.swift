//
//  EditarViewController.swift
//  ContactosCoreDataPM2
//
//  Created by Ramiro y Jennifer on 17/05/21.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {

    var recibirnombre: String?
    var recibirnumero: String?
    var recibirdireccion: String?
    
    var indice: Int?
    
    var contactos = [Contacto]()
    
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var imagen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cargarCoreData()
        nombreTextField.text = recibirnombre
        telefonoTextField.text = recibirnumero
        direccionTextField.text = recibirdireccion
        imagen.image = UIImage(data: contactos[indice!].imagen!)
        
        //MARK: Agregar gestura a la imagen
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        //agregar la gestura de la imagen
        imagen.addGestureRecognizer(gestura)
        imagen.isUserInteractionEnabled = true
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func clickImagen(gestura: UITapGestureRecognizer){
        print("Cambiar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    //leer
    func cargarCoreData(){
        let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
        do {
            contactos = try contexto.fetch(fetchRequest)
        } catch  {
            print("Error al cargar datos de core Data: \(error.localizedDescription)")
        }
    }
        
    
    @IBAction func tomarFotoButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func guardarButton(_ sender: UIButton) {
        do {
            contactos[indice!].setValue(nombreTextField.text, forKey: "nombre")
            contactos[indice!].setValue(Int64(telefonoTextField.text!), forKey: "telefono")
            contactos[indice!].setValue(direccionTextField.text, forKey: "direccion")
            contactos[indice!].setValue(imagen.image?.pngData(), forKey: "imagen")
            
            try self.contexto.save()
            print("Se actualizo el contexto")
        } catch {
            print("Error al actualizar: \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: Protocolo para la gestura de la imagen y selecionar imagen
extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Que vamos a hacer cuando el usuario selecciona una imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info [UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imagen.image = imagenSeleccionada
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
