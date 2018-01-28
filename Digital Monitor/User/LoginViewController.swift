//
//  ViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
        
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        DMUser.login(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                UI {
                    self.lblStatus.text = String(describing: error)
                }
            } else {
                if user != nil {
                    UI {
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                } else {
                    UI {
                        self.lblStatus.text = "No user or error"
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
        // Dispose of any resources that can be recreated.
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

