//
//  SettingsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for Setting Table View
class SettingsTableViewController: UITableViewController {

    var menuItems = ["Profile", "Authorised Clients"]
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        DMUser.logout()
        performSegue(withIdentifier: "logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuItems[indexPath.row] {
        case "Authorised Clients":
            performSegue(withIdentifier: "openAuthorisedClients", sender: self)
        case "Profile":
            performSegue(withIdentifier: "showProfile", sender: self)
        default:
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }

}
