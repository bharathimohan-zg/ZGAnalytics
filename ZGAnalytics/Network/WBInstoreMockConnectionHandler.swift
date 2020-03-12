//
//  WBInstoreMockConnectionHandler.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 5/31/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation
import Alamofire

struct WBInstoreMockConnectionHandler {
    // MARK: - Properties
    
    private static var sharedMockConnectionHandler: WBInstoreMockConnectionHandler = {
        let connectionHandler = WBInstoreMockConnectionHandler()
        
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
    
    static var shared: WBInstoreMockConnectionHandler {
        return sharedMockConnectionHandler
    }
}

extension WBInstoreMockConnectionHandler: WBInstoreEndPoints {
    func getDepartmentList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
    }

    func getStaffCount(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
        
    }

    func getBranchList(withDetails branchType: String, completionHandler:@escaping ([String: Any]) -> Void) {
    }
 
    func getStaffList(withDetails inDetails: [String: Any],serviceName: String, completionHandler:@escaping ([String: Any]) -> Void) {
    }
    func getApplicationList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
    }
    func getLeadCountList(withDetails inDetails: String, completionHandler:@escaping ([String: Any]) -> Void) {
    }
    func getLoginDetail(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void) {
    }
}
