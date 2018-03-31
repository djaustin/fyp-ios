//
//  GoalDetailViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Controller for the goal detail view
class GoalDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(periodPicker){
            return periods[row].name
        } else if pickerView.isEqual(platformPicker){
            return row == 0 ? "All" : platforms[row-1].name
        } else {
            return row == 0 ? "All" : applications[row-1].name
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(periodPicker){
            return periods.count
        } else if pickerView.isEqual(platformPicker){
            return platforms.count + 1
        } else {
            return applications.count + 1
        }
    }
    
    
    var goal: DMUser.UsageGoal?
    var periods: [DMPeriod] = []
    var applications: [DMApplication] = []
    var platforms: [DMPlatform] = []
    @IBOutlet weak var platformPicker: UIPickerView!
    @IBOutlet weak var applicationPicker: UIPickerView!
    @IBOutlet weak var periodPicker: UIPickerView!
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonWasPressed(_ sender: Any) {
        guard let goal = goal else {
            return
        }
        let spinner = UIViewController.displaySpinner(onView: self.view)
        user.deleteGoal(goal) { (error) in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Delete Failed", andText: String(describing: error))
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
    }

    var user: DMUser!
    
    @IBOutlet weak var saveButton: UIButton!
    func loadViewData(){
        if let goal = goal {
            navigationItem.title = "Edit Goal"
            saveButton.setTitle("Save", for: .normal)
            deleteButton.isHidden = false
        } else {
            navigationItem.title = "New Goal"
            saveButton.setTitle("Add Goal", for: .normal)
            deleteButton.isHidden = true
        }

        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout"){
            self.user = user
            print("USER AUTHED")
            user.getAuthorisedApplications { (applications, error) in
                print("DONE WITH THE REQUEST")
                if let error = error {
                    self.presentErrorAlert(withTitle: "Unable to retrieve applications", andText: String(describing: error))
                } else {
                    if let applications = applications {
                        
                        self.applications = applications.sorted(by: {$0.name < $1.name})
                        UI {
                            self.applicationPicker.reloadAllComponents()
                            self.populateControlsWithProvidedGoal()
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
        populatePlatformsPicker()
        populatePeriodsPicker()
    }
    
    func populatePlatformsPicker(){
        DMPlatform.getPlatforms { (platforms, error) in
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve platforms", andText: String(describing: error))
            } else {
                if let platforms = platforms {
                    self.platforms = platforms.sorted(by: {$0.name < $1.name})
                    UI {
                        self.platformPicker.reloadAllComponents()
                    }
                } else {
                    print("no error or platforms")
                }
            }
        }
    }
    
    func populatePeriodsPicker(){
        DMPeriod.getPeriods { (periods, error) in
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve time periods", andText: String(describing: error))
            } else {
                if let periods = periods {
                    self.periods = periods
                    UI {
                        self.periodPicker.reloadAllComponents()
                    }
                } else {
                    print("no error or periods")
                }
            }
        }
    }
    
    
    func populateControlsWithProvidedGoal(){
        if let goal = goal {
            if let application = goal.application {
                if let row = applications.index(where: { (app) -> Bool in
                    app.id == application.id
                }) {
                    applicationPicker.selectRow(row+1, inComponent: 0, animated: false)
                    
                }
            } else {
                applicationPicker.selectRow(0, inComponent: 0, animated: false)
            }
            if let platform = goal.platform{
                if let row = platforms.index(where: { (element) -> Bool in
                    element.id == platform.id
                }) {
                    platformPicker.selectRow(row+1, inComponent: 0, animated: false)
                }
            } else {
                platformPicker.selectRow(0, inComponent: 0, animated: false)
            }
            let (d, h, m, s) = goal.duration.asDaysHoursMinutesSeconds()
            daysTextField.text = String(d)
            hoursTextField.text = String(h)
            minutesTextField.text = String(m)
            if let periodRow = periods.index(where: { (element) -> Bool in
                element.id == goal.period.id
            }){
                periodPicker.selectRow(periodRow, inComponent: 0, animated: false)
            }
        }
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
        let index = applicationPicker.selectedRow(inComponent: 0)
        return index == 0 ? nil : applications[index-1]
    }
    
    func getChosenPlatform() -> DMPlatform? {
        let index = platformPicker.selectedRow(inComponent: 0)
        return index == 0 ? nil : platforms[index-1]
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
        return total
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        let duration = getDurationInSeconds()
        if duration < 1 {
            return presentErrorAlert(withTitle: "Save Failed", andText: "Please enter a duration greater than 0")
        }
        let period = periods[periodPicker.selectedRow(inComponent: 0)]
        let platform = getChosenPlatform()
        let application = getChosenApplication()
        let spinner = UIViewController.displaySpinner(onView: self.view)
        if var goal = goal {
            goal.application = application
            goal.platform = platform
            goal.duration = duration
            goal.period = period
            user.saveGoal(goal) { (error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
                } else {
                    UI{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            let newGoal = DMUser.UsageGoal(duration: duration, period: period, platform: platform, application: application)
            user.add(usageGoal: newGoal) { (goal, error) in
                UIViewController.removeSpinner(spinner: spinner)
                if let error = error {
                    self.presentErrorAlert(withTitle: "Save Failed", andText: String(describing: error))
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
    }

}
