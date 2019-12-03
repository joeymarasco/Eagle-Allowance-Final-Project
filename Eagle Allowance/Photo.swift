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
        let postedBy = Auth.auth().currentUser?.email ?? "Unknown"
        self.init(image: UIImage(), postedBy: postedBy, documentUUID: "")
    }
    
    func saveData(job: Job, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        // convert photo.image to a Data type so it can be saved by Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("*** ERROR: couuld not convert image to data format")
            return completed(false)
        }
        documentUUID = UUID().uuidString
        let storageRef = storage.reference().child(job.documentID).child(self.documentUUID)
        let uploadTask = storageRef.putData(photoData)
        
        uploadTask.observe(.success) { (snapshot) in
            let dataToSave = self.dictionary
            let ref = db.collection("jobs").document(job.documentID).collection("photos").document(self.documentUUID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: error creating document")
                } else {
                    print("created document with id ")
                }
            }
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("ERROR: upload task for files failed ")
            }
            return completed(false)
        }
    }
    
    
    
    
    
}
