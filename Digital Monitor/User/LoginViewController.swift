//
//  ViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for the Login View
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var activityIndicator: UIView?
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if(email.isEmpty || password.isEmpty){
            presentErrorAlert(withTitle: "Account Login", andText: "Please enter your email and password");
            return
        }
        
        activityIndicator = UIViewController.displaySpinner(onView: self.view)
        
        DMUser.login(withEmail: email, password: password) { (user, error) in
            if let spinner = self.activityIndicator {
                UIViewController.removeSpinner(spinner: spinner)
            }
            if let error = error {
                UI {
                    self.presentErrorAlert(withTitle: "Login Failed", andText: String(describing: error))
                }
            } else {
                if user != nil {
                    UI {
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                } else {
                    UI {
                        self.presentErrorAlert(withTitle: "Login Failed", andText: "Unable to find user")
                    }
                    
                }
            }
        }
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtPassword.delegate = self
        if DMUser.userIsLoggedIn {
            performSegue(withIdentifier: "login", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtPassword.borderStyle = .roundedRect
        txtEmail.borderStyle = .roundedRect
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Tell text field to process return with default behaviour
        return true
    }

}

