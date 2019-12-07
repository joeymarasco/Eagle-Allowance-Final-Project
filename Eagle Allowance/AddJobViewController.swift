//
//  AddJobViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit
import Firebase

class AddJobViewController: UIViewController {
    // MARK: IB OUTLETS
    @IBOutlet weak var jobTitleField: UITextField!
    @IBOutlet weak var jobDescriptionField: UITextView!
    @IBOutlet weak var paymentMethodField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    // MARK: VAIRABLES
    var job: Job!
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        if job == nil {
            job = Job()
        }
        // save bar should be disabled until the text is input
        saveBarButton.isEnabled = false
    }
    
    func checkEnableSave() {
        if jobTitleField.text != "" && jobDescriptionField.text != "" && paymentMethodField.text != "" {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: IB ACTIONS
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        job.jobTitle = jobTitleField.text!
        job.jobDescription = jobDescriptionField.text!
        job.paymentMethod = paymentMethodField.text!
        job.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("### ERROR: couldn't leave view controller because data wasnt saved")
            }
    }
}
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func jobTitleChanged(_ sender: UITextField) {
        checkEnableSave()
    }

    @IBAction func paymentMethodChanged(_ sender: Any) {
        checkEnableSave()
    }
}



