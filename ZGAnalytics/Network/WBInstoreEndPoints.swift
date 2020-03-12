//
//  WBInstoreEndPoints.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 5/30/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation

protocol WBInstoreEndPoints {

    func getStaffCount(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void)

    func getBranchList(withDetails branchType: String, completionHandler:@escaping ([String: Any]) -> Void)
    func getDepartmentList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void)
    func getStaffList(withDetails inDetails: [String: Any],serviceName: String, completionHandler:@escaping ([String: Any]) -> Void) 
    func getApplicationList(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void)
    func getLeadCountList(withDetails inDetails: String, completionHandler:@escaping ([String: Any]) -> Void) 
    func getLoginDetail(withDetails inDetails: [String: Any], completionHandler:@escaping ([String: Any]) -> Void)


}
