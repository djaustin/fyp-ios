//
//  ApplicationUsageCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 20/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ApplicationUsageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var startDate: Date?
    var endDate: Date?
    @IBOutlet weak var sortButton: UIBarButtonItem!
    var dataSource: [ApplicationUsageData] = []
    var sortDescending = true
    var selectedApplication: DMApplication?
    
    @IBAction func sortButtonWasPressed(_ sender: UIBarButtonItem) {
        if sortDescending{
            sortDescending = false
            sender.image = #imageLiteral(resourceName: "NumericalSortAsc")
            dataSource.sort { (app1, app2) -> Bool in
                app1.duration < app2.duration
            }
            collectionView?.reloadData()
        } else {
            sortDescending = true
            sender.image = #imageLiteral(resourceName: "NumericalSortDes")
            dataSource.sort { (app1, app2) -> Bool in
                app1.duration > app2.duration
            }
            collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UsageTileView.self, forCellWithReuseIdentifier: reuseIdentifier)
        dataSource.sort { (appOne, appTwo) -> Bool in
            appOne.duration > appTwo.duration
        }
        collectionView?.reloadData()

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
    
        if let usageTile = cell as? UsageTileView {
            usageTile.button.tag = indexPath.item
            usageTile.button.addTarget(self, action: #selector(tileButtonWasPressed(_:)), for: .touchUpInside)
            usageTile.button.isHidden = false
            usageTile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            usageTile.layer.borderWidth = 0.5
            usageTile.layer.cornerRadius = 0
            let applicationUsage = dataSource[indexPath.item]
            usageTile.titleLabel.text = applicationUsage.application.name
            usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: applicationUsage.duration)
            return usageTile
        }
        // Configure the cell
    
        return cell
    }
    
    @objc func tileButtonWasPressed(_ button: UIButton){
        selectedApplication = dataSource[button.tag].application
        performSegue(withIdentifier: "showApplication", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ApplicationPlatformCollectionViewController {
            vc.application = selectedApplication
            vc.startTime = startDate
            vc.endTime = endDate
        }
    }

}
