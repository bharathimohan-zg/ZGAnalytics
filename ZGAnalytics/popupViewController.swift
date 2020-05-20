//
//  popupViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 23/02/20.
//  Copyright © 2020 Bharathimohan. All rights reserved.
//

import UIKit
var popupTextInfo:String = ""
class popupViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var popupText: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = LoginViewController.hexStringToUIColor(hex: hexaColor)
        popupText.text = popupTextInfo
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let image = self.view.takeScreenshot()
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.removeAnimate()
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }

}
extension UIView {

    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
