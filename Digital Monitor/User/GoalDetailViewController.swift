//
//  GoalDetailViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(periodPicker){
            return periods[row]
        } else if pickerView.isEqual(platformPicker){
            return platforms[row]
        } else {
            return applications[row].name
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(periodPicker){
            return periods.count
        } else if pickerView.isEqual(platformPicker){
            return platforms.count
        } else {
            return applications.count
        }
    }
    
    
    var goal: DMUser.UsageGoal?
    let periods = ["daily", "weekly", "monthly", "yearly"]
    var applications: [DMApplication] = []
    let platforms = ["ios", "android", "blackberry", "windows-phone", "desktop", "browser"]
    @IBOutlet weak var platformPicker: UIPickerView!
    @IBOutlet weak var applicationPicker: UIPickerView!
    @IBOutlet weak var periodPicker: UIPickerView!
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var applicationSwitch: UISwitch!
    @IBOutlet weak var platformSwitch: UISwitch!
    
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
        if let goal = goal {
            navigationItem.title = "Edit Goal"
            saveButton.setTitle("Save", for: .normal)
        } else {
            navigationItem.title = "New Goal"
            saveButton.setTitle("Add Goal", for: .normal)
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
                            self.populateControlsWithProvidedGoal()
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
        periodPicker.dataSource = self
        periodPicker.delegate = self
        platformPicker.dataSource = self
        platformPicker.delegate = self
        applicationPicker.delegate = self
        applicationPicker.dataSource = self
        daysTextField.delegate = self
        hoursTextField.delegate = self
        minutesTextField.delegate = self
        secondsTextField.delegate = self
    }
    
    
    func populateControlsWithProvidedGoal(){
        if let goal = goal {
            if let appId = goal.applicationId {
                setApplicationEnabled(true)
                applicationSwitch.isOn = true
                if let row = applications.index(where: { (app) -> Bool in
                    app.id == appId
                }) {
                    applicationPicker.selectRow(row, inComponent: 0, animated: true)
                    
                }
            } else {
                setApplicationEnabled(false)
                platformSwitch.isOn = false
            }
            if let platform = goal.platform{
                setPlatformEnabled(true)
                platformSwitch.isOn = true
                if let row = platforms.index(where: { (element) -> Bool in
                    element == platform
                }) {
                    platformPicker.selectRow(row, inComponent: 0, animated: true)
                }
            } else {
                setPlatformEnabled(false)
                platformSwitch.isOn = false
            }
            let (d, h, m, s) = goal.duration.asDaysHoursMinutesSeconds()
            daysTextField.text = String(d)
            hoursTextField.text = String(h)
            minutesTextField.text = String(m)
            secondsTextField.text = String(s)
            if let periodRow = periods.index(where: { (element) -> Bool in
                element == goal.period
            }){
                periodPicker.selectRow(periodRow, inComponent: 0, animated: true)
            }
        }
    }
    
    @IBAction func secondsTextFieldChanged(_ sender: UITextField) {
        constrainValue(ofTextField: sender, betweenMinimum: 0, andMaximum: 60)
    }
    
    func constrainValue(ofTextField textField: UITextField, betweenMinimum minimum: Int, andMaximum maximum: Int){
        if let value = Int(textField.text!){
            if value > maximum {
                textField.text = String(maximum)
            }
            if value < minimum {
                textField.text = String(minimum)
            }
        }
    }
    
    
    func getChosenApplication() -> DMApplication? {
        
        return applicationSwitch.isOn && !applications.isEmpty ? applications[applicationPicker.selectedRow(inComponent: 0)] : nil
    }
    
    func getChosenPlatform() -> String? {
        return platformSwitch.isOn ? platforms[platformPicker.selectedRow(inComponent: 0)] : nil
    }
    
    func getDurationInSeconds() -> Int {
        var total = 0
        if let days = Int(daysTextField.text!){
            total += days * 86400
        }
        if let hours = Int(hoursTextField.text!){
            total += hours * 3600
        }
        if let minutes = Int(minutesTextField.text!){
            total += minutes * 60
        }
        if let seconds = Int(secondsTextField.text!){
            total += seconds
        }
        return total
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let duration = getDurationInSeconds()
        let period = periods[periodPicker.selectedRow(inComponent: 0)]
        let platform = getChosenPlatform()
        let applicationId = getChosenApplication()?.id
        if var goal = goal {
            goal.applicationId = getChosenApplication()?.id
            goal.platform = getChosenPlatform()
            goal.duration = getDurationInSeconds()
            goal.period = period
            user.saveGoal(goal) { (error) in
                if let error = error {
                    print(error)
                } else {
                    print("ABOUT TO POP CONTROLLER")
                    UI{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            let newGoal = DMUser.UsageGoal(duration: duration, period: period, platform: platform, applicationId: applicationId)
            user.add(usageGoal: newGoal) { (goal, error) in
                if let error = error {
                    print(error)
                } else {
                    if let goal = goal {
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
    
   
    @IBAction func minutesTextFieldChanged(_ sender: UITextField) {
        constrainValue(ofTextField: sender, betweenMinimum: 0, andMaximum: 60)
    }
    @IBAction func hoursTextFieldChanged(_ sender: UITextField) {
        constrainValue(ofTextField: sender, betweenMinimum: 0, andMaximum: 60)
    }
    @IBAction func dayTextFieldChanged(_ sender: UITextField) {
        constrainValue(ofTextField: sender, betweenMinimum: 0, andMaximum: Int.max)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
