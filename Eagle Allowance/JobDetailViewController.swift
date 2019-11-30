//
//  JobDetailViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit
import MessageUI

class JobDetailViewController: UIViewController {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var postingUserIDLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    

    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserInterface()
    }
    
    func updateUserInterface() {
        jobTitleLabel.text = job.jobTitle
        postingUserIDLabel.text = job.postingUserID
        jobDescriptionTextView.text = job.jobDescription
        paymentMethodLabel.text = job.paymentMethod
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            // show alert saying you cannot email
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = (self as! MFMailComposeViewControllerDelegate)
        // set recipients and such here
        present(composer, animated: true)
    }


    @IBAction func contactBarButtonPressed(_ sender: UIBarButtonItem) {
        showMailComposer()
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.popViewController(animated: true)
    }
}
