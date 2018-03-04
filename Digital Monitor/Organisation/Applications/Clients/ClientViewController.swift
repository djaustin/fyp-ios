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
        
        let chosenPlatform = platforms[platformPicker.selectedRow(inComponent: 0)]
        if let client = client {
            client.name = nameTextField.text!
            client.platform = chosenPlatform.id
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
            DMClient.addClient(name: nameTextField.text!, redirectUri: redirectUriTextField.text!, applicationId: application.id!, platformId: chosenPlatform.id, onCompletion: { (client, error) in
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
        DMPlatform.getPlatforms { (platforms, error) in
            if let error = error {
                print(error)
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
        nameTextField.delegate = self
        nameTextField.tag = 1
        redirectUriTextField.delegate = self
        redirectUriTextField.tag = 2
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
