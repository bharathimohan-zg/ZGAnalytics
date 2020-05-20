//
//  WBInstoreLIVEConnectionHandler.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 5/31/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator

struct WBInstoreLIVEConnectionHandler {
    // MARK: - Properties
    let hrmBaseApi = "http://106.51.97.43:8051/api/HRM/"
    let sapBaseApi = "http://crm.zerogravity.photography:8092/api/ZGP/"

    private static var sharedLIVEConnectionHandler: WBInstoreLIVEConnectionHandler = {
        let connectionHandler = WBInstoreLIVEConnectionHandler()
        
        // Configuration
        // ...
        
        return connectionHandler
    }()
    
    
    // MARK: -
    
    private let networkRequest: RealNetworkRequest
    
    // Initialization
    
    private init() {
        networkRequest = RealNetworkRequest.shared
    }
    
    // MARK: - Accessors
    
    static var shared: WBInstoreLIVEConnectionHandler {
        return sharedLIVEConnectionHandler
    }
}

extension WBInstoreLIVEConnectionHandler: WBInstoreEndPoints {
    
    func getStaffList(withDetails inDetails: [String: Any],serviceName: String, completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        networkRequest.request(URL(string: hrmBaseApi + serviceName )!, method: RequestMethod.post, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    
    func getApplicationList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        var branchInfo: String = ""
        if subBranchCode == "Interview" {
            if status == "late" {
                branchInfo = "getlate"
            } else if status == "present" {
                branchInfo = "getpresent"
            } else if status == "leave" {
                branchInfo = "getleave"
            } else if status == "permission" {
                branchInfo = "getpermission"
            } else if status == "delegation" {
                branchInfo = "getdelegetion"
            }else if status == "absent" {
                branchInfo = "getabsent"
            }
        } else {
            branchInfo = "ApplicationList"
        }

        networkRequest.request(URL(string: hrmBaseApi + branchInfo)!, method: RequestMethod.post, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    
    func getLeadCountList(withDetails inDetails: String, completionHandler:@escaping ([String: Any]) -> Void) {
        let baseName = (status == "Leads Count") ? "GetTotalLeadsCount?" : (status == "Rejected Count") ? "GetRejectedEnquiresCount?" : (status == "Almost Confirmed Count") ? "GetAlmostConfirmedEnquiresCount?" : (status == "Employee Tracker") ? "GetOpenEnquiryCount?" : (status == "Closed Enquiry Count") ? "GetClosedEnquiryCount?" : (status == "Followup Count") ? "GetDailyFollowupEnquiryCount?" : (status == "Source Count") ? "GetEnquirySourceCount?" : (status == "Total Sales") ? "GetSalesDetails?" : (status == "Total Leads") ? "GetTotalLeads?": (status == "Rejected Enquiry") ? "GetRejectedEnquires?" : (status == "Source") ? "GetEnquirySource?": (status == "Projections") ? "GetProjections?" : (status == "Sales by Agent") ? "GetSumofSalesAmount?" : ""
        let urlName = (status == "Projections") ? "" : inDetails
        NetworkActivityIndicatorManager.shared.isEnabled = true
        networkRequest.request(URL(string: sapBaseApi + baseName + urlName)!, method: RequestMethod.get, parameters: [:], headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }

    func getLoginDetail(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        networkRequest.request(URL(string: hrmBaseApi + "checklogin")!, method: RequestMethod.post, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    func getDepartmentList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        networkRequest.request(URL(string: sapBaseApi + "GetDepartmentList")!, method: RequestMethod.get, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    
    func getStaffCount(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let branchInfo = (subBranchCode == "Interview") ? "getempcount" : subBranchCode
        networkRequest.request(URL(string: hrmBaseApi + branchInfo)!, method: RequestMethod.post, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    
    func getBranchList(withDetails branchType: String, completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        let baseUrl = (branchType == "HRM") ? hrmBaseApi : sapBaseApi
        let branchValue = (branchType == "HRM") ? "GetBranches" : "GetBranchList"
        networkRequest.request(URL(string: baseUrl + branchValue)!, method: RequestMethod.get, parameters: [:], headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
    
    func getProfileInfo(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        networkRequest.request(URL(string: hrmBaseApi + "getprofile")!, method: RequestMethod.post, parameters: inDetails, headers: nil) { (response) in
            switch response {
            case .success(let data):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments)
                    guard let responseJSON = jsonResponse as? [String: Any]
                        else {
                            completionHandler([:])
                            return
                    }
                    completionHandler(responseJSON)
                } catch _ {
                    completionHandler([:])
                }
            case .failure( _):
                NetworkActivityIndicatorManager.shared.isEnabled = false
                completionHandler([:])
            }
        }
    }
}
