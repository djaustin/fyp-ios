//
//  ViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit
import OAuth2

func UI(_ block: @escaping ()->Void) {
    DispatchQueue.main.async(execute: block)
}

class ViewController: UIViewController {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        let jsonEncoder = JSONEncoder()
        DMUser.login(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                UI {
                    self.lblStatus.text = String(describing: error)
                }
            } else {
                if let user = user {
                    UI {
                        self.lblStatus.text = "Logged in \(String(data:try! jsonEncoder.encode(user), encoding: .utf8))"
                    }
                } else {
                    UI {
                        self.lblStatus.text = "No user or error"
                    }
                    
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

