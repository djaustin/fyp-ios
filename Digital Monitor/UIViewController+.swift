//
//  UIViewController+.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Presents an alert view dialog on the view controller with the title and text provided
    ///
    /// - Parameters:
    ///   - title: The title of the dialog
    ///   - text: The text in the dialog box
    func presentErrorAlert(withTitle title: String, andText text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UI {
            self.present(alert, animated: true, completion: nil)
        }
    }

    
//    The following spinner functions are provided by "admin" at Brainwash Inc. http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
    class func displaySpinner(onView : UIView, withStyle style: UIActivityIndicatorViewStyle = .whiteLarge, withBackground: Bool = true) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        if(withBackground){
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        }
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: style)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }    
}
