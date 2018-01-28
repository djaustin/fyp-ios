//
//  UsageTileView.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit
import UICircularProgressRing

class GoalTileView: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var progressRing: UICircularProgressRingView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("GoalTileView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        titleLabel.adjustsFontSizeToFitWidth = true
        usageTimeLabel.adjustsFontSizeToFitWidth = true
        
    

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
