//
//  Job.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation

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
}
