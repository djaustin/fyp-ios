//
//  OrganisationRegistrationViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class OrganisationRegistrationViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func registerButtonWasPressed(_ sender: Any) {
        let organisation = DMOrganisation(name: txtName.text!, email: txtEmail.text!, password: txtPassword.text!)
        organisation.register { (success, error) in
            if let error = error {
                UI {
                    self.statusLabel.text = String(describing: error)
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
    
    

}
