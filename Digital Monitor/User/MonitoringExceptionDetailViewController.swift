//
//  MonitoringExceptionDetailViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class MonitoringExceptionDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(platformPicker){
            return row == 0 ? "All" : platforms[row-1].name
        } else {
            return row == 0 ? "All" : applications[row-1].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(platformPicker){
            return platforms.count + 1
        } else {
            return applications.count + 1
        }
    }
    
    
    var exception: DMMonitoringException?
    var applications: [DMApplication] = []
    var platforms: [DMPlatform] = []
    @IBOutlet weak var platformPicker: UIPickerView!
    @IBOutlet weak var applicationPicker: UIPickerView!
    @IBOutlet weak var applicationSwitch: UISwitch!
    @IBOutlet weak var platformSwitch: UISwitch!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        guard let exception = exception else {
            return
        }
        exception.delete { (error) in
            if let error = error {
                print(error)
            } else {
                UI {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadViewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    var user: DMUser!
    
    @IBOutlet weak var saveButton: UIButton!
    func loadViewData(){
        if exception != nil {
            navigationItem.title = "Edit Exception"
            saveButton.setTitle("Save", for: .normal)
            deleteButton.isHidden = false
        } else {
            navigationItem.title = "New Exception"
            saveButton.setTitle("Add Exception", for: .normal)
            deleteButton.isHidden = true
        }

        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout"){
            self.user = user
            print("USER AUTHED")
            user.getAuthorisedApplications { (applications, error) in
                print("DONE WITH THE REQUEST")
                if let error = error {
                    print(error)
                } else {
                    if let applications = applications {
                        
                        self.applications = applications
                        UI {
                            self.applicationPicker.reloadAllComponents()
                            self.populateControlsWithProvidedException()
                            // TODO: Maybe set the chosen application here as well
                        }
                    }
                }
            }
        } else {
            print("USER IS NULL")
        }
    }
    
    func setupViews(){
        platformPicker.dataSource = self
        platformPicker.delegate = self
        applicationPicker.delegate = self
        applicationPicker.dataSource = self
        populatePlatformsPicker()
    }
    
    func populatePlatformsPicker(){
        DMPlatform.getPlatforms { (platforms, error) in
            if let error = error {
                print(error)
            } else {
                if let platforms = platforms {
                    self.platforms = platforms
                    UI {
                        self.platformPicker.reloadAllComponents()
                    }
                } else {
                    print("no error or platforms")
                }
            }
        }
    }
  
    
    func populateControlsWithProvidedException(){
        if let exception = exception {
            if let application = exception.application {
                if let row = applications.index(where: { (app) -> Bool in
                    app.id == application.id
                }) {
                    applicationPicker.selectRow(row+1, inComponent: 0, animated: false)
                    
                }
            } else {
                applicationPicker.selectRow(0, inComponent: 0, animated: false)
            }
            if let platform = exception.platform{
                if let row = platforms.index(where: { (element) -> Bool in
                    element.id == platform.id
                }) {
                    platformPicker.selectRow(row+1, inComponent: 0, animated: false)
                }
            } else {
                applicationPicker.selectRow(0, inComponent: 0, animated: false)
            }
            fromDatePicker.setDate(exception.startTime, animated: false)
            toDatePicker.setDate(exception.endTime, animated: false) 
        }
    }

    
    
    func getChosenApplication() -> DMApplication? {
        let index = applicationPicker.selectedRow(inComponent: 0)
        return index == 0 ? nil : applications[index-1]
    }
    
    func getChosenPlatform() -> DMPlatform? {
        let index = platformPicker.selectedRow(inComponent: 0)
        return index == 0 ? nil : platforms[index-1]
    }
    
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        print("SAVE BUTTON PRESSED")
        let platform = getChosenPlatform()
        let application = getChosenApplication()
        let startTime = fromDatePicker.date
        let endTime = toDatePicker.date
        if var exception = exception {
            exception.application = application
            exception.platform = platform
            exception.startTime = fromDatePicker.date
            exception.endTime = toDatePicker.date
            exception.save { (error) in
                if let error = error {
                    print(error)
                } else {
                    UI{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            let newGoal = DMMonitoringException(id: nil, platform: platform, application: application, user: user.id!, startTime: startTime, endTime: endTime)
            DMMonitoringException.addNew(exception: newGoal) { (exception, error) in
                if let error = error{
                    print(error)
                } else {
                    if let exception = exception {
                        UI {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
