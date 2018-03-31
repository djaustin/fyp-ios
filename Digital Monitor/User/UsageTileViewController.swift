//
//  UsageTileViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for Usage Tile View
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
    }
    
    func setupViews(){
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: fromDatePicker.date)!
        let today = Date()
        fromDatePicker.setDate(oneWeekAgo.startOfDay, animated: true)
        fromDatePicker.maximumDate = today.startOfDay
        toDatePicker.setDate(today.endOfDay!, animated: true)
        toDatePicker.maximumDate = today.endOfDay!
        applicationUsageView.titleLabel.text = "Top App"
        applicationUsageView.informationLabel.text = nil
        applicationUsageView.usageTimeLabel.text = nil
        applicationUsageView.button.setTitle("All Apps", for: .normal)
        platformUsageView.usageTimeLabel.text = nil
        platformUsageView.titleLabel.text = "Top Platform"
        platformUsageView.informationLabel.text = nil
        platformUsageView.usageTimeLabel.text = nil
        platformUsageView.button.setTitle("All Platforms", for: .normal)
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
    }
    
    func getUsageOverviewData(){
        let fromDate = fromDatePicker.date.startOfDay
        let toDate = toDatePicker.date.endOfDay
        
        let fromTime = Int(fromDate.timeIntervalSince1970 * 1000)
        let toTime: Int
        if let toDate = toDate {
            toTime = Int(toDate.timeIntervalSince1970 * 1000)
        } else {
            toTime = Int(toDatePicker.date.timeIntervalSince1970 * 1000)
        }
        
        
        let query = [
            "fromTime": String(fromTime),
            "toTime": String(toTime)
        ]
        let overallSpinner = UIViewController.displaySpinner(onView: overallUsageView, withStyle: .gray, withBackground: false)
        let appSpinner = UIViewController.displaySpinner(onView: applicationUsageView, withStyle: .gray, withBackground: false)
        let platformSpinner = UIViewController.displaySpinner(onView: platformUsageView, withStyle: .gray, withBackground: false)
        user?.getAggregatedMetrics(withQuery: query, onCompletion: { (data, error) in
            UIViewController.removeSpinner(spinner: overallSpinner)
            UIViewController.removeSpinner(spinner: appSpinner)
            UIViewController.removeSpinner(spinner: platformSpinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve usage", andText: String(describing: error))
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
            self.platformUsageView.informationLabel.text = topPlatform.platform.name
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
        guard let largestApplicationUsage = data.max(by: {$0.duration < $1.duration}) else {
            UI {
                self.applicationUsageView.informationLabel.text = "Cannot find max"
            }
            return
        }
        UI {
            self.applicationUsageView.informationLabel.text = largestApplicationUsage.application.name
            self.applicationUsageView.usageTimeLabel.text = String(digitalClockFormatFromSeconds: largestApplicationUsage.duration)
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
            vc.startDate = fromDatePicker.date
            vc.endDate = toDatePicker.date
        }
        
        if let vc = segue.destination as? ApplicationUsageCollectionViewController {
            vc.dataSource = applicationData
            vc.startDate = fromDatePicker.date
            vc.endDate = toDatePicker.date
        }
    }

}
