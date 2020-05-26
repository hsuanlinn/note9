//
//  Note.swift
//  NoteApp_09
//
//  Created by 林旻萱 on 2020/5/12.
//  Copyright © 2020 Hsuan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Note : NSManagedObject {
//class Note : Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.noteID == rhs.noteID
    }
    
    @NSManaged var noteID: String
    @NSManaged var text: String?
    //var image: UIImage?
    @NSManaged var imageName : String?
    
    override func awakeFromInsert() {
    //init() {
        self.noteID = UUID().uuidString
    }
    
    func image() -> UIImage? {
        
        if let fileName = self.imageName {
        let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
        let documentUrl = homeUrl.appendingPathComponent("Documents")
        let fileUrl = documentUrl.appendingPathComponent(fileName)
            return UIImage(contentsOfFile: fileUrl.path)
        }
        
        return nil
    }
    
    func thumbnailImage() -> UIImage?{
        if let image =  self.image() {
            
            let thumbnailSize = CGSize(width:50, height: 50);
            let scale = UIScreen.main.scale
           
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
            
            let widthRatio = thumbnailSize.width / image.size.width;
            let heightRadio = thumbnailSize.height / image.size.height;
            
            let ratio = max(widthRatio,heightRadio);
            
            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);

            
           let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
            circlePath.addClip()

            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
                width: imageSize.width,height: imageSize.height))
            
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
         
            UIGraphicsEndImageContext();
            return smallImage
        }else{
            return nil;
        }
    }
    
}
