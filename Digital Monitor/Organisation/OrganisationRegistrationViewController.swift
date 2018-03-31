//
//  OrganisationRegistrationViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for organisation registration view
class OrganisationRegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func registerButtonWasPressed(_ sender: Any) {
        let organisation = DMOrganisation(name: txtName.text!, email: txtEmail.text!, password: txtPassword.text!)
        let spinner = UIViewController.displaySpinner(onView: self.view)
        organisation.register { (success, error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Registration Failed", andText: String(describing: error))
            } else {
                UI {
                    self.performSegue(withIdentifier: "registerToLogin", sender: self)
                }
            }
        }
    }
    
    func setupViews(){
        txtName.delegate = self
        txtName.tag = 1
        txtEmail.delegate = self
        txtEmail.tag = 2
        txtPassword.delegate = self
        txtPassword.tag = 3
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTag = textField.tag
        let finalTag = txtPassword.tag
        debugPrint(currentTag, finalTag)
        if(currentTag == finalTag) {
            textField.resignFirstResponder()
            registerButtonWasPressed(self)
        } else {
            if let nextTextField = view.viewWithTag(currentTag+1) as? UITextField {
                debugPrint(nextTextField)
                nextTextField.becomeFirstResponder()
            }
        }
        
        // Tell text field to process return with default behaviour
        return true
    }

}
