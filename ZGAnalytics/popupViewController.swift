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
    @IBOutlet weak var popupText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = LoginViewController.hexStringToUIColor(hex: hexaColor)
        popupText.text = popupTextInfo
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
