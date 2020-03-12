//
//  AnalyticsViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 27/11/19.
//  Copyright © 2019 Bharathimohan. All rights reserved.
//

import UIKit


class AnalyticCell: UICollectionViewCell {
    @IBOutlet weak var analyticName: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var analyticImg: UIImageView!
}

var branchcode: String = "", branchName: String = "", subBranchCode: String = "", status: String = "", fromDate: String = "",toDate: String = "", SalesDict: [String: Any] = [:], loginDict: [String: Any] = [:]

class AnalyticsViewController: UIViewController {
    private let spacing:CGFloat = 15.0
    @IBOutlet weak var analyticCollection: UICollectionView!
    @IBOutlet weak var stratDate: UIButton!
    @IBOutlet weak var endCallender: UIButton!
    @IBOutlet weak var enddate: UIButton!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var enddateView: UIView!
    @IBOutlet weak var startCallender: UIButton!
    var selectedDate: String = ""
    var sapApplicationInfoArray = ["Leads Count", "Rejected Count", "Almost Confirmed Count", "Employee Tracker", "Closed Enquiry Count", "Followup Count", "Source Count", "Total Sales", "Projections", "Total Leads", "Rejected Enquiry", "Source"]
//    "Sales by Agent"
    struct analyticItem {
        var analyticName: String, analyticCount: String, detailsDict: [String: Any]
        init(analyticName: String, analyticCount: String,detailsDict: [String: Any]) {
            self.analyticName = analyticName
            self.analyticCount = analyticCount
            self.detailsDict = detailsDict
        }
    }
    var analyticList = [analyticItem]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    let dispatchQueue = DispatchQueue(label: "myQueue", qos: .background)
    let semaphore = DispatchSemaphore(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 18)!]

        let image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
        startCallender.setImage(image, for: .normal)
        startCallender.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        endCallender.setImage(image, for: .normal)
        endCallender.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)

        let currentDate = getcurrentDate()
        stratDate.setTitle(currentDate, for: .normal)
        enddate.setTitle(currentDate, for: .normal)
        fromDate = serverDate(selectedDate: Date())
        toDate = serverDate(selectedDate: Date())
        analyticCollection.delegate = self
        analyticCollection.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.analyticCollection?.collectionViewLayout = layout
        if subBranchCode == "9" {
            self.analyticList.removeAll()
        self.getServiceInfo()
        } else if subBranchCode == "Interview" {
            self.getstaffCount()
        }
        else {
            self.getstaffCount()
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func startDateAction(_ sender: UIButton) {
        selectedDate = "startDate"
        self.dataAction()
    }
    
    @IBAction func enddateAction(_ sender: Any) {
        selectedDate = "endDate"
        self.dataAction()
    }
    
    func dataAction() {
        removeView()
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(datePicker)
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackOpaque
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }

    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }

    func serverDate(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: selectedDate)
        return currentDate
    }
    
    func displayDate(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let currentDate = formatter.string(from: selectedDate)
        return currentDate
    }

    func getcurrentDate() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }


    @objc func cancelDatePicker(){
        removeView()
        self.view.endEditing(true)
     }
    
    func removeView() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func onDoneButtonClick() {
        let dateValue = displayDate(selectedDate: datePicker.date)
        let serverDateValue = serverDate(selectedDate: datePicker.date)
        if selectedDate == "startDate" {
        stratDate.setTitle(dateValue, for: .normal)
            fromDate = serverDateValue
        } else if selectedDate == "endDate"{
            enddate.setTitle(dateValue, for: .normal)
            toDate = serverDateValue
        }
        self.view.endEditing(true)
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        if subBranchCode == "9" {
        self.analyticList.removeAll()
        self.getServiceInfo()
        } else {
            self.getstaffCount()
        }
    }
    
    func getServiceInfo() {
        dispatchQueue.async {
            var locationCount: Int = 0
            for value in self.sapApplicationInfoArray {
                    var totalLeadInfo: String = ""
                    totalLeadInfo = "&branch=" + branchName + "&fromdate=" + fromDate + "&todate=" + toDate
                    status = value
                DispatchQueue.main.async {
                    loadingViewManager.sharedInstance.showLoadingScreen()
                }
                    WBInstoreNetworkManager.shared.getLeadCountList(withDetails: totalLeadInfo) { (staffInfoList) in
                        DispatchQueue.main.async {
                        loadingViewManager.sharedInstance.hideLoadingScreen()
                        }
                        self.semaphore.signal()
                        if staffInfoList.count > 0 {
                            if staffInfoList.keys.contains("Success") {
                                let statusVal = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                                    if statusVal == "true" {
                                        let count = (value == "Leads Count") ? JSONKeys.TotalLeadCount.rawValue : (value == "Rejected Count") ? JSONKeys.TotalRejectedInquires.rawValue : (value == "Employee Tracker") ? JSONKeys.TotalOpenEnquiryCount.rawValue : (value == "Almost Confirmed Count") ? JSONKeys.TotalAlmostConfirmed.rawValue : (value == "Closed Enquiry Count") ? JSONKeys.TotalClosedEnquiry.rawValue : (value == "Followup Count") ? JSONKeys.FollowupCount.rawValue : (value == "Source Count") ? JSONKeys.SourceCount.rawValue : (value == "Source") ? JSONKeys.SourceCount.rawValue: (value == "Projections") ? JSONKeys.LineTotal.rawValue: (value == "Total Sales") ? JSONKeys.Amount.rawValue : (value == "Sales by Agent") ? JSONKeys.Amount.rawValue : ""
                                        
                                    let staffList = staffInfoList["Data"] as? [[String: Any]]
                                    if staffList!.count > 0 {
                                        var totalCount: Int = 0
                                        for staffDict in staffList!
                                        {
                                            if value == "Projections"{
                                              let branch = DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Branch.rawValue] as? String) as! String
                                                if branch == branchName {
                                                    let countVal =  staffDict[count] as? NSNumber
                                                    if countVal != nil {
                                                        totalCount += Int(truncating: countVal!)
                                
                                                    }
                                                }
                                            } else {
                                                if (value == "Total Sales") {
                                                    var countVal =  staffDict[count] as! String
                                                    if let dotRange = countVal.range(of: ".") {
                                        countVal.removeSubrange(dotRange.lowerBound..<countVal.endIndex)
                                                    }
                                                if countVal.isEmpty != true {
                                                    let totalSales:Int = Int(countVal)!
                                                    totalCount += totalSales
                                                }
                                                } else {
                                                let countVal =  staffDict[count] as? NSNumber
                                                if countVal != nil {
                                                    totalCount += Int(truncating: countVal!)}
                                                }
                                            }
                                        }
                                        let total = (value == "Total Leads" || value == "Rejected Enquiry" || value == "Sales by Agent") ? String(staffList!.count.withCommas()) : String(totalCount.withCommas())
                                        
                                        let staffObj = analyticItem(analyticName: value, analyticCount: total, detailsDict: staffInfoList)
                                        self.analyticList.append(staffObj)
                                }
                            }
                                locationCount += 1
                                if locationCount == self.sapApplicationInfoArray.count {
                                    DispatchQueue.main.async {
                                    self.analyticCollection.reloadData()
                                    }
                                }
                        }
                        }
                        else {
                            
                        self.semaphore.signal()
                            DispatchQueue.main.async {
                            loadingViewManager.sharedInstance.hideLoadingScreen()
                            }

                        locationCount += 1
                        return
                        }
            }
                self.semaphore.wait()
        }
        }
    }
    
