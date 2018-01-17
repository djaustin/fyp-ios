//
//  UsageViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 16/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class UsageViewController: UIViewController {

    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        DMUser.logout()
        performSegue(withIdentifier: "logout", sender: self)
    }
    var user: DMUser?
    @IBOutlet weak var lblOverallUsageValue: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = DMUser.authenticatedUser
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = user {
            user.getOverallUsageInSeconds(onCompletion: { (seconds, error) in
                if let error = error {
                    UI {
                        self.lblOverallUsageValue.text = String(describing: error)
                    }
                } else {
                    if let seconds = seconds {
                        UI {
                            self.lblOverallUsageValue.text = String(digitalClockFormatFromSeconds: seconds)
                        }
                    }
                }
            })
        }
    }
}
