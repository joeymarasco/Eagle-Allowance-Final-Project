//
//  Photos.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/3/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import Foundation
import Firebase

class Photos {
    
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
}
