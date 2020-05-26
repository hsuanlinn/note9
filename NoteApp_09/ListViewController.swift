//
//  ListViewController.swift
//  NoteApp_09
//
//  Created by 林旻萱 on 2020/5/12.
//  Copyright © 2020 Hsuan. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NoteViewControllerDelegate {
    
    var data : [Note] = []
    
    @IBOutlet weak var tableView: UITableView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadFromCoreData()
        /* for i in 0..<10 {
            let note = Note()
            note.text = "Note \(i)"
            self.data.append(note)
        }   */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(editing, animated: true)
    }

    @IBAction func addNote(_ sender: Any) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        //let note = Note()
        let note = Note(context: moc)
        note.text = "New Note"
        self.data.insert(note, at: 0)
        self.saveToCoreData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let note = self.data.remove(at: sourceIndexPath.row)
        self.data.insert(note, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = self.data.remove(at: indexPath.row)
            //self.data.remove(at: indexPath.row)
            let moc = CoreDataHelper.shared.managedObjectContext()
            moc.performAndWait {
                moc.delete(data)
            }
            self.saveToCoreData()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note = self.data[indexPath.row]
        cell.textLabel?.text = note.text
        cell.imageView?.image = note.thumbnailImage()
        return cell
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteSegue" {
            let noteVC = segue.destination as! NoteViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let note = self.data[indexPath.row]
                noteVC.currentNote = note
                noteVC.delegate = self
            }
        }
    }
    
    func didFinishUpdate(note: Note) {
        if let position = self.data.firstIndex(of:note) {
            self.saveToCoreData()
            let indexPath = IndexPath(row: position, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: -CoreDate
    
    func loadFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        
        let sort = NSSortDescriptor(key: "text", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        moc.performAndWait {
            do{
                let result = try moc.fetch(fetchRequest)
                self.data = result
            } catch {
                print("error while fetching from db \(error)")
                self.data = []
            }
        }
    }
    
    func saveToCoreData() {
        CoreDataHelper.shared.saveContext()
    }
    
}
