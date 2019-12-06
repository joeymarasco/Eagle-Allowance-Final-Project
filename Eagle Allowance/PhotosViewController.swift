//
//  PhotosViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/2/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var jobPhotoCollectionView: UICollectionView!
    
    
    var photos: Photos!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = Photos()
        jobPhotoCollectionView.delegate = self
        jobPhotoCollectionView.dataSource = self
    }
    

    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = jobPhotoCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! JobPhotoCollectionViewCell
        
        cell.photo = photos.photoArray[indexPath.row]
        return cell
    }
    
    
}
