//
//  OrgansationApplicationsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class OrgansationApplicationsTableViewController: UITableViewController {
    
    var applications: [DMApplication] = []
    var organisation: DMOrganisation?

    @IBAction func addButtonWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Application", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Application name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let nameField = alert.textFields![0]
            if !(nameField.text?.isEmpty)!{
                self.saveApplicationToOrganisation(withName: nameField.text!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveApplicationToOrganisation(withName name: String) {
        organisation?.addApplication(withName: name, onCompletion: { (application, error) in
            if let error = error {
                print(error)
            } else {
                if let application = application {
                    self.applications.append(application)
                    UI {
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        organisation = DMOrganisation.authenticatedOrganisation
        loadOrganisationApplications()
    }

    func loadOrganisationApplications(){
            organisation?.getApplications(onCompletion: { (applications, error) in
            if let error = error {
                print(error)
            } else {
                if let applications = applications {
                    self.applications = applications
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
        return applications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = applications[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showClients", sender: self)
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ApplicationClientsTableViewController {
            vc.application = applications[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func logoutButtonWasPressed(_ sender: Any) {
        DMOrganisation.logout()
        performSegue(withIdentifier: "logout", sender: self)
    }
    

}
