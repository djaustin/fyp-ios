//
//  ClientViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for client detail view
class ClientViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var deleteButton: UIButton!
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
        return platforms[row].name
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var secretTextField: UITextField!
    @IBOutlet weak var redirectUriTextField: UITextField!
    @IBOutlet weak var platformPicker: UIPickerView!
    
    
    var platforms: [DMPlatform] = []
    var client: DMClient?
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        guard let application = application else {
            return print("NO APPLICATION PASSED THROUGH")
        }
        
        let name = nameTextField.text!
        let redirectUri = redirectUriTextField.text!
        
        if(name.isEmpty || redirectUri.isEmpty){
            return presentErrorAlert(withTitle: "Save Client", andText: "Please provide a name and redirect URI")
        }
        
        let chosenPlatform = platforms[platformPicker.selectedRow(inComponent: 0)]
        let spinner = UIViewController.displaySpinner(onView: self.view)
        if let client = client {
            client.name = name
            client.platform = chosenPlatform.id
            client.redirectUri = redirectUri
            client.save(toApplication: application, onCompletion: { (error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
                } else {
                    UI{
                        self.navigationItem.title = client.name
                    }
                }
            })
        } else {
            DMClient.addClient(name: name, redirectUri: redirectUri, applicationId: application.id!, platformId: chosenPlatform.id, onCompletion: { (client, error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
                } else {
                    if let client = client {
                        self.client = client
                        self.secretHidden = false
                        UI {
                            self.saveButton.setTitle("Save", for: .normal)
                            self.deleteButton.isHidden = false
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
        DMPlatform.getPlatforms { (platforms, error) in
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve platforms", andText: String(describing: error))
            } else {
                if let platforms = platforms {
                    self.platforms = platforms
                    UI {
                        self.platformPicker.reloadAllComponents()
                        if let client = self.client {
                            let index = platforms.index(where: {$0.id == client.platform})
                            if let index = index {
                                self.platformPicker.selectRow(index, inComponent: 0, animated: false)
                            }
                        }
                    }
                } else {
                    print("No error or platforms")
                }
            }
        }
        platformPicker.dataSource = self
        platformPicker.delegate = self
        var name: String?
        var id: String?
        var redirectUri: String?
        if let client = client {
            name = client.name
            id = client.clientId
            redirectUri = client.redirectUri
            saveButton.setTitle("Save", for: .normal)
            navigationItem.title = client.name
            deleteButton.isHidden = false
        } else {
            name = nil
            id = nil
            redirectUri = nil
            saveButton.setTitle("Add Client", for: .normal)
            navigationItem.title = "New Client"
            deleteButton.isHidden = true
        }
        
        nameTextField.text = name
        idTextField.text = id
        redirectUriTextField.text = redirectUri
        secretTextField.delegate = self
        idTextField.delegate = self
        nameTextField.delegate = self
        nameTextField.tag = 1
        redirectUriTextField.delegate = self
        redirectUriTextField.tag = 2
    }
    
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        guard let client = client else {
            return
        }
        
        let alert = UIAlertController(title: "Delete Client?", message: "Are you sure you want to delete this client? All associated usage logs will also be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            let spinner = UIViewController.displaySpinner(onView: self.view)
            client.delete(onCompletion: { (error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Delete Failed", andText: String(describing: error))
                } else {
                    UI{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.isEqual(idTextField) || textField.isEqual(secretTextField)) {
            return false
        } else {
            return true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentTag = textField.tag
        let finalTag = redirectUriTextField.tag
        debugPrint(currentTag, finalTag)
        if(currentTag == finalTag) {
            textField.resignFirstResponder()
            saveButtonWasPressed(self)
        } else {
            if let nextTextField = view.viewWithTag(currentTag+1) as? UITextField {
                debugPrint(nextTextField)
                nextTextField.becomeFirstResponder()
            }
        }
        
        // Tell text field to process return with default behaviour
        return true
    }
    
}
