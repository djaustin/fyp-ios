//
//  ClientViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var application: DMApplication? 
    @IBOutlet weak var saveButton: UIButton!
    var secretHidden = true
    @IBAction func viewSecretButtonWasPressed(_ sender: Any) {
        guard let client = client else {
            return print("NO CLIENT")
        }
        
        if(secretHidden){
            secretTextField.text = client.secret
            secretHidden = false
        } else {
            secretTextField.text = nil
            secretHidden = true
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return platforms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return platforms[row]
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var redirectUriTextField: UITextField!
    @IBOutlet weak var platformPicker: UIPickerView!
    
    
    let platforms: [String] = ["ios", "android", "blackberry", "windows-phone", "desktop", "browser"]
    var client: DMClient?
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        guard let application = application else {
            return print("NO APPLICATION PASSED THROUGH")
        }
        
        let chosenPlatform = platforms[platformPicker.selectedRow(inComponent: 0)]
        if let client = client {
            client.name = nameTextField.text!
            client.platform = chosenPlatform
            client.redirectUri = redirectUriTextField.text!
            client.save(toApplication: application, onCompletion: { (error) in
                if let error = error {
                    print(error)
                } else {
                    UI{
                        self.navigationItem.title = client.name
                    }
                }
            })
        } else {
            DMClient.addClient(name: nameTextField.text!, redirectUri: redirectUriTextField.text!, applicationId: application.id!, platform: chosenPlatform, onCompletion: { (client, error) in
                if let error = error {
                    print(error)
                } else {
                    if let client = client {
                        self.client = client
                        self.secretHidden = false
                        UI {
                            self.saveButton.setTitle("Save", for: .normal)
                            self.navigationItem.title = client.name
                            self.secretTextField.text = client.secret
                            self.idTextField.text = client.clientId
                        }
                    }
                }
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateSubViews()
        // Do any additional setup after loading the view.
    }

    func populateSubViews() {
        platformPicker.dataSource = self
        platformPicker.delegate = self
        var name: String?
        var id: String?
        var redirectUri: String?
        if let client = client {
            name = client.name
            id = client.clientId
            redirectUri = client.redirectUri
            let index = platforms.index(of: client.platform)!
            platformPicker.selectRow(index, inComponent: 0, animated: true)
            saveButton.setTitle("Save", for: .normal)
            navigationItem.title = client.name
        } else {
            name = nil
            id = nil
            redirectUri = nil
            saveButton.setTitle("Add Client", for: .normal)
            navigationItem.title = "New Client"
        }
        
        nameTextField.text = name
        idTextField.text = id
        redirectUriTextField.text = redirectUri
        
        
        secretTextField.delegate = self
        idTextField.delegate = self
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
