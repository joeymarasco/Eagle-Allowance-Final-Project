//
//  ViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var jobTableView: UITableView!
    
    var jobs: Jobs!
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        jobTableView.delegate = self
        jobTableView.dataSource = self
        jobTableView.isHidden = true
        
        jobs = Jobs()
        jobs.jobArray.append(Job(jobTitle: "Clean my kitchen", jobDescription: "my kitchen is super dirty and I need somebody to clean it", paymentMethod: "$10 venmo", postingUserID: "", documentID: ""))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } else {
            jobTableView.isHidden = false
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowJob" {
            let destination = segue.destination as! JobDetailViewController
            let selectedIndexPath = jobTableView.indexPathForSelectedRow
            destination.job = jobs.jobArray[selectedIndexPath!.row]
        } else {
            if let selectedIndexPath = jobTableView.indexPathForSelectedRow {
                jobTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("$$$ successful sign out")
            jobTableView.isHidden = true
            signIn()
        } catch {
            jobTableView.isHidden = true
            print("ERROR: Couldnt sign out")
        }
        
        
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.jobArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = jobTableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        cell.textLabel?.text = jobs.jobArray[indexPath.row].jobTitle
        return cell
    }
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            jobTableView.isHidden = false
            print("**** we signed in with user: \(user.email ?? "unknown email")")
        }
      
    }
}
