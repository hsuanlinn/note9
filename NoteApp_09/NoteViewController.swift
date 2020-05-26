//
//  NoteViewController.swift
//  NoteApp_09
//
//  Created by 林旻萱 on 2020/5/12.
//  Copyright © 2020 Hsuan. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {
    func didFinishUpdate(note: Note)
}

class NoteViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    var currentNote : Note!
    var delegate: NoteViewControllerDelegate?
    var isNewImage: Bool = false
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = self.currentNote.text
        self.imageView.image = self.currentNote.image()
        
    }
    
    @IBAction func done(_ sender: Any) {
        
        self.currentNote.text = self.textView.text
        //self.currentNote.image = self.imageView.image
        
        if isNewImage {
            let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
            let documentUrl = homeUrl.appendingPathComponent("Documents")
            
            let fileName = "\(self.currentNote.noteID).jpg"
            let fileUrl = documentUrl.appendingPathComponent(fileName)
            
            if let imageData = self.imageView.image?.jpegData(compressionQuality: 1){
                do{
                    try imageData.write(to: fileUrl, options: .atomicWrite)
                    self.currentNote.imageName = fileName
                }catch{
                    print("error saving photo \(error)")
                }
                
            }
        }
        
        
        self.delegate?.didFinishUpdate(note: self.currentNote)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func camera(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .savedPhotosAlbum
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    //MARK: -UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.imageView.image = image
        self.isNewImage = true
        self.dismiss(animated: true, completion: nil)
    }
}
