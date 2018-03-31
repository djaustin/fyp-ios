//
//  ApplicationPlatformCollectionViewController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 12/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

/// Controller for Application Platform Collection View. Also manages layout of the collection view
class ApplicationPlatformCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var startTime: Date?
    var endTime: Date?
    var application: DMApplication?
    var dataSource: [PlatformUsageData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UsageTileView.self, forCellWithReuseIdentifier: reuseIdentifier)
        if let user = getUserOrReturnToLogin(withSegueIdentifier: "logout") {
            if let application = application{
                navigationItem.title = application.name
                if let startTime = startTime {
                    if let endTime = endTime {
                        let fromTime = startTime.timeIntervalSince1970*1000
                        let toTime = endTime.timeIntervalSince1970*1000
                        let query = [
                            "fromTime": String(fromTime),
                            "toTime": String(toTime)
                        ]
                        let spinner = UIViewController.displaySpinner(onView: self.view, withStyle: .gray, withBackground: false)
                        user.getPlatformMetrics(forApplication: application, withQuery: query) { (data, error) in
                            UIViewController.removeSpinner(spinner: spinner)
                            if let error = error {
                                self.presentErrorAlert(withTitle: "Unable to retrieve platform usage", andText: String(describing: error))
                            } else {
                                if let data = data {
                                    self.dataSource = data.sorted(by: {$0.duration > $1.duration})
                                    UI {
                                        self.collectionView?.reloadData()
                                    }
                                } else {
                                    print("No data or error")
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
        if let tile = cell as? UsageTileView{
            tile.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            tile.layer.borderWidth = 0.5
            tile.layer.cornerRadius = 0
            tile.titleLabel.text = dataSource[indexPath.item].platform.name
            tile.usageTimeLabel.text = String(digitalClockFormatFromSeconds: dataSource[indexPath.item].duration)
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
    
}
