//
//  StorageService.swift
//  TaskIt
//
//  Created by Robert Wais on 7/31/18.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

struct StorageService {
    
    
    static func uploadImage(_ image: UIImage, reference: StorageReference,completion: @escaping (URL?)->()){
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            print("Couldn't compress")
            completion(nil)
            return
        }
        
        reference.putData(imageData, metadata: nil) { (metaData, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
               return completion(nil)
            }
            reference.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Error: downloading URL")
                  return completion(nil)
                }
                completion(url)
            })
            
            
        }
    }
    
    static func getImage(completion:@escaping (UIImage?)->()){
        let storage = Storage.storage()
        
        let db = Database.database().reference().child("company").child(TaskUser.current.companyID).child("imageURL")
        print("Current id: \(TaskUser.current.companyID)")
        db.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value != nil{
                guard let imageURL = snapshot.value as? String else {
                    print("Huge error")
                    return completion(nil)
                }
                let ref = storage.reference(forURL: imageURL)
                ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if error != nil {
                        completion(nil)
                    }else{
                        let image = UIImage(data: data!)
                        completion(image)
                    }
                }
            }else{
                completion(nil)
            }
        }
    }
}
