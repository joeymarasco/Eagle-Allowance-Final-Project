//
//  Jobs.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase

class Jobs {
    var jobArray = [Job]()
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
        
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("jobs").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.jobArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
              // You'll have to be sure you've created an initializer in the singular class (Spot, below) that acepts a dictionary.
                let job = Job(dictionary: document.data())
                job.documentID = document.documentID
                self.jobArray.append(job)
            }
            completed()
        }
    }
}
