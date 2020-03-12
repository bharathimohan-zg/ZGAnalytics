//
//  AnalyticDetailsViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 19/12/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit


struct staffListStruct {
    var name: String, iD: String, department:String, salary:String
    init(name: String, iD: String, department: String, salary: String) {
        self.name = name
        self.iD = iD
        self.department = department
        self.salary = salary
    }
}
class AnalyticDetailsViewController: UIViewController {
    @IBOutlet weak var analyticCollectionView: UICollectionView!
    private let spacing:CGFloat = 0.0

    var analyticArray: [String] = []
    var staffList = [staffListStruct]()
    override func viewDidLoad() {
        super.viewDidLoad()
        analyticCollectionView.delegate = self
        analyticCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.analyticCollectionView?.collectionViewLayout = layout
        if subBranchCode == "ApplicationCount" {
           analyticArray =  ["Name","Designation","OverAllWorkExp","ExpectedSalary"]
            self.getApplicationList()
            } else if (status == "Leads Count") {
            analyticArray =  ["BranchName","AgentName","TotalLead Count"]
             self.getTotalLeads()
            }  else if (status == "Rejected Count") {
                analyticArray =  ["BranchName","AgentName","TotalRejected Count"]
                 self.getTotalLeads()
            } else if (status == "Open Enquiry Count") {
            analyticArray =  ["BranchName","AgentName","TotalOpenEnqiry Count"]
             self.getTotalLeads()
            } else if (status == "Almost Confirmed Count") {
            analyticArray =  ["BranchName","AgentName","TotalAlmost Count"]
            self.getTotalLeads()
    
            }  else if (status == "Closed Enquiry Count") {
            analyticArray =  ["BranchName","AgentName","TotalClosed Count"]
            self.getTotalLeads()
    
            }  else if (status == "Followup Count") {
            analyticArray =  ["BranchName","AgentName","TotalFollowup Count"]
            self.getTotalLeads()
    
            }  else if (status == "Source Count") {
            analyticArray =  ["BranchName","AgentName","TotalSource Count"]
            self.getTotalLeads()
            }
            else if (status == "Rejected Enquiry") {
                analyticArray =  ["BranchName","EnquiryNo","Status"]
                 self.getTotalLeads()
            }
            else if (status == "Total Sales") {
                analyticArray =  ["BranchName","SalesAgent","Amount"]
                 self.getTotalLeads()
            }
            else if (status == "Projections") {
                analyticArray =  ["BranchName","OpenEnquiry","LineTotal"]
                 self.getTotalLeads()
            }
            else if (status == "Total Leads") {
                analyticArray =  ["BranchName","EnquiryNo","Status"]
                 self.getTotalLeads()
            }
            else if (status == "Source") {
                analyticArray =  ["BranchName","EnquirySource","SourceCount"]
                 self.getTotalLeads()
            }
            else {
           analyticArray = ["Emp ID","Name","Designation","Basic Salary"]
            self.getstaffList()
            }
        // Do any additional setup after loading the view.
    }
    func getstaffList() {
        var staffInfoDict: [String: Any] = [:]
        staffInfoDict["status"] = status
        staffInfoDict["branch"] = branchcode
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getStaffList(withDetails: staffInfoDict, serviceName: "StaffList") { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                    if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                        for staffDict in staffList!
                        {
                            let name =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Name.rawValue] as? String) as! String
                            let empID =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.EmpID.rawValue] as? String) as! String
                            let department =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Designation.rawValue] as? String) as! String
                            let basicSalary =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.BasicSalary.rawValue] as? NSNumber) as! String
                            let staffObj = staffListStruct(name: name, iD: empID, department: department, salary: basicSalary)
                            self.staffList.append(staffObj)
                        }
                    }
                    if self.staffList.count > 0 {
                        DispatchQueue.main.async {
                            self.analyticCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getApplicationList() {
        var staffInfoDict: [String: Any] = [:]
        staffInfoDict["status"] = status
        staffInfoDict["branch"] = branchcode
        staffInfoDict["fromdt"] = fromDate
        staffInfoDict["todt"] = toDate
        
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getApplicationList(withDetails: staffInfoDict) { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                    if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                        for staffDict in staffList!
                        {
                            let name =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Name.rawValue] as? String) as! String
                            let designation =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Designation.rawValue] as? String) as! String
                            let OverAllWorkExp =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.OverAllWorkExp.rawValue] as? String) as! String
                            let expectedSalary =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.ExpectedSalary.rawValue] as? NSNumber) as! String
                            let staffObj = staffListStruct(name: name, iD: OverAllWorkExp, department: designation, salary: expectedSalary)
                            self.staffList.append(staffObj)
                        }
                    }
                    if self.staffList.count > 0 {
                        DispatchQueue.main.async {
                            self.analyticCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getTotalLeads() {
        var totalLeadInfo: String = ""
        totalLeadInfo = "&branch=" + branchName + "&fromdate=" + fromDate + "&todate=" + toDate
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getLeadCountList(withDetails: totalLeadInfo) { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    let count = (status == "Leads Count") ? JSONKeys.TotalLeadCount.rawValue : (status == "Rejected Count") ? JSONKeys.TotalRejectedInquires.rawValue : (status == "Open Enquiry Count") ? JSONKeys.TotalOpenEnquiryCount.rawValue : (status == "Almost Confirmed Count") ? JSONKeys.TotalAlmostConfirmed.rawValue : (status == "Closed Enquiry Count") ? JSONKeys.TotalClosedEnquiry.rawValue : (status == "Followup Count") ? JSONKeys.FollowupCount.rawValue : (status == "Source Count") ? JSONKeys.SourceCount.rawValue : ""

                    
                    let Branch = (status == "Followup Count") ? JSONKeys.Branch.rawValue : (status == "Source Count") ? JSONKeys.Branch.rawValue : JSONKeys.BranchName.rawValue

                    let agent = (status == "Followup Count") ? JSONKeys.SalesAgent.rawValue : JSONKeys.AgentName.rawValue

                    
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                    if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                        
                        for staffDict in staffList!
                        {
                            let BranchName =  DashBoardViewController.nullToNil(value: staffDict[Branch] as? String) as! String
                            let AgentName =  DashBoardViewController.nullToNil(value: staffDict[agent] as? String) as! String
                            let TotalLeadCount =  DashBoardViewController.nullToNil(value: staffDict[count] as? NSNumber) as! String
                            let staffObj = staffListStruct(name: BranchName, iD: AgentName, department: TotalLeadCount, salary: TotalLeadCount)
                            self.staffList.append(staffObj)
                        }
                    }
                    if self.staffList.count > 0 {
                        DispatchQueue.main.async {
                            self.analyticCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class AnalyticInfoCollectionCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    var titleValue:String = ""
    var analyticArray:[String] = []

    @IBOutlet weak var analyticTableView: UITableView!
    override func layoutSubviews() {
        analyticTableView.layer.borderWidth = 1.0
        analyticTableView.layer.borderColor = UIColor.lightGray.cgColor
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleValue
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(13)
            textlabel.textAlignment = .center
            textlabel.numberOfLines = 2
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  analyticArray.count > 0 ? analyticArray.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticCellIdentifier", for: indexPath) as! AnalyticTableCellI
        cell.name.text = analyticArray[indexPath.row]
        return cell
    }
}

class AnalyticTableCellI: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var name: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension AnalyticDetailsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return analyticArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AnalyticInfoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalyticCollectionIdentifier", for: indexPath) as! AnalyticInfoCollectionCell
        let name = analyticArray[indexPath.row]
        var analyticArrayVal: [String] = []
        for vlue in staffList
        {
            if name == "Emp ID" || name == "OverAllWorkExp" || name == "AgentName"
            {
            analyticArrayVal.append(vlue.iD)
            } else if name == "Name" || name == "BranchName" {
                analyticArrayVal.append(vlue.name)
            }  else if name == "Designation" || name == "TotalLead Count"  || name == "TotalRejected Count" || name == "TotalOpenEnqiry Count" || name == "TotalAlmost Count" || name == "TotalClosed Count" || name == "TotalFollowup Count" || name == "TotalSource Count" {
                analyticArrayVal.append(vlue.department)
            }
            else if name == "Basic Salary" || name == "ExpectedSalary" {
                analyticArrayVal.append(vlue.salary)
            }
        }
        cell.titleValue = name
        cell.analyticArray = analyticArrayVal
        cell.analyticTableView?.reloadData()
        return cell
    }
}
extension AnalyticDetailsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count:CGFloat = CGFloat(analyticArray.count)
        let heightValue = (staffList.count * 44) + 25
        let numberOfItemsPerRow:CGFloat = count
        let spacingBetweenCells:CGFloat = 0
        let totalSpacing = (count * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
       if let collection = self.analyticCollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
        return CGSize(width: width, height: CGFloat(heightValue))
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
