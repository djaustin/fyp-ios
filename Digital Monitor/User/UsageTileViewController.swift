//
//  UsageTileViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class UsageTileViewController: UIViewController {

    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBAction func viewButtonWasTapped(_ sender: Any) {
        getUsageOverviewData()
    }
    
    var applicationData: [ApplicationUsageData] = []
    var platformData: [PlatformUsageData] = []
    
    @IBOutlet weak var applicationUsageView: UsageTileView!
    @IBOutlet weak var platformUsageView: UsageTileView!
    @IBOutlet weak var overallUsageView: UsageTileView!
    var user: DMUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        user = DMUser.authenticatedUser
    
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: fromDatePicker.date)!
        let today = Date()
        fromDatePicker.setDate(oneWeekAgo.startOfDay, animated: true)
        toDatePicker.setDate(today.endOfDay!, animated: true)
        applicationUsageView.titleLabel.text = "Top Application"
        applicationUsageView.informationLabel.text = nil
        applicationUsageView.usageTimeLabel.text = nil
        platformUsageView.usageTimeLabel.text = nil
        platformUsageView.titleLabel.text = "Top Platform"
        platformUsageView.informationLabel.text = nil
        platformUsageView.usageTimeLabel.text = nil
        overallUsageView.titleLabel.text = "Overall"
        overallUsageView.informationLabel.text = nil
        overallUsageView.usageTimeLabel.text = nil
        overallUsageView.button.isEnabled = false
        applicationUsageView.button.isHidden = false
        platformUsageView.button.isHidden = false
        
        let applicationTappedGesture = UITapGestureRecognizer(target: self, action: #selector(applicationTileWasTapped(_:)))
        let platformTappedGesture = UITapGestureRecognizer(target: self, action: #selector(platformTileWasTapped(_:)))
        
        platformUsageView.button.addGestureRecognizer(platformTappedGesture)
        applicationUsageView.button.addGestureRecognizer(applicationTappedGesture)
    }
    
    @objc func applicationTileWasTapped(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "applicationUsage", sender: self)
    }

    @objc func platformTileWasTapped(_ sender: UITapGestureRecognizer){
                performSegue(withIdentifier: "platformUsage", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUsageOverviewData(){
        
        let fromTime = Int(fromDatePicker.date.timeIntervalSince1970 * 1000)
        let toTime = Int(toDatePicker.date.timeIntervalSince1970 * 1000)
        
        let query = [
            "fromTime": String(fromTime),
            "toTime": String(toTime)
        ]
        
        user?.getAggregatedMetrics(withQuery: query, onCompletion: { (data, error) in
            if let error = error {
                UI{
                    self.platformUsageView.informationLabel.text = String(describing: error)
                    self.applicationUsageView.informationLabel.text = String(describing: error)
                    self.overallUsageView.informationLabel.text = String(describing: error)
                }
            } else {
                if let data = data {
                    self.applicationData = data.applications
                    self.platformData = data.platforms
                    self.populateOverallUsageTile(withData: data.overall)
                    self.populatePlatformsUsageTile(withData: data.platforms)
                    self.populateApplicationsUsageTile(withData: data.applications)
                }
            }
        })
    }
    
    func populatePlatformsUsageTile(withData data: [PlatformUsageData]){
        guard data.count > 0 else {
            UI {
                self.platformUsageView.informationLabel.text = nil
                self.platformUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: 0)
            }
            return
        }
        guard let topPlatform = data.max(by: {$0.duration < $1.duration}) else {
            UI {
                self.platformUsageView.informationLabel.text = "Cannot find max"
            }
            return
        }
        UI {
            self.platformUsageView.informationLabel.text = topPlatform.name
            self.platformUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: topPlatform.duration)
        }
    }
    func populateApplicationsUsageTile(withData data: [ApplicationUsageData]){
        guard data.count > 0 else {
            UI {
                self.applicationUsageView.informationLabel.text = nil
                self.applicationUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: 0)
            }
            return
        }
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
    func populateOverallUsageTile(withData data: OverallMetricsResponseData){
        UI{
            self.overallUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: data.duration)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUsageOverviewData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlatformUsageCollectionViewController {
            vc.dataSource = platformData
        }
        
        if let vc = segue.destination as? ApplicationUsageCollectionViewController {
            vc.dataSource = applicationData
        }
    }

}
