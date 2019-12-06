//
//  JobDetailViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class JobDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var postingUserIDLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var deleteJobBarButton: UIBarButtonItem!

    var job: Job!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if job == nil {
            job = Job()
        }
        updateUserInterface()
        if Auth.auth().currentUser?.email == postingUserIDLabel.text {
            deleteJobBarButton.isEnabled = true
        } else {
            deleteJobBarButton.isEnabled = false
        }
    }
    
    func configurMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([job.postingUserID])
        mailComposerVC.setSubject("EAGLE EXCHANGE: YOUR JOB HAS BEEN ACCEPTED")
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func updateUserInterface() {
        jobTitleLabel.text = job.jobTitle
        postingUserIDLabel.text = job.postingUserID
        jobDescriptionTextView.text = job.jobDescription
        paymentMethodLabel.text = job.paymentMethod
    }
    
    @IBAction func contactBarButtonPressed(_ sender: UIBarButtonItem) {
        let mailComposeViewController = configurMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
       
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func delteJobBarButtonPressed(_ sender: UIBarButtonItem) {
        job.deleteData(job: job) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("delte unsuccessful")
            }
        }
    }
    
}



