//
//  RegisterViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
   
    
    @IBAction func registerButtonWasTapped(_ sender: Any) {
       let user = DMUser(email: txtEmail.text!, password: txtPassword.text!, firstName: txtFirstName.text!, lastName: txtLastName.text!)
        user.register { (success, error) in
            if let error = error {
                UI {
                    self.lblStatus.text = String(describing: error)
                }
            } else {
                UI {
                    self.performSegue(withIdentifier: "registerToLogin", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
