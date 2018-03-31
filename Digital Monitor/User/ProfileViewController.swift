//
//  ProfileViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for profile view
class ProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var user: DMUser!
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        if(firstName.isEmpty || lastName.isEmpty){
            return presentErrorAlert(withTitle: "Save Profile", andText: "A first name and last name are required")
        }
        user.firstName = firstName
        user.lastName = lastName
        let spinner = UIViewController.displaySpinner(onView: self.view)
        user.save { (error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
            } else {
                UI{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to delete your account? All associated data will be lost forever", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let spinner = UIViewController.displaySpinner(onView: self.view)
            self.user.delete(onCompletion: { (error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Delete Failed", andText: String(describing: error))
                } else {
                    UI{
                        self.performSegue(withIdentifier: "logout", sender: self)
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout") {
            self.user = user
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            emailTextField.text = user.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
