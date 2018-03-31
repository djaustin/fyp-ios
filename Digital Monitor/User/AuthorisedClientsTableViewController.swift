//
//  AuthorisedClientsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for the Authosied Clients Table View
class AuthorisedClientsTableViewController: UITableViewController {

    var dataSet: [DMClient] = []
    var user: DMUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = DMUser.authenticatedUser {
            self.user = user
            // If user is logged in. Get their authorised clients
            user.getAuthorisedClients({ (clients, error) in
                if let error = error {
                    self.presentErrorAlert(withTitle: "Unable to retrieve clients", andText: String(describing: error))
                } else {
                    if let clients = clients {
                        // Only add third party clients. This app uses a client but its a trusted first party and shouldn't be removable by the user
                        self.dataSet = clients.filter {$0.isThirdParty}
                        UI{
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        } else {
            print("user not authenticated")
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
        return dataSet.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSet[indexPath.row].name
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let client = dataSet[indexPath.row]
            let spinner = UIViewController.displaySpinner(onView: self.view)
            user?.revokeAccess(fromClient: client, onCompletion: { (success, error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Operation Failed", andText: String(describing: error))
                } else {
                    if success {
                        UI{
                            self.dataSet.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            })
            
        }
    }
}
