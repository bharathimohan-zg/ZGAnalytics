//
//  ProfileViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 02/12/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit


class profileViewCell: UITableViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var name: UILabel!
}


class profileInfoViewCell: UITableViewCell {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileType: UILabel!
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTableview: UITableView!
    
    var profileArray: [String] = []
    var profileDictVal: [String: String] = [:]
    var profileTypeArray: [String] = []
    var profileUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProfileInformation()
        // Do any additional setup after loading the view.
    }
    @IBAction func logOut(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func getProfileInformation()  {
        var loginInfoDict: [String: Any] = [:]
        loginInfoDict["empcode"] = "1001"
                    loadingViewManager.sharedInstance.showLoadingScreen()
                WBInstoreNetworkManager.shared.getProfileInfo(withDetails: loginInfoDict) { (profileListDict) in
                    loadingViewManager.sharedInstance.hideLoadingScreen()
                    if profileListDict.count > 0 {
                        if profileListDict.keys.contains("Success") {
                        let status = DashBoardViewController.nullToBool(value: profileListDict[JSONKeys.Success.rawValue] as? Bool) as! String
                        if status == "true" {
                            let profileInfoList = profileListDict["Data"] as? [[String: Any]]
                        for profileDict in profileInfoList!
                        {
                            let EmployeeName =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.Employee.rawValue] as? String) as! String
                            let Designation =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.Designation.rawValue] as? String) as! String
                            let Branch =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.Branch.rawValue] as? String) as! String
                            let EmpCode =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.EmpCode.rawValue] as? String) as! String
                            let mailid =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.mailid.rawValue] as? String) as! String
                            let Contact =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.Contact.rawValue] as? NSNumber) as! String
                            self.profileUrl =  DashBoardViewController.nullToNil(value: profileDict[JSONKeys.profileurl.rawValue] as? String) as! String

                            self.profileDictVal["EmployeeName"] = EmployeeName
                            self.profileDictVal["Designation"] = Designation
                            self.profileArray.append("")
                            self.profileArray.append(EmpCode)
                            self.profileTypeArray.append("Employee Id")
                            self.profileArray.append(mailid)
                            self.profileTypeArray.append("MailId")
                            self.profileArray.append(Contact)
                            self.profileTypeArray.append("Mobile")
                            self.profileArray.append(Branch)
                            self.profileTypeArray.append("Branch")

                        }
                            if self.profileArray.count > 0 {
                                DispatchQueue.main.async {
                                    self.profileTableview.reloadData()
                                }
                            }
                    }
                }
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileArray.count > 0 ? profileArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let promotionCell = profileTableview.dequeueReusableCell(withIdentifier: "profileIdentifier", for: indexPath) as? profileViewCell else {
                return UITableViewCell()
            }
            promotionCell.name.text = self.profileDictVal["EmployeeName"]
            promotionCell.designation.text = self.profileDictVal["Designation"]
            promotionCell.profileImg.layer.borderWidth = 1
            promotionCell.profileImg.layer.masksToBounds = false
            promotionCell.profileImg.layer.borderColor = UIColor.lightGray.cgColor
            promotionCell.profileImg.layer.cornerRadius = promotionCell.profileView.frame.height/2
            promotionCell.profileImg.clipsToBounds = true
            promotionCell.profileImg.downloaded(from:profileUrl)
            return promotionCell
        } else {
            guard let promotionCell = profileTableview.dequeueReusableCell(withIdentifier: "profileInfoIdentifier", for: indexPath) as? profileInfoViewCell else {
                return UITableViewCell()
            }
            promotionCell.profileName.text = profileArray[indexPath.row]
            promotionCell.profileType.text = profileTypeArray[indexPath.row - 1]

            return promotionCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 193 : 60
    }

}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
