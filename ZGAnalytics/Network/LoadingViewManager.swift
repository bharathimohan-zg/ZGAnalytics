//
//  LoadingViewManager.swift
//  Govberg
//
//  Created by Anthony Detamore on 2/11/16.
//  Copyright © 2016 ___GOVBERG___. All rights reserved.
//

import Foundation
import UIKit
class loadingViewManager {
    
    static var sharedInstance = loadingViewManager()
    fileprivate var blurViewContainer: UIView!
    fileprivate var indicator: UIActivityIndicatorView!
    fileprivate var label: UILabel!
    fileprivate var window: UIWindow { return UIApplication.shared.keyWindow! }

    func showLoadingScreen() {
        addBlurContainer()
        addLoadingIndicator()
        addLoadingLabel()
        
        blurViewContainer.isHidden = false
        self.window.bringSubviewToFront(self.blurViewContainer)
        indicator.startAnimating()
    }
    
    func hideLoadingScreen() {
        if blurViewContainer != nil {
            blurViewContainer.isHidden = true
            indicator.stopAnimating()
        }
    }
    
    fileprivate func addBlurContainer() {
        if blurViewContainer == nil {
            let blur = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blur)
            
            let width = window.bounds.size.width / 2 * 0.8
            let height = width
            let x = (window.bounds.size.width / 2) - (width / 2)
            let y = (window.bounds.size.height / 2) - (height / 2)
            
            blurView.frame = CGRect(x: x, y: y, width: width, height: height)
            blurView.layer.cornerRadius = 14
            blurView.layer.masksToBounds = true
            
            blurViewContainer = UIView(frame: window.bounds)
            blurViewContainer.backgroundColor = UIColor.heavyTextColor(0.2)
            blurViewContainer.isHidden = true
            
            blurViewContainer.addSubview(blurView)
            window.addSubview(blurViewContainer)
        }
    }

    fileprivate func addLoadingIndicator() {
        if indicator == nil {
            indicator = UIActivityIndicatorView(style: .whiteLarge)
            
            let height: CGFloat = blurViewContainer.frame.size.height / 2
            let width: CGFloat = blurViewContainer.frame.size.width / 2
            let iHeight: CGFloat = (indicator.frame.size.height / 2)
            let iWidth: CGFloat = (indicator.frame.size.width / 2)
            let x = width - iWidth
            let y = height - iHeight - 13
            indicator.frame = CGRect(x: x, y: y, width: indicator.frame.size.width, height: indicator.frame.size.height)
            blurViewContainer.addSubview(indicator)
        }
    }
    
    fileprivate func addLoadingLabel() {
        if label == nil {
            label = UILabel(frame: CGRect(x: 0, y: indicator.frame.size.height + indicator.frame.origin.y + 14, width: blurViewContainer.frame.size.width, height: 20))
            label.font = UIFont(name:"Ubuntu-Light", size:14)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.text = "Loading..."
            blurViewContainer.addSubview(label)
        }
    }
}

extension UIColor {
    static func heavyTextColor(_ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(white: CGFloat(414141), alpha: alpha)
    }
}
