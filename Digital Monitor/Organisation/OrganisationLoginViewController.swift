//
//  OrganisationLoginViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class OrganisationLoginViewController: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        DMOrganisation.login(withEmail: txtEmail.text!, password: txtPassword.text!) { (organisation, error) in
            if let error = error {
                UI {
                    self.lblStatus.text = String(describing: error)
                }
            } else {
                UI {
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
    }
    
    @IBAction func unwindToOrgLogin(_ sender: UIStoryboardSegue){
        
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
