//
//  Interests.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/5/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase


class Interests {
    var interestArray = [Interest]()
    var db: Firestore!

    init() {
        db = Firestore.firestore()
    }
    
    func loadData(job: Job, completed: @escaping () -> ())  {
        db.collection("jobs").document(job.documentID).collection("interests").addSnapshotListener { (querySnapshot, error) in
                guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.interestArray = []
            // there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents {
                let interest = Interest(dictionary: document.data())
                interest.documentID = document.documentID
                self.interestArray.append(interest)
            }
            completed()
        }
    }
}
