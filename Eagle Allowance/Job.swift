//
//  Job.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase

class Job {
    var jobTitle: String
    var jobDescription: String
    var paymentMethod: String
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["jobTitle": jobTitle , "jobDescription": jobDescription, "paymentMethod": paymentMethod, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(jobTitle: String, jobDescription: String, paymentMethod: String, postingUserID: String, documentID: String) {
        self.jobTitle = jobTitle
        self.jobDescription = jobDescription
        self.paymentMethod = paymentMethod
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(jobTitle: "" , jobDescription: "", paymentMethod: "", postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String:Any]) {
        let jobTitle = dictionary["jobTitle"] as! String? ?? ""
        let jobDescription = dictionary["jobDescription"] as! String? ?? ""
        let paymentMethod = dictionary["paymentMethod"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(jobTitle: jobTitle, jobDescription: jobDescription, paymentMethod: paymentMethod, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // grab user id
        guard let postingUserID = (Auth.auth().currentUser?.email) else {
            print("### ERROR: Could not save data because we dont have a valid user id")
            return completion(false)
        }
        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("jobs").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("Error: updating document \(self.documentID)")
                    completion(false)
                } else {
                    print("Document updated with ref id \(ref.documentID)")
                    completion(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("jobs").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Error: creating new document \(self.documentID)")
                    completion(false)
                } else {
                    print("document created with ref id \(ref?.documentID ?? "unknown")")
                    completion(true)
                }
                
            }
        }
        
    }
    
    func deleteData(job: Job, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("jobs").document(job.documentID).delete() { error in
            if let error = error {
                print("😡 ERROR: deleting review documentID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            } else {
               completed(true)
            }
        }
    }
}
