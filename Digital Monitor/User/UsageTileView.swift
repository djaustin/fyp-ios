//
//  UsageTileView.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import UIKit

/// Custom collection view cell used as a reusable component for usage views
class UsageTileView: UICollectionViewCell {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("UsageTileView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        informationLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontSizeToFitWidth = true
        usageTimeLabel.adjustsFontSizeToFitWidth = true
        
    

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
