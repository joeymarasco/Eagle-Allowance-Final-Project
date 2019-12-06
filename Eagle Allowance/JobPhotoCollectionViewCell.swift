//
//  JobPhotoCollectionViewCell.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/3/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit

class JobPhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellPhotoimageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            cellPhotoimageView.image = photo.image
        }
    }
    
}
