//
//  WBInstoreNetworkManager.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 5/31/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation

struct WBInstoreNetworkManager {
    static var shared = WBInstoreNetworkManager()
    
    private let connectionHandler = WBInstoreConnectionHandlerFactory.getWBInstoreConnectionHandler(type: .live)
    
    private init() {
        //TO-DO
    }
    
    func presentLoadingScreen() {
        loadingViewManager.sharedInstance.showLoadingScreen()
    }
    
    func dismissLoadingScreen() {
        loadingViewManager.sharedInstance.hideLoadingScreen()
    }

    func getDepartmentList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getDepartmentList(withDetails: inDetails) { (result) in
            completionHandler(result)
        }
    }

    func getStaffCount(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getStaffCount(withDetails: inDetails) { (result) in
            completionHandler(result)
        }
    }

    func getBranchList(withDetails branchType: String, completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getBranchList(withDetails: branchType) { (result) in
            completionHandler(result)
        }
    }
    func getStaffList(withDetails inDetails: [String: Any],serviceName: String, completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getStaffList(withDetails: inDetails, serviceName: serviceName) { (result) in
                completionHandler(result)
            }
    }
    
    func getApplicationList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getApplicationList(withDetails: inDetails) { (result) in
            completionHandler(result)
        }
    }
    
    func getLeadCountList(withDetails inDetails: String, completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getLeadCountList(withDetails: inDetails) { (result) in
            completionHandler(result)
        }
    }
    func getLoginDetail(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        connectionHandler.getLoginDetail(withDetails: inDetails) { (result) in
            completionHandler(result)
    }
    }

}
