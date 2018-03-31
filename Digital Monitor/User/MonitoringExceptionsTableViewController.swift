//
//  MonitoringExceptionsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Custom table row for monitoring exceptions
class MonitoringExceptionsTableViewCell: UITableViewCell{
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    @IBOutlet weak var applicationLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
}

/// Controller for monitoring exceptions table view
class MonitoringExceptionsTableViewController: UITableViewController {

    
    var selectedException: DMMonitoringException?
    var exceptions: [DMMonitoringException] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let user = DMUser.authenticatedUser {
            user.getMonitoringExceptions { (exceptions, error) in
                if let error = error {
                    self.presentErrorAlert(withTitle: "Unable to retrieve monitoring exceptions", andText: String(describing: error))
                } else {
                    if let exceptions = exceptions {
                        self.exceptions = exceptions
                        UI {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exceptions.count
    }
    
    @IBAction func addButtonWasPressed(_ sender: Any) {
        selectedException = nil
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MonitoringExceptionsTableViewCell

        let exception = exceptions[indexPath.row]
        cell.fromTimeLabel.text = exception.startTime.toString(dateFormat: "MM-dd-yyyy HH:mm")
        cell.toTimeLabel.text = exception.endTime.toString(dateFormat: "MM-dd-yyyy HH:mm")
        cell.applicationLabel.text = exception.application?.name ?? "All"
        cell.platformLabel.text = exception.platform?.name ?? "All"

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedException = exceptions[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MonitoringExceptionDetailViewController{
            vc.exception = selectedException
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 200
        return UITableViewAutomaticDimension        
    }

}
