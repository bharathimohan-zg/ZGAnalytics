//
//  LoginViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 25/11/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit
var hexaColor = "#F16BB6"

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userTxtFld: UITextField!
    @IBOutlet weak var pwdLoginTxtFld: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.navigationBar.isHidden = true
            navigationController?.toolbar.isHidden = true
            navigationController?.tabBarController?.tabBar.isHidden = true
            navigationController?.navigationBar.barTintColor = LoginViewController.hexStringToUIColor(hex: hexaColor)
            userTxtFld.setBottomBorder()
            pwdLoginTxtFld.setBottomBorder()
            loginBtn.layer.cornerRadius = 5
            loginBtn.isUserInteractionEnabled = false
            loginBtn.alpha = 0.5
            [userTxtFld, pwdLoginTxtFld].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })

            if let templateImage = UIImage(named: "userIcon")?.withRenderingMode(.alwaysTemplate) {            let imageView = UIImageView(image: templateImage)
                imageView.tintColor = LoginViewController.hexStringToUIColor(hex: hexaColor)
                userTxtFld.rightViewMode = .always
                userTxtFld.rightView = imageView
            }
            if let templateImage = UIImage(named: "Password")?.withRenderingMode(.alwaysTemplate) {            let imageView = UIImageView(image: templateImage)
                imageView.tintColor = LoginViewController.hexStringToUIColor(hex: hexaColor)
                pwdLoginTxtFld.rightViewMode = .always
                pwdLoginTxtFld.rightView = imageView
            }
        }
        override func viewDidAppear(_ animated: Bool) {
            navigationController?.navigationBar.barStyle = .black
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
                userTxtFld.setBottomBorder()
                pwdLoginTxtFld.setBottomBorder()
                loginBtn.layer.cornerRadius = 5
                loginBtn.isUserInteractionEnabled = false
                loginBtn.alpha = 0.5
            [userTxtFld, pwdLoginTxtFld].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
            userTxtFld.text = ""
            pwdLoginTxtFld.text = ""
        }

        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }

        @IBAction func signInAction(_ sender: Any) {
            var loginInfoDict: [String: Any] = [:]
            loginInfoDict["username"] = userTxtFld.text
            loginInfoDict["password"] = pwdLoginTxtFld.text
            loadingViewManager.sharedInstance.showLoadingScreen()
            WBInstoreNetworkManager.shared.getLoginDetail(withDetails: loginInfoDict) { (LoginInfoList) in
                loadingViewManager.sharedInstance.hideLoadingScreen()
                if LoginInfoList.count > 0 {
                    if LoginInfoList.keys.contains("Success") {
                        let status = DashBoardViewController.nullToBool(value: LoginInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                        if status == "true" {
                            let loginList = LoginInfoList["Data"] as? [[String: Any]]
                            if (loginList?.first!.count)! > 0 {
                                loginDict = (loginList?.first)!
                            }
                            UserDefaults.standard.set(true, forKey: "myKey")
                            UserDefaults.standard.set(loginDict, forKey: "loginInfo")
                            self.performSegue(withIdentifier: "DashboardSegue", sender: nil)
                        } else {
                           let message = DashBoardViewController.nullToBool(value: LoginInfoList[JSONKeys.Data.rawValue] as? String) as! String
                            self.presentAlertWithTitle(title: nil, message: message, actions: ["OK"], completion: { (_: Int) in
                            })
                        }
                    }
                } else {
                     self.presentAlertWithTitle(title: nil, message: "Server Down!", actions: ["OK"], completion: { (_: Int) in
                     })

                }
            }
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    func presentAlertWithTitle(title: String?, message: String?, actions: [String], preferredActionIndex: Int = 0, completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, action) in actions.enumerated() {
            let alertAction = UIAlertAction.init(title: action, style: .default) { (_: UIAlertAction) in
                completion(index)
            }
            alertController.addAction(alertAction)
            if index == preferredActionIndex {
                alertController.preferredAction = alertAction
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let userId = userTxtFld.text, !userId.isEmpty,
            let password = pwdLoginTxtFld.text, !password.isEmpty
        else {
            self.loginBtn.isUserInteractionEnabled =   false
            self.loginBtn.alpha =  0.5
            return
        }
        self.loginBtn.isUserInteractionEnabled = true
        self.loginBtn.alpha =   1
    }
       
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "DashboardSegue") {
                DispatchQueue.main.async {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "AnimateTabbarViewController") as! AnimateTabbarViewController
                    self.present(next, animated: true, completion: nil)
                }
            }
        }

        class func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }

    extension UITextField {
        func setBottomBorder() {
            self.borderStyle = .none
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 0.0
        }
    }
