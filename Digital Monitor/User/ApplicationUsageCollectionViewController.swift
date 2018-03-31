//
//  ApplicationUsageCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 20/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/// Controller for the Application Usage Collection View. Also manages the layout of the collection view
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

        // Register cell classes
        self.collectionView!.register(UsageTileView.self, forCellWithReuseIdentifier: reuseIdentifier)
        dataSource.sort { (appOne, appTwo) -> Bool in
            appOne.duration > appTwo.duration
        }
        collectionView?.reloadData()
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
            usageTile.button.setTitle("View Platforms", for: .normal)
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
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ApplicationPlatformCollectionViewController {
            vc.application = selectedApplication
            vc.startTime = startDate
            vc.endTime = endDate
        }
    }

}
