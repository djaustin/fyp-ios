//
//  ApplicationClientsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

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
        organisation.getClients(forApplication: application, onCompletion: { (clients, error) in
            if let error = error {
                print(error)
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