//    func getServiceInfo() {
//        self.analyticList.removeAll()
//        for name in sapApplicationInfoArray {
//            let staffObj = analyticItem(analyticName: name, analyticCount: "", detailsDict: [:])
//        self.analyticList.append(staffObj)
//        DispatchQueue.main.async {
//        self.analyticCollection.reloadData()
//        }
//    }
//    }
    
    func getstaffCount() {
        var branchInfoDict: [String: Any] = [:]
        if subBranchCode == "StaffCount" {
            branchInfoDict["branch"] = branchcode
            startDateView.isHidden = true
            enddateView.isHidden = true
        } else if subBranchCode == "ApplicationCount" {
            branchInfoDict["branch"] = branchcode
            branchInfoDict["fromdt"] = fromDate
            branchInfoDict["todt"] = toDate
            startDateView.isHidden = false
            enddateView.isHidden = false
        } else {
            branchInfoDict["branch"] = branchName
            startDateView.isHidden = false
            enddateView.isHidden = true
        }
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getStaffCount(withDetails: branchInfoDict) { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    self.analyticList.removeAll()
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                    if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                        if subBranchCode == "Interview" {
                            for staffDict in (staffList?.first)! {
                                if staffDict.key != "branch" {
                                let name =  staffDict.key
                                let count =  staffDict.value
                                    let staffObj = analyticItem(analyticName: name, analyticCount: count as! String, detailsDict: [:])
                                self.analyticList.append(staffObj)
                                }
                            }

                        } else {
                        for staffDict in staffList!
                        {
                            let name =  DashBoardViewController.nullToNil(value: staffDict[subBranchCode == "StaffCount" ? JSONKeys.JobStatus.rawValue : subBranchCode == "AttendanceCount" ?  "Type" : "ApplicationStatus"] as? String) as! String
                            let count =  DashBoardViewController.nullToNil(value: staffDict[JSONKeys.Cnt.rawValue] as? NSNumber) as! String
                            let staffObj = analyticItem(analyticName: name, analyticCount: count, detailsDict: [:])
                            self.analyticList.append(staffObj)
                        }
                        }
                    }
                    if self.analyticList.count > 0 {
                        DispatchQueue.main.async {
                            self.analyticCollection.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AnalyticsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.analyticList.count > 0 ? self.analyticList.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalyticsIdentifier", for: indexPath as IndexPath) as! AnalyticCell
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
        cell.analyticName.text = self.analyticList[indexPath.row].analyticName
        cell.count.text = self.analyticList[indexPath.row].analyticCount
        if let templateImage = UIImage(named: "timeLine")?.withRenderingMode(.alwaysTemplate) {            let imageView = UIImageView(image: templateImage)
            cell.analyticImg.image = imageView.image
            cell.analyticImg.tintColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        status =  self.analyticList[indexPath.row].analyticName
        SalesDict = self.analyticList[indexPath.row].detailsDict
    }

}

extension AnalyticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 15
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
       if let collection = self.analyticCollection{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }

}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
