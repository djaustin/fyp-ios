//
//  ApplicationClientsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for application clients table view
class ApplicationClientsTableViewController: UITableViewController {
    var application: DMApplication?
    var clients: [DMClient] = []
    var organisation: DMOrganisation?
    override func viewDidLoad() {
        super.viewDidLoad()
        organisation = DMOrganisation.authenticatedOrganisation        
    }
    
    @IBAction func addButtonWasPressed(_ sender: Any){
        deselectRowIfSelected()
        performSegue(withIdentifier: "showClient", sender: self)
    }

    func deselectRowIfSelected(){
        if let indices = tableView.indexPathsForSelectedRows {
            tableView.deleteRows(at: indices, with: .automatic)
        }
    }

    func loadApplicationClients() {
        guard let application = application else {
            return print("Application NIL")
        }
        
        guard let organisation = organisation else {
            return print("Organisation NIL")
        }
        let spinner = UIViewController.displaySpinner(onView: self.view)
        organisation.getClients(forApplication: application, onCompletion: { (clients, error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve application clients", andText: String(describing: error))
            } else {
                if let clients = clients {
                    self.clients = clients
                    UI {
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = clients[indexPath.row].name
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showClient", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadApplicationClients()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ClientViewController {
            vc.application = application
            if let row = tableView.indexPathForSelectedRow?.row {
                vc.client = clients[row]
            } else {
                vc.client = nil
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
