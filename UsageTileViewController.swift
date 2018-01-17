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
        applicationUsageView.informationLabel.text = nil
        platformUsageView.usageTimeLabel.text = nil
        platformUsageView.titleLabel.text = "Top Platform"
        platformUsageView.informationLabel.text = nil
        platformUsageView.usageTimeLabel.text = nil
        overallUsageView.titleLabel.text = "Overall"
        overallUsageView.informationLabel.text = nil
        overallUsageView.usageTimeLabel.text = nil
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
        user?.getApplicationsMetrics(onCompletion: { (data, error) in
            if let error = error {
                UI{
                    self.applicationUsageView.informationLabel.text = String(describing: error)
                }
            } else {
                if let data = data {
                    guard let largestApplication = data.max(by: {$0.duration < $1.duration}) else {
                        UI {
                            self.applicationUsageView.informationLabel.text = "Cannot find max"
                        }
                        return
                    }
                    UI {
                        self.applicationUsageView.informationLabel.text = largestApplication.name
                        self.applicationUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: largestApplication.duration)
                    }
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
