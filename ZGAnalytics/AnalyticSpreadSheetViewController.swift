//
//  AnalyticSpreadSheetViewController.swift
//  ZGAnalytics
//
//  Created by Bharathimohan on 27/01/20.
//  Copyright © 2020 Bharathimohan. All rights reserved.
//

import UIKit
import SpreadsheetView
class MyTapGesture: UITapGestureRecognizer {
    var indexPath = IndexPath(item: 0, section: 0)
}

struct ExampleModel {
    var direction = Direction.north
}

enum Direction : String {
    
    case north, east, south, west
    
    static var allValues = [Direction.north, .east, .south, .west]
    
}

class AnalyticSpreadSheetViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate, UISearchBarDelegate {
    var model = ExampleModel() {
        didSet {
            self.view.setNeedsLayout()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    var header = [String]()
    var data = [[String]]()

    enum Sorting {
        case ascending
        case descending

        var symbol: String {
            switch self {
            case .ascending:
                return "\u{25B2}"
            case .descending:
                return "\u{25BC}"
            }
        }
    }
    var sortedColumn = (column: 0, sorting: Sorting.ascending)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = status
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Ubuntu-Light", size: 16)

        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Ubuntu-Bold", size: 18)!]
        self.spreadsheetView.dataSource = self
        self.spreadsheetView.delegate = self
        self.spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        self.spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        if subBranchCode == "ApplicationCount" {
            self.getApplicationList()
        } else if subBranchCode == "StaffCount"{
            self.getstaffList()
        } else if subBranchCode == "Interview" {
            self.getAttendanceReport()
        }
        else {
            self.getTotalLeads()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
                            if staffList!.count > 0 {
                            let value = staffList?.first as NSDictionary?
                            let data = value?.allKeys
                            self.header = data as! [String]
                            var stob: [[String]] = []
                            for  staff in staffList! {
                                var stob1: [String] = []
                                for valu in  self.header {
                                    let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                    stob1.append(valueobj )
                                }
                                stob.append(stob1)
                            }
                            self.data = stob
                            if self.data.count > 0 {
                                DispatchQueue.main.async {
                            self.spreadsheetView.reloadData()
                            }
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func getAttendanceReport() {
        var staffInfoDict: [String: Any] = [:]
        staffInfoDict["branch"] = branchName
        staffInfoDict["searchdate"] = fromDate
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getApplicationList(withDetails: staffInfoDict) { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                        if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                            if staffList!.count > 0 {
                            let value = staffList?.first as NSDictionary?
                            let data = value?.allKeys
                            self.header = data as! [String]
                            var stob: [[String]] = []
                            for  staff in staffList! {
                                var stob1: [String] = []
                                for valu in  self.header {
                                    let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                    stob1.append(valueobj )
                                }
                                stob.append(stob1)
                            }
                            self.data = stob
                            if self.data.count > 0 {
                                DispatchQueue.main.async {
                            self.spreadsheetView.reloadData()
                            }
                            }
                        }
                    }
                    
                }
            }
        }
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
                            if staffList!.count > 0 {
                            let value = staffList?.first as NSDictionary?
                            let data = value?.allKeys
                            self.header = data as! [String]
                            var stob: [[String]] = []
                            for  staff in staffList! {
                                var stob1: [String] = []
                                for valu in  self.header {
                                    let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                    stob1.append(valueobj )
                                }
                                stob.append(stob1)
                            }
                            self.data = stob
                            if self.data.count > 0 {
                                DispatchQueue.main.async {
                            self.spreadsheetView.reloadData()
                            }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getTotalLeads() {
//        var totalLeadInfo: String = ""
//        totalLeadInfo = "&branch=" + branchName + "&fromdate=" + fromDate + "&todate=" + toDate
//        loadingViewManager.sharedInstance.showLoadingScreen()
//        WBInstoreNetworkManager.shared.getLeadCountList(withDetails: totalLeadInfo) { (staffInfoList) in
//            loadingViewManager.sharedInstance.hideLoadingScreen()
            if SalesDict.count > 0 {
                if SalesDict.keys.contains("Success") {
                    let statusVal = DashBoardViewController.nullToBool(value: SalesDict[JSONKeys.Success.rawValue] as? Bool) as! String
                        if statusVal == "true" {
                        let staffList = SalesDict["Data"] as? [[String: Any]]
                            if staffList!.count > 0 {
                            let value = staffList?.first as NSDictionary?
                            let data = value?.allKeys as! [String]
                                if status == "Projections" || status == "Followup Count" || status == "Source Count" || status == "Source" {
                                    self.header = data.filter {$0 != "Branch"
                                    }
                                } else {
                                    self.header = data.filter {$0 != "BranchName"}
                                }
                            var stob: [[String]] = []
                            for  staff in staffList! {
                                var stob1: [String] = []
                                if status == "Projections" {
                                    let Branch = AnalyticSpreadSheetViewController.nullToNil(value: staff[JSONKeys.Branch.rawValue]) as! String
                                    if Branch == branchName {
                                        for valu in  self.header {
                                            let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                            if valueobj != branchName {
                                            stob1.append(valueobj)
                                            }
                                        }
                                    }
                                } else {
                                    for valu in  self.header {
                                        let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                        if valueobj != branchName {
                                        stob1.append(valueobj)
                                        }
                                    }
                                }
                                if stob1.count > 0 {
                                stob.append(stob1)
                                }
                            }
                            self.data = stob
                            if self.data.count > 0 {
                                DispatchQueue.main.async {
                            self.spreadsheetView.reloadData()
                            }
                            }
                    }
                    }
                }
        }
//        }
}

    private func getSearchResult(searchText: String) {
        var staffInfoDict: [String: Any] = [:]
        staffInfoDict["staffname"] = searchText
        staffInfoDict["branch"] = branchcode
        loadingViewManager.sharedInstance.showLoadingScreen()
        WBInstoreNetworkManager.shared.getStaffList(withDetails: staffInfoDict, serviceName: "StaffSearch") { (staffInfoList) in
            loadingViewManager.sharedInstance.hideLoadingScreen()
            if staffInfoList.count > 0 {
                if staffInfoList.keys.contains("Success") {
                    let status = DashBoardViewController.nullToBool(value: staffInfoList[JSONKeys.Success.rawValue] as? Bool) as! String
                        if status == "true" {
                        let staffList = staffInfoList["Data"] as? [[String: Any]]
                            if staffList!.count > 0 {
                            let value = staffList?.first as NSDictionary?
                            let data = value?.allKeys
                            self.header = data as! [String]
                            var stob: [[String]] = []
                            for  staff in staffList! {
                                var stob1: [String] = []
                                for valu in  self.header {
                                    let valueobj = AnalyticSpreadSheetViewController.nullToNil(value: staff[valu]) as! String
                                    stob1.append(valueobj )
                                }
                                stob.append(stob1)
                            }
                            self.data = stob
                            if self.data.count > 0 {
                                DispatchQueue.main.async {
                            self.spreadsheetView.reloadData()
                            }
                            }
                    }
                    }
                }
        }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spreadsheetView.flashScrollIndicators()
    }

    // MARK: DataSource

    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return header.count
    }

    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return data.count > 0 ? 1 + data.count : 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 140
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 60
        } else {
            return 44
        }
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case 0 = indexPath.row {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = header[indexPath.column]
            cell.label.textColor = UIColor(red: 241/255.0, green: 107/255.0, blue: 182/255.0, alpha: 1)
            if case indexPath.column = sortedColumn.column {
                cell.sortArrow.text = sortedColumn.sorting.symbol
            } else {
                cell.sortArrow.text = ""
            }
            cell.setNeedsLayout()
            return cell
        } else {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.textColor = .black
            cell.label.text = data[indexPath.row - 1][indexPath.column]
            
            if header[indexPath.section] == "ContactNo" || header[indexPath.section] == "WhatsappNo"{
                let tapAction = MyTapGesture.init(target: self, action: #selector(actionTapped(recognizer:)))
                tapAction.indexPath = indexPath
                cell.label.isUserInteractionEnabled = true
                cell.label.addGestureRecognizer(tapAction)
            } else {
                cell.label.isUserInteractionEnabled = false
            }
            return cell
        }
    }
    
    @objc func actionTapped(recognizer: MyTapGesture) {
        DispatchQueue.main.async {
            self.dialNumber(number: self.data[recognizer.indexPath.row - 1][recognizer.indexPath.column])
        }
    }
    
    func dialNumber(number : String) {
        let phoneNumber = number.trimmingCharacters(in: .whitespaces)
        if let url = URL(string: "tel://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            
        }
    }

    /// Delegate

    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if case 0 = indexPath.row {
            if sortedColumn.column == indexPath.column {
                sortedColumn.sorting = sortedColumn.sorting == .ascending ? .descending : .ascending
            } else {
                sortedColumn = (indexPath.column, .ascending)
            }
            data.sort {
                let ascending = $0[sortedColumn.column] < $1[sortedColumn.column]
                return sortedColumn.sorting == .ascending ? ascending : !ascending
            }
            spreadsheetView.reloadData()
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popupViewController") as! popupViewController
            self.addChild(vc)
            popupTextInfo = data[indexPath.row - 1][indexPath.section]
            vc.view.frame = self.view.frame
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "popupViewController") as! popupViewController
//            vc.preferredContentSize = CGSize(width: 300, height: 200)
//            let navController = UINavigationController(rootViewController: vc)
////            vc.modalPresentationStyle = .formSheet
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.modalTransitionStyle = .crossDissolve
//            popupTextInfo = data[indexPath.row - 1][indexPath.section]
//            self.present(navController, animated:true, completion: nil)
        }
    }
    private func showPopup(_ controller: UIViewController, sourceView: TextCell) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.getSearchResult(searchText: searchText)
}
}
extension AnalyticSpreadSheetViewController {
    
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
