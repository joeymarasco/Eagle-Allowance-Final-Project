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
    // MARK: IB OUTLETS
    @IBOutlet weak var jobTableView: UITableView!
    @IBOutlet weak var addJobBarButton: UIBarButtonItem!
    @IBOutlet weak var accountButton: UIBarButtonItem!
    
    // MARK: VARIABLES
    var jobs: Jobs!
    var authUI: FUIAuth!
    
    // MARK:  FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        jobTableView.delegate = self
        jobTableView.dataSource = self
        // protect table view from people who arent signed in
        jobTableView.isHidden = true
        addJobBarButton.isEnabled = false
        accountButton.title = "Sign In"
        // populate the jobs variable
        jobs = Jobs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        jobs.loadData {
            self.jobs.jobArray.sort(by: {$0.jobTitle < $1.jobTitle})
            self.jobTableView.reloadData()
        }
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
            addJobBarButton.isEnabled = true
            accountButton.title = "Sign Out"
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
    
    // MARK:  IB ACTIONS
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("$$$ successful sign out")
            // protext table view from people who arent signed in
            jobTableView.isHidden = true
            addJobBarButton.isEnabled = false
            accountButton.title = "Sign In"
            
            signIn()
        } catch {
            // allow users to now see the tableview
            jobTableView.isHidden = true
            addJobBarButton.isEnabled = false
            accountButton.title = "Sign Out"
            print("ERROR: Couldnt sign out")
        }
    }
    
    @IBAction func aboutButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowAboutPage", sender: nil)
    }
}

// MARK: EXTENSIONS
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.jobArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create the cell
        let cell = jobTableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        // format the cell (text, color, font)
        cell.textLabel?.text = jobs.jobArray[indexPath.row].jobTitle
        cell.textLabel?.textColor = UIColor.init(hue: 5.0, saturation: 0.83, brightness: 0.37, alpha: 0.95)
        cell.textLabel?.font = UIFont(name: "Futura", size: 15.0)
        // make your own posts show as light gray
        if jobs.jobArray[indexPath.row].postingUserID == authUI.auth?.currentUser?.email {
            cell.contentView.backgroundColor = UIColor.lightGray
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.contentView.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
        }
        // return the cell
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
            addJobBarButton.isEnabled = true
            accountButton.title = "Sign Out"
            print("**** we signed in with user: \(user.email ?? "unknown email")")
        }
    }
}
