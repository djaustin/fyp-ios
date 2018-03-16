//
//  OrganisationLoginViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class OrganisationLoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        let spinner = UIViewController.displaySpinner(onView: self.view)
        DMOrganisation.login(withEmail: txtEmail.text!, password: txtPassword.text!) { (organisation, error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                    self.presentErrorAlert(withTitle: "Login Failed", andText: String(describing: error))
            } else {
                UI {
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    func setupViews(){
        txtEmail.delegate = self
        txtEmail.tag = 1
        txtPassword.delegate = self
        txtPassword.tag = 2
    }
    
    @IBAction func unwindToOrgLogin(_ sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            loginButtonWasTapped(self)
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
