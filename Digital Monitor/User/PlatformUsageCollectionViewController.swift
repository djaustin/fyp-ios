//
//  PlatformUsageCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 20/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/// Controller for Platform Usage Collection View. Manages layout of collection view as well
class PlatformUsageCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var startDate: Date?
    var endDate: Date?
    @IBOutlet weak var sortButton: UIBarButtonItem!
    var sortDescending = true
    var dataSource: [PlatformUsageData] = []
    var selectedPlatform: DMPlatform?
    var user: DMUser?
    
    @IBAction func sortButtonWasPressed(_ sender: UIBarButtonItem) {
        if sortDescending{
            sortDescending = false
            sender.image = #imageLiteral(resourceName: "NumericalSortAsc")
            dataSource.sort { (platform1, platform2) -> Bool in
                platform1.duration < platform2.duration
            }
            collectionView?.reloadData()
        } else {
            sortDescending = true
            sender.image = #imageLiteral(resourceName: "NumericalSortDes")
            dataSource.sort { (platform1, platform2) -> Bool in
                platform1.duration > platform2.duration
            }
            collectionView?.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(UsageTileView.self, forCellWithReuseIdentifier: reuseIdentifier)
        user = DMUser.authenticatedUser
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
        
        // Configure the cell
        if let usageTile = cell as? UsageTileView {
            usageTile.button.tag = indexPath.item
            usageTile.button.addTarget(self, action: #selector(tileButtonWasPressed(_:)), for: .touchUpInside)
            usageTile.button.isHidden = false
            usageTile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            usageTile.layer.borderWidth = 0.5
            usageTile.layer.cornerRadius = 0
            let platformData = dataSource[indexPath.item]
            usageTile.titleLabel.text = platformData.platform.name
            usageTile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: platformData.duration)
            usageTile.button.setTitle("View Apps", for: .normal)
            return usageTile
        }
    
        return cell
    }
    
    @objc func tileButtonWasPressed(_ button: UIButton){
        selectedPlatform = dataSource[button.tag].platform
        performSegue(withIdentifier: "showPlatform", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = view.frame.width/2
        return CGSize(width: halfWidth, height: halfWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlatformApplicationsCollectionViewController{
            vc.platform = selectedPlatform
            vc.startTime = startDate
            vc.endTime = endDate
        }
    }
    
}
