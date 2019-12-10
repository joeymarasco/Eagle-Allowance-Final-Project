//
//  LoadPageViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/2/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit


class LoadPageViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImage()
        
    }
    
    func animateImage() {
        let bounds = self.logoImageView.bounds
        let shrinkValue: CGFloat = 60
        //let expandValue: CGFloat = 100
        
        self.logoImageView.bounds = CGRect.init(x: self.logoImageView.bounds.origin.x, y: self.logoImageView.bounds.origin.y, width: CGFloat(self.logoImageView.bounds.size.width - shrinkValue), height: CGFloat(self.logoImageView.bounds.size.height - shrinkValue))
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {self.logoImageView.bounds = bounds}, completion: nil)
        
        self.logoImageView.bounds = CGRect.init(x: self.logoImageView.bounds.origin.x, y: self.logoImageView.bounds.origin.y, width: CGFloat(self.logoImageView.bounds.size.width + shrinkValue), height: CGFloat(self.logoImageView.bounds.size.height + shrinkValue))
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {self.logoImageView.bounds = bounds}, completion: nil)
    
    }
    
    @IBAction func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "LoadPressed", sender: nil)
    }
}
