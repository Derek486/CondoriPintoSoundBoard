//
//  ViewController.swift
//  CondoriPintoSoundBoard
//
//  Created by Neals Paye Aguilar on 13/05/24.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grabaciones.count
    }
    

    @IBOutlet weak var tablaGrabaciones: UITableView!
    var grabaciones: [Grabacion] = []
    var reproducirAudio: AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaGrabaciones.delegate = self
        tablaGrabaciones.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let grabacion = grabaciones[indexPath.row]
            let context = getContext()
            context.delete(grabacion)
            guardarContexto()
            do {
                grabaciones = try context.fetch(Grabacion.fetchRequest())
                tablaGrabaciones.reloadData()
            } catch {}
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do {
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            reproducirAudio?.play()
        } catch {}
        tablaGrabaciones.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablaGrabaciones.dequeueReusableCell(withIdentifier: "cellRecord", for: indexPath)
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        do {
            let audio = try AVAudioPlayer(data: grabacion.audio! as Data)
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .short
            cell.detailTextLabel?.text = "Duracion: \(formatter.string(from: audio.duration)!)"
        } catch {}
        return cell
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func guardarContexto() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = getContext()
        do {
            grabaciones = try context.fetch(Grabacion.fetchRequest())
            tablaGrabaciones.reloadData()
        } catch {}
    }


}

