//
//  RegisterViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
   
    
    @IBAction func registerButtonWasTapped(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtEmail.text!
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        if(email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty){
            presentErrorAlert(withTitle: "Registration", andText: "Please provide a value for all fields")
            return
        }
       let user = DMUser(email: email, password: txtPassword.text!, firstName: txtFirstName.text!, lastName: txtLastName.text!)
        let spinner = UIViewController.displaySpinner(onView: self.view)
        user.register { (success, error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                UI {
                    self.presentErrorAlert(withTitle: "Registration Error", andText: String(describing: error))
                }
            } else {
                UI {
                self.performSegue(withIdentifier: "registerToLogin", sender: self)
                }
            }
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        performSegue(withIdentifier: "registerToLogin", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        txtFirstName.delegate = self
        txtFirstName.tag = 1
        txtLastName.delegate = self
        txtLastName.tag = 2
        txtEmail.delegate = self
        txtEmail.tag = 3
        txtPassword.delegate = self
        txtPassword.tag = 4
        
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
            registerButtonWasTapped(self)
        } else {
            if let nextTextField = view.viewWithTag(currentTag+1) as? UITextField {
                debugPrint(nextTextField)
                nextTextField.becomeFirstResponder()
            }
        }
    
        // Tell text field to process return with default behaviour
        return true
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
