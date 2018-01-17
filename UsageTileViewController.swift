//
//  UsageTileViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class UsageTileViewController: UIViewController {

    @IBOutlet weak var applicationUsageView: UsageTileView!
    @IBOutlet weak var platformUsageView: UsageTileView!
    @IBOutlet weak var overallUsageView: UsageTileView!
    var user: DMUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        applicationUsageView.titleLabel.text = "Top Application"
        platformUsageView.titleLabel.text = "Top Platform"
        overallUsageView.titleLabel.text = "Overall Usage"
        user = DMUser.authenticatedUser
        user?.getOverallUsageInSeconds(onCompletion: { (seconds, error) in
            if let error = error {
                UI{
                    self.overallUsageView.informationLabel.text = String(describing: error)
                }
            } else {
                UI{
                    self.overallUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: seconds!)
                }
            }
        })
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
