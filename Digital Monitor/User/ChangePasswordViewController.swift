//
//  ChangePasswordViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var user: DMUser!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = DMUser.authenticatedUser else {
            navigationController?.popViewController(animated: true)
            return
        }
        self.user = user
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePasswordButtonWasPressed(_ sender: Any) {
        let password = passwordTextField.text!
        let passwordConfirmation = passwordConfirmationTextField.text!
        if(password.isEmpty || passwordConfirmation.isEmpty){
            return presentErrorAlert(withTitle: "Change Password", andText: "Please enter your new password in both fields")
        }
        if(password != passwordConfirmation){
            return presentErrorAlert(withTitle: "Change Password", andText: "Passwords do not match")
        }
        let spinner = UIViewController.displaySpinner(onView: self.view)
        user.save(password: password) { (error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
            } else {
                UI {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
