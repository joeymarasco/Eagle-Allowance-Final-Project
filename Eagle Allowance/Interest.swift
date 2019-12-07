//
//  Interest.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/5/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase

class Interest {
    var interestID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["interestID": interestID, "documentID": documentID]
    }
    
    init(interestID: String, documentID: String) {
        self.interestID = interestID
        self.documentID = documentID
    }
    
    convenience init() {
        let currentEmail = Auth.auth().currentUser?.email ?? "Unknown Email"
        self.init(interestID: currentEmail, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let interestID = dictionary["interestID"] as! String
        let documentID = dictionary["documentID"] as! String
        self.init(interestID: interestID, documentID: documentID)
    }
    
    func saveData(job: Job, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("jobs").document(job.documentID).collection("interests").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: error uploading interest document \(self.interestID) to job \(job.documentID). \(error.localizedDescription)")
                    completed(false)
                    
                } else {
                    print("interest document \(self.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("jobs").document(job.documentID).collection("interests").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("ERROR: error creating new document \(self.interestID). \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document uploaded successfully \(self.interestID)")
                    completed(true)
                }
            }
        }
    }
    
    func deleteData(job: Job, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("jobs").document(job.documentID).collection("interests").document(self.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
               completed(true)
            }
        }
    }
}
