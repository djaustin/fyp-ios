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
            return platforms[row].name
        } else {
            return applications[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(platformPicker){
            return platforms.count
        } else {
            return applications.count
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
    @IBAction func applicationSwitchDidChange(_ sender: Any) {
        if applicationSwitch.isOn {
            setApplicationEnabled(true)
        } else {
            setApplicationEnabled(false)
        }
    }
    
    @IBAction func platformSwitchDidChange(_ sender: Any) {
        if platformSwitch.isOn {
            setPlatformEnabled(true)
        } else {
            setPlatformEnabled(false)
        }
    }
    
    func setPlatformEnabled(_ enabled: Bool){
        if enabled {
            platformPicker.isUserInteractionEnabled = true
            platformPicker.alpha = 1
        } else {
            platformPicker.isUserInteractionEnabled = false
            platformPicker.alpha = 0.6
        }
    }
    
    func setApplicationEnabled(_ enabled: Bool){
        if enabled {
            applicationPicker.isUserInteractionEnabled = true
            applicationPicker.alpha = 1
        } else {
            applicationPicker.isUserInteractionEnabled = false
            applicationPicker.alpha = 0.6
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
        
        setApplicationEnabled(false)
        setPlatformEnabled(false)
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
                setApplicationEnabled(true)
                applicationSwitch.isOn = true
                if let row = applications.index(where: { (app) -> Bool in
                    app.id == application.id
                }) {
                    applicationPicker.selectRow(row, inComponent: 0, animated: true)
                    
                }
            } else {
                setApplicationEnabled(false)
                platformSwitch.isOn = false
            }
            if let platform = exception.platform{
                setPlatformEnabled(true)
                platformSwitch.isOn = true
                if let row = platforms.index(where: { (element) -> Bool in
                    element.id == platform.id
                }) {
                    platformPicker.selectRow(row, inComponent: 0, animated: true)
                }
            } else {
                setPlatformEnabled(false)
                platformSwitch.isOn = false
            }
            fromDatePicker.date = exception.startTime
            toDatePicker.date = exception.endTime
        }
    }

    
    
    func getChosenApplication() -> DMApplication? {
        
        return applicationSwitch.isOn && !applications.isEmpty ? applications[applicationPicker.selectedRow(inComponent: 0)] : nil
    }
    
    func getChosenPlatform() -> DMPlatform? {
        return platformSwitch.isOn ? platforms[platformPicker.selectedRow(inComponent: 0)] : nil
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
