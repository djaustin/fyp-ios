//
//  AuthorisedClientsTableViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class AuthorisedClientsTableViewController: UITableViewController {

    var dataSet: [DMClient] = []
    var user: DMUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IN VIEW DID LOAD")
        if let user = DMUser.authenticatedUser {
            self.user = user
            print("Going to get authorised clients")
            user.getAuthorisedClients({ (clients, error) in
                print("Get clients callback")
                if let error = error {
                    print(error)
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
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

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
            user?.revokeAccess(fromClient: client, onCompletion: { (success, error) in
                if let error = error {
                    print(error)
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
}
