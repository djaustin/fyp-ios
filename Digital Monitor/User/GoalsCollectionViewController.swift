//
//  GoalsCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GoalsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    
    var dataSource: [DMUser.UsageGoal] = []
    var user: DMUser!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout"){
            self.user = user
            dataSource = user.usageGoals
            user.getUsageGoalProgress(onCompletion: { goals, error in
                if let error = error {
                    print(error)
                } else {
                    if let goals = goals {
                        self.dataSource = goals
                        debugPrint("UPDATE DATASOURCE", self.dataSource)
                        UI {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            })
            
        }
        // Register cell classes
        self.collectionView!.register(GoalTileView.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let usageTile = cell as? GoalTileView {
            let goal = dataSource[indexPath.item]
            if let appId = goal.applicationId {
                DMApplication.getApplication(byId: appId, onCompletion: { (app, error) in
                    if let error = error {
                        print(error)
                        UI {
                            usageTile.titleLabel.text = "ERROR"
                        }

                    } else {
                        if let app = app {
                            UI {
                                if let platform = goal.platform {
                                    usageTile.titleLabel.text = app.name
                                    usageTile.subtitleLabel.text = platform
                                    
                                } else {
                                    usageTile.titleLabel.text = app.name
                                }
                                usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: goal.duration)
                            }
                        }
                    }
                })
            } else {
                usageTile.titleLabel.text = goal.platform
                usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: goal.duration)
            }
            debugPrint("GOAL", goal)
            if let progress = goal.progress{
                usageTile.progressRing.value = CGFloat(progress*100)
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
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension UIViewController {
    func getUserOrReturnToLogin(withSegueIdentifier identifier: String) -> DMUser? {
        guard let user = DMUser.authenticatedUser else {
            performSegue(withIdentifier: identifier, sender: self)
            return nil
        }
        return user
    }
}
