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

    @IBOutlet weak var jobTitleField: UITextField!
    @IBOutlet weak var jobDescriptionField: UITextField!
    @IBOutlet weak var paymentMethodField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    
    var job: Job!
    var photos: Photos!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if job == nil {
            job = Job()
        }
        
        saveBarButton.isEnabled = false
        imagePicker.delegate = self
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
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camerAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(camerAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
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

    @IBAction func jobDescriptionChanged(_ sender: UITextField) {
        checkEnableSave()
    }

    @IBAction func paymentMethodChanged(_ sender: Any) {
        checkEnableSave()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        cameraOrLibraryAlert()
    }
    
    
}

extension AddJobViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) {
            photo.saveData(job: self.job) { (success) in
                if success {
                    self.photos.photoArray.append(photo)
                    
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
}

