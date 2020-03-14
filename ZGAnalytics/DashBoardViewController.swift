//
//  DashBoardViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 25/11/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit

class LocationCell: UICollectionViewCell {
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var selectIcon: UIImageView!
    @IBOutlet weak var locationName: UILabel!
}

class DashboardHeader: UICollectionReusableView {
    @IBOutlet weak var branchName: UILabel!
}
class dashBoardObject {
    var branchName: String, brancheId: String, isSelectedVal: Bool, branchDict: [String: Any]?
    init(branchName: String, brancheId: String, isSelectedVal: Bool, branchDict: [String: Any]?) {
        self.branchName = branchName
        self.brancheId = brancheId
        self.isSelectedVal = isSelectedVal
        self.branchDict = branchDict
    }
}

class DashBoardViewController: UIViewController {

    @IBOutlet weak var dashbordSegment: UISegmentedControl!
    @IBOutlet weak var dashBoardCollectionVIew: UICollectionView!
    @IBOutlet weak var analyticBtn: UIButton!
    private let spacing:CGFloat = 15.0
    let hrmList = ["Headcount": "StaffCount", "Attendance": "Interview", "Interview": "ApplicationCount"]
    let sapList: [String: Any] = [:]
    let analyticDict = ["Headcount" : "StaffCount", "Attendance" : "AttendanceCount", "Interview" : "ApplicationCount"]

    let branch = ["CHN" : "Chennai", "CBE" : "Coimbatore", "HYD" : "Hyderabad","BLR" : "Bangalore", "MDU" : "Madurai", "MUM" : "Mumbai"]

    var branchNameInput: String = "", branchTypeInput: String = "", type: String = ""
    struct dashboardItem {
        var branchType:String,branchList: [dashBoardObject],isselected:Bool
        init(branchType: String,isselected: Bool, branchList: [dashBoardObject] ) {
            self.branchType = branchType
            self.isselected = isselected
            self.branchList = branchList
        }
    }
    var dashboardList = [dashboardItem]()
    var dashboardInfoList = [dashboardItem]()
    let loginInfo:[String: Any] = UserDefaults.standard.object(forKey: "loginInfo") as! [String : Any]

