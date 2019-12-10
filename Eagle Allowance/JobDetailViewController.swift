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
    // MARK: IB OUTLETS
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var postingUserIDLabel: UILabel!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var deleteJobBarButton: UIBarButtonItem!
    @IBOutlet weak var interestTableView: UITableView!
    @IBOutlet weak var interestBarButton: UIBarButtonItem!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var interestTableViewLabel: UILabel!
    
    // MARK: VARIABLES
    var job: Job!
    var interest: Interest!
    var interests: Interests!
    
    // MARK: FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        if job == nil {
            job = Job()
        }
        if interest == nil {
            interest = Interest()
        }
        interests = Interests()
        updateUserInterface()
        // check to see if this is their own post
        if Auth.auth().currentUser?.email == postingUserIDLabel.text {
            // this is their own
            deleteJobBarButton.isEnabled = true
            interestTableView.isHidden = false
            interestTableViewLabel.text = "Interests:"
            interestBarButton.isEnabled = false
        } else {
            // somebody else's post
            deleteJobBarButton.isEnabled = false
            interestTableView.isHidden = true
            interestTableViewLabel.text = ""
            //interestBarButton.isEnabled = true
        }
        interestTableView.delegate = self
        interestTableView.dataSource = self
        
        // check to see if we should edit the interest section
        let email = Auth.auth().currentUser?.email
        for index in 0..<interests.interestArray.count {
            if email == interests.interestArray[index].interestID {
                interestLabel.text = "Interested!"
                interestLabel.textColor = UIColor.green
                interestBarButton.isEnabled = false
            } else {
                interestLabel.text = ""
                interestBarButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        interests.loadData(job: job) {
            self.interestTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let email = Auth.auth().currentUser?.email
        for index in 0..<interests.interestArray.count {
            if email == interests.interestArray[index].interestID {
                interestLabel.text = "Interested!"
                interestLabel.textColor = UIColor.green
                interestBarButton.isEnabled = false
            } else {
                interestLabel.text = ""
                interestBarButton.isEnabled = true
            }
        }
        
        if Auth.auth().currentUser?.email == postingUserIDLabel.text {
            deleteJobBarButton.isEnabled = true
            interestTableView.isHidden = false
            interestTableViewLabel.text = "Interests:"
            interestBarButton.isEnabled = false
        } else {
            deleteJobBarButton.isEnabled = false
            interestTableView.isHidden = true
            interestTableViewLabel.text = ""
            //interestBarButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMail" {
            let destination = segue.destination as! InterestMailViewController
            let selectedIndexPath = interestTableView.indexPathForSelectedRow
            destination.interest = interests.interestArray[selectedIndexPath!.row]
        } else {
            if let selectedIndexPath = interestTableView.indexPathForSelectedRow {
                interestTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
        }
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

    // MARK: IB ACTIONS
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteJobBarButtonPressed(_ sender: UIBarButtonItem) {
        job.deleteData(job: job) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("delete unsuccessful")
            }
        }
    }
    
    @IBAction func interestButtonPressed(_ sender: UIBarButtonItem) {
        // add interest to the interest collection
        interest.saveData(job: job) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
                self.interestBarButton.isEnabled = false
        } else {
                print("ERROR: couldnt leave view controller because it was not saved")
            }
        }
        // change the interest button
        interestBarButton.isEnabled = false
    }
}

// MARK: EXTENSIONS 
extension JobDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.interestArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interestTableView.dequeueReusableCell(withIdentifier: "InterestCell")
        cell?.textLabel?.text = interests.interestArray[indexPath.row].interestID
        cell?.textLabel?.textColor = UIColor.init(hue: 5.0, saturation: 0.83, brightness: 0.37, alpha: 0.95)
        return cell!
    }
}



