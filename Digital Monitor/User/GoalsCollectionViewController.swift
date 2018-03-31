//
//  GoalsCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/// Controller for the Usage Goals Collection View
class GoalsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var goalApplications: [String:DMApplication] = [:]
    var selectedGoal: DMUser.UsageGoal?
    var dataSource: [DMUser.UsageGoal] = []
    var user: DMUser!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(GoalTileView.self, forCellWithReuseIdentifier: reuseIdentifier)
        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout"){
            self.user = user
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataSource = user.usageGoals
        let spinner = UIViewController.displaySpinner(onView: self.view, withStyle: .gray, withBackground: false)
        user.getUsageGoalProgress(onCompletion: { goals, error in
            UIViewController.removeSpinner(spinner: spinner)
            if let error = error {
                self.presentErrorAlert(withTitle: "Unable to retrieve goal progress", andText: String(describing: error))
            } else {
                if let goals = goals {
                    self.dataSource = goals
                    UI {
                        self.collectionView?.reloadData()
                        self.textAddButton.isHidden = goals.count > 0
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let usageTile = cell as? GoalTileView {
            let goal = dataSource[indexPath.item]
            if let app =  goal.application {
                if let platform = goal.platform {
                    usageTile.titleLabel.text = app.name
                    usageTile.subtitleLabel.text = "\(platform.name) - \(goal.period.name)"
                    
                } else {
                    usageTile.titleLabel.text = app.name
                    usageTile.subtitleLabel.text = goal.period.name
                }
                usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: goal.duration)

            }else {
                print("GOAL NO APP ID", goal)
                usageTile.titleLabel.text = goal.platform?.name
                usageTile.subtitleLabel.text = goal.period.name
                usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: goal.duration)
            }
            debugPrint("GOAL", goal)
            if let progress = goal.progress{
                usageTile.progressRing.setProgress(value: CGFloat(progress*100), animationDuration: 2)
                if progress >= 1 {
                    usageTile.progressRing.innerRingColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                } else if progress >= 0.75{
                    usageTile.progressRing.innerRingColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                } else {
                    usageTile.progressRing.innerRingColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                }
                debugPrint("PROGRESS BEING ADDED", usageTile.progressRing.value)
            }
            
            usageTile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            usageTile.layer.borderWidth = 0.5
            usageTile.layer.cornerRadius = 0
            return usageTile
        }
        // Configure the cell
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = view.frame.width/2
        return CGSize(width: halfWidth, height: halfWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    @IBOutlet weak var textAddButton: UIButton!
    @IBAction func addButtonWasPressed(_ sender: Any) {
        selectedGoal = nil
        performSegue(withIdentifier: "goalDetail", sender: self)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGoal = dataSource[indexPath.item]
        performSegue(withIdentifier: "goalDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GoalDetailViewController {
            vc.goal = selectedGoal
        }
    }
}

// Extension that provides a way that either returns the currently logged in user or performs a named segue eg. 'Logout'
extension UIViewController {
    func getUserOrReturnToLogin(withSegueIdentifier identifier: String) -> DMUser? {
        guard let user = DMUser.authenticatedUser else {
            performSegue(withIdentifier: identifier, sender: self)
            return nil
        }
        return user
    }
}
