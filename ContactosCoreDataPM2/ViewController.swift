//
//  ViewController.swift
//  ContactosCoreDataPM2
//
//  Created by Ramiro y Jennifer on 17/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var nombreEnviar: String?
    var telefonoEnviar: String?
    var direccionEnviar: String?
    var indiceEnviar: Int?
    var imagenEnviar: UIImage?
    
    var contactos = [Contacto]()
    
    //Conexion al contexto de la BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tablaContactos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Leer los datod de la bd de coredata
        cargarCoreData()
        tablaContactos.reloadData()
        
        tablaContactos.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tablaContactos.reloadData()
    }

    @IBAction func agregarContacto(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar", message: "Nuevo contacto", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { [self] (_) in
            
            guard let nombreAlert = alerta.textFields?.first?.text else {return}
            
            guard let telefonoAlert = Int64(alerta.textFields?[1].text ?? "0000000000") else {return}
            
            guard let direccionAlert = alerta.textFields?.last?.text else {return}
            
            let imagenTemporal = UIImageView(image: #imageLiteral(resourceName: "emoji"))
            
            //Crear el ob para guardar en CoreData
            
            let nuevoContacto = Contacto(context: self.contexto)
            nuevoContacto.nombre = nombreAlert
            nuevoContacto.telefono = telefonoAlert
            nuevoContacto.direccion = direccionAlert
            nuevoContacto.imagen = imagenTemporal.image?.pngData()
            
            self.contactos.append(nuevoContacto)
            
            self.guardarContacto()
            
            self.tablaContactos.reloadData()
            print(self.contactos)
        }
        alerta.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
            nombreTF.autocapitalizationType = .words
            nombreTF.textAlignment = .center
        }
        alerta.addTextField { (telefonoTF) in
            telefonoTF.placeholder = "Telefóno"
            telefonoTF.keyboardType = .numberPad
            telefonoTF.textAlignment = .center
        }
        alerta.addTextField { (direccionTF) in
            direccionTF.placeholder = "Dirección"
            direccionTF.autocapitalizationType = .words
            direccionTF.textAlignment = .center
        }
        alerta.addAction(accionAceptar)
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(accionCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    //guardar
    func guardarContacto(){
        do {
            try contexto.save()
            print("Se guardo correctamente")
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
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
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        cell.nombreLabel.text = contactos[indexPath.row].nombre
        cell.telefonoLabel.text = " 📞 \(contactos[indexPath.row].telefono ?? 00000)"
        cell.fotoImageView.image = UIImage(data: contactos[indexPath.row].imagen!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaContactos.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        telefonoEnviar = "\(contactos[indexPath.row].telefono ?? 00000)"
        direccionEnviar = contactos[indexPath.row].direccion
        indiceEnviar = indexPath.row
        performSegue(withIdentifier: "editar", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionBorrar = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Borrar")
            //eliminar de CoreData
            self.contexto.delete(self.contactos[indexPath.row])
            //eliminar de la UI
            self.contactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tablaContactos.reloadData()
        }
        accionBorrar.image = UIImage(named: "borrar.png")
        accionBorrar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionllamada = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Llamada")
        }
        accionllamada.image = UIImage(named: "llamada.png")
        accionllamada.backgroundColor = .blue
        
        let accionMensaje = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("Mensaje")
        }
        accionMensaje.image = UIImage(named: "mensaje.png")
        accionMensaje.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [accionllamada, accionMensaje])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            let objEditar = segue.destination as! EditarViewController
            objEditar.recibirnombre = nombreEnviar
            objEditar.recibirnumero = telefonoEnviar
            objEditar.recibirdireccion = direccionEnviar
            objEditar.indice = indiceEnviar
            
        }
    }
    
    
}
