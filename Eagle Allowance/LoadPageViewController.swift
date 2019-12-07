//
//  LoadPageViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 12/2/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit

class LoadPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "LoadPressed", sender: nil)
    }
}
