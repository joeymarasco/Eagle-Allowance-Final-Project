//
//  ViewController.swift
//  Eagle Allowance
//
//  Created by Joseph Marasco on 11/29/19.
//  Copyright © 2019 Joseph Marasco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var jobTableView: UITableView!
    
    var jobs: Jobs!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTableView.delegate = self
        jobTableView.dataSource = self
        
        jobs = Jobs()
        jobs.jobArray.append(Job(jobTitle: "Clean my kitchen", jobDescription: "my kitchen is super dirty and I need somebody to clean it", paymentMethod: "$10 venmo", postingUserID: "", documentID: ""))
        
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