    override func viewDidLoad() {
        super.viewDidLoad()
        dashBoardCollectionVIew.delegate = self
        dashBoardCollectionVIew.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.dashBoardCollectionVIew?.collectionViewLayout = layout
        analyticBtn.layer.cornerRadius = 5
        analyticBtn.isUserInteractionEnabled = false
        analyticBtn.alpha = 0.5
        setupSegmentedControl()
        let Access = self.loginInfo[JSONKeys.Access.rawValue] as! String
        dashbordSegment.removeAllSegments()
        if Access.contains("HRM - ALL") && Access.contains("SAP - ALL") {
            type = "HRM"
            dashbordSegment.insertSegment(withTitle: "HRM", at: 0, animated: false)
            dashbordSegment.insertSegment(withTitle: "SAP", at: 1, animated: false)
        }  else if Access.contains("HRM - ALL") && Access.contains("SAP - SALES") {
            type = "HRM"
            dashbordSegment.insertSegment(withTitle: "HRM", at: 0, animated: false)
            dashbordSegment.insertSegment(withTitle: "SAP", at: 1, animated: false)
        } else if Access.contains("HRM - ALL") {
            type = "HRM"
            dashbordSegment.insertSegment(withTitle: "HRM", at: 0, animated: false)
        }
        else if Access.contains("SAP - ALL") || Access.contains("SAP - SALES") {
            type = "SAP"
            dashbordSegment.insertSegment(withTitle: "SAP", at: 0, animated: false)
        }
        dashbordSegment.selectedSegmentIndex = 0

         dashbordSegment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Ubuntu-Light", size: 16)!], for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 18)!]

        navigationController?.navigationBar.barTintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
               if #available(iOS 13.0, *) {
                  dashbordSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                  dashbordSegment.selectedSegmentTintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
               } else {
                  dashbordSegment.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
               }
        self.getBranchList(branchTitle: type)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        branchNameInput = ""
//        branchTypeInput = ""
//        dashbordSegment.selectedSegmentIndex = 0
//        analyticBtn.isUserInteractionEnabled = false
//        analyticBtn.alpha = 0.5
//        type = "HRM"
//        self.getBranchList(branchTitle: "HRM")
    }
    
    private  func setupSegmentedControl() {
          branchNameInput = ""
          branchTypeInput = ""
        if #available(iOS 13.0, *) {
           dashbordSegment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
           dashbordSegment.selectedSegmentTintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        } else {
           dashbordSegment.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        }

          dashbordSegment.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
      }
      
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        let segmentTitle = sender.titleForSegment(at: sender.selectedSegmentIndex)
        type = segmentTitle!
        self.getBranchList(branchTitle: segmentTitle!.isEmpty ? "" : segmentTitle!)
      }
          
    @IBAction func analyticAction(_ sender: Any) {
//        self.performSegue(withIdentifier: "AnalyticSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "AnalyticSegue") {
//            DispatchQueue.main.async {
//                let next = self.storyboard?.instantiateViewController(withIdentifier: "AnalyticsViewController") as! AnalyticsViewController
//                self.navigationController?.pushViewController(next, animated: true)
////                self.present(next, animated: true, completion: nil)
//            }
//        }
    }

    
    @IBAction func logoutAction(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: "myKey")
            UserDefaults.standard.removeObject(forKey: "loginInfo")
        let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vcObj = main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        self.navigationController?.pushViewController(vcObj, animated: true)
        }
    }
    
    func getBranchList(branchTitle: String)  {
                loadingViewManager.sharedInstance.showLoadingScreen()
            WBInstoreNetworkManager.shared.getBranchList(withDetails: branchTitle) { (branchListDict) in
                loadingViewManager.sharedInstance.hideLoadingScreen()
                if branchListDict.count > 0 {
                    self.dashboardList.removeAll()
                    self.dashboardInfoList.removeAll()
                    if branchListDict.keys.contains("Success") {
                    var branchListValue = dashboardItem(branchType: "BRANCH WISE", isselected: false, branchList: [])
                    let status = DashBoardViewController.nullToBool(value: branchListDict[JSONKeys.Success.rawValue] as? Bool) as! String
                    if status == "true" {
                        let branchobjectList = branchListDict["Data"] as? [[String: Any]]
                    for branchDict in branchobjectList!
                    {
                        let branchName =  DashBoardViewController.nullToNil(value: branchDict[branchTitle == "HRM" ? JSONKeys.branchname.rawValue : JSONKeys.BPLName.rawValue] as? String) as! String
                        let brancId =  DashBoardViewController.nullToNil(value: branchDict[branchTitle == "HRM" ? JSONKeys.bid.rawValue : JSONKeys.BPLId.rawValue ] as? NSNumber) as! String
                        let branchInfo = dashBoardObject(branchName: branchName, brancheId: brancId, isSelectedVal: false, branchDict: branchDict)
//                        let loginInfo:[String: Any] = UserDefaults.standard.object(forKey: "loginInfo") as! [String : Any]
                        let branchNameVal = DashBoardViewController.nullToNil(value: self.loginInfo[JSONKeys.branch.rawValue] as? String) as! String
                        if branchNameVal == "PAN INDIA" {
                        branchListValue.branchList.append(branchInfo)
                        } else {

                            if branchTitle == "HRM" {
                            if branchNameVal ==  branchName {
                                branchListValue.branchList.append(branchInfo)
                            }
                            } else {
                        
                                if branchNameVal == self.branch[branchName]
                                {
                                branchListValue.branchList.append(branchInfo)
                                }
                            }
                        }
                    }
                    }
                        if branchListValue.branchList.count > 0 {
                        self.dashboardList.append(branchListValue)
                        var branchHrmList = dashboardItem(branchType: (branchTitle == "HRM") ? "HRM" : "SAP", isselected: false, branchList: [])
                            if branchTitle == "HRM" {
                                for branchName in self.hrmList
                                {
                                    let branchDict = dashBoardObject(branchName: branchName.key, brancheId: branchName.value, isSelectedVal: false, branchDict: [:])
                                    branchHrmList.branchList.append(branchDict)
                                }
                                self.dashboardList.append(branchHrmList)
                                self.dashboardInfoList = self.dashboardList
                                    DispatchQueue.main.async {
                                    self.dashBoardCollectionVIew.reloadData()
                                }
                            } else {
                                WBInstoreNetworkManager.shared.getDepartmentList(withDetails: [:]) { (sapListDict) in
                                if branchListDict.keys.contains("Success") {
                                let status = DashBoardViewController.nullToBool(value: sapListDict[JSONKeys.Success.rawValue] as? Bool) as! String
                                if status == "true" {
                                    branchHrmList.branchList.removeAll()
                                    let branchobjectList = sapListDict["Data"] as? [[String: Any]]
                                    for branchDict in branchobjectList!
                                    {
                                        let branchName =  DashBoardViewController.nullToNil(value: branchDict[JSONKeys.Name.rawValue] as? String) as! String
                                        let branchCode =  DashBoardViewController.nullToNil(value: branchDict[JSONKeys.Code.rawValue] as? NSNumber) as! String
                                        let parsedBranch = branchName.replacingOccurrences(of: " Department", with: "")
                                        let branchDict = dashBoardObject(branchName: parsedBranch, brancheId: branchCode, isSelectedVal: false, branchDict: [:])
                                        let Access = self.loginInfo[JSONKeys.Access.rawValue] as! String
                                        if Access.contains("SAP - ALL") {
                                        branchHrmList.branchList.append(branchDict)
                                        } else if Access.contains("SAP - SALES") {
                                            if branchName == "Sales Department" {
                                            branchHrmList.branchList.append(branchDict)
                                            }
                                        }
                                    }
                                    self.dashboardList.append(branchHrmList)
                                    if branchHrmList.branchList.count > 0 {
                                    self.dashboardInfoList = self.dashboardList
                                        DispatchQueue.main.async {
                                        self.dashBoardCollectionVIew.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
    
}

extension DashBoardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dashboardList.count
    }
     func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerIdentifier", for: indexPath) as! DashboardHeader
        headerView.branchName.text = self.dashboardList[indexPath.section].branchType
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.dashboardList[section].branchList.count > 0 ? self.dashboardList[section].branchList.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCellIdentifier", for: indexPath as IndexPath) as! LocationCell
         if indexPath.section == 0 {
            if let templateImage = UIImage(named: type == "HRM" ? "Branch" : "HRMHOME" )?.withRenderingMode(.alwaysTemplate) {
            let imageView = UIImageView(image: templateImage)
            cell.locationIcon.image = imageView.image
            cell.locationIcon.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        }
        if let templateImage = UIImage(named: "select")?.withRenderingMode(.alwaysTemplate) {
            let imageView = UIImageView(image: templateImage)
            cell.selectIcon.image = imageView.image
            cell.selectIcon.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        }
         } else {
            if let templateImage = UIImage(named: self.dashboardList[indexPath.section].branchList[indexPath.row].branchName)?.withRenderingMode(.alwaysTemplate) {
                let imageView = UIImageView(image: templateImage)
                cell.locationIcon.image = imageView.image
                cell.locationIcon.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
            }
        }
        let branchDict =  self.dashboardList[indexPath.section].branchList[indexPath.row]
        cell.selectIcon.isHidden =  self.dashboardList[indexPath.section].branchList[indexPath.row].isSelectedVal ? false : true
        cell.locationName.text = branchDict.branchName
        cell.layer.cornerRadius = 4.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor.white
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        branchName = self.dashboardList[indexPath.section].branchList[indexPath.row].branchName
        branchcode = self.dashboardList[indexPath.section].branchList[indexPath.row].brancheId
        } else {
             subBranchCode  = self.dashboardList[indexPath.section].branchList[indexPath.row].brancheId
        }
        self.selectLocation(selectedIndexPath: indexPath)
    }

    func selectLocation(selectedIndexPath: IndexPath) {
        let selectedBranch =  self.dashboardInfoList[selectedIndexPath.section].branchType
        let BranchName =  self.dashboardInfoList[selectedIndexPath.section].branchList[selectedIndexPath.row].branchName
        for location in self.dashboardInfoList
        {
            if  location.branchType == selectedBranch
            {
                self.dashboardList[selectedIndexPath.section].branchList.removeAll()
                for selectedLocationDict in self.dashboardInfoList[selectedIndexPath.section].branchList {
                    if BranchName == selectedLocationDict.branchName
                    {
                    selectedLocationDict.isSelectedVal = !selectedLocationDict.isSelectedVal
                        if selectedIndexPath.section == 0 {
                            branchNameInput = selectedLocationDict.isSelectedVal ? selectedLocationDict.branchName : ""
                        } else if selectedIndexPath.section == 1
                        {
                            branchTypeInput = selectedLocationDict.isSelectedVal ? selectedLocationDict.branchName : ""
                        }
                    } else {
                        selectedLocationDict.isSelectedVal = false
                    }
            self.dashboardList[selectedIndexPath.section].branchList.append(selectedLocationDict)
                }
            }
        }
        self.dashboardInfoList = self.dashboardList
        DispatchQueue.main.async {
            self.analyticBtn.isUserInteractionEnabled =  (self.branchNameInput.isEmpty != true &&  self.branchTypeInput.isEmpty != true) ? true : false
            self.analyticBtn.alpha =  (self.branchNameInput.isEmpty != true &&  self.branchTypeInput.isEmpty != true) ? 1 : 0.5
            self.dashBoardCollectionVIew.reloadData()
        }
    }
}

extension DashBoardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 15
        let totalSpacing = (3 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
       if let collection = self.dashBoardCollectionVIew{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

}

extension DashBoardViewController {
    
class func nullToBool(value : Any?) -> Any? {
        if value is NSNull || value == nil {
            return "" as Any?
        } else {
        if let value = value {
            return "\(value)"
        }
        else {
            return ""
        }
    }
}
    
class func nullToNil(value : Any?) -> Any? {
        if value is NSNull || value == nil {
            return "" as Any?
        } else {
            if let a = value as? NSNumber {
                return a.stringValue
            } else {
                return (value as! String).uppercased() == "NULL"  ? "" : value
            }
        }
    }

}

