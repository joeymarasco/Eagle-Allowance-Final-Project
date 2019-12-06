//
//  Photo.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/3/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase

class Photo {

    var image: UIImage!
    var postedBy: String!
    var documentUUID: String!
    var dictionary: [String: Any] {
        return ["image": image, "postedBy": postedBy, "documentUUID": documentUUID]
    }
    
    init(image: UIImage, postedBy: String, documentUUID: String) {
        self.image = image
        self.postedBy = postedBy
        self.documentUUID = documentUUID
    }
    
    convenience init() {
        let postedBy = Auth.auth().currentUser?.email ?? "current User"
        self.init(image: UIImage(), postedBy: postedBy, documentUUID: "")
    }
    
    convenience init(dictionary: [String:Any]) {
        let image = dictionary["image"] as! UIImage? ?? UIImage()
        let postedBy = dictionary["postedBy"] as! String? ?? ""
        let documentUUID = dictionary["documentUUID"] as! String? ?? ""
        self.init(image: image, postedBy: postedBy, documentUUID: documentUUID )
    }
    
    func saveData(job: Job, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("ERROR: could not convert image to data format")
            return completed(false)
        }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        documentUUID = UUID().uuidString
        let storageRef = storage.reference().child(job.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetadata) { metadata, error in
            guard error == nil else {
                print("Error: unable to upload metadata")
                return 
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("jobs").document(job.documentID).collection("photos").document(self.documentUUID)
            
            // this is where the error occurs i think,
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("%%% ERROR: \(error.localizedDescription), \(self.documentUUID) ")
                    completed(false)
                } else {
                    print("uploaded document")
                    completed(true)
                }
            }
            
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("Error: upload task for \(String(describing: self.documentUUID)) failed in job \(job.documentID)")
            }
            return completed(false)
            
        }
        
    }
    

    
    
}
