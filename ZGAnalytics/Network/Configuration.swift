//
//  Configuration.swift
//  Govberg
//
//  Created by Anthony Detamore on 12/28/15.
//  Copyright © 2015 ___GOVBERG___. All rights reserved.
//

import Foundation

// MARK: NETWORK ERROR
enum NoDataError: Error {
    case noData
    case notFound
    case serverError
}
enum ConnectionType: Int {
    case mock = 0
    case live = 1
}

extension NoDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            return "NO_DATA"
        case .notFound:
            return "NOT_FOUND"
        case .serverError:
            return "SERVER_500_ERROR"
        }
    }
}


enum RequestMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put    = "PUT"

}

enum JSONKeys: String {
    case Message
    case status
    case branchname
    case bid
    case Success
    case BPLName
    case BPLId
    case JobStatus
    case Cnt
    case Code
    case Name
    case EmpID
    case Designation
    case BasicSalary
    case OverAllWorkExp
    case ExpectedSalary
    case BranchName
    case AgentName
    case TotalLeadCount
    case TotalRejectedInquires
    case TotalOpenEnquiryCount
    case TotalAlmostConfirmed
    case TotalClosedEnquiry
    case FollowupCount
    case SalesAgent
    case SourceCount
    case Branch
    case Projections
    case LineTotal
    case SalesAmount
    case Amount
    case Data
    case branch
    case Branches
    case Access
    case Employee
    case EmpCode
    case Contact
    case mailid
    case profileurl

}

enum WBInstoreErrorCodes: Int {
    case parsingError = 100
    case invalidStore = 101
    case otherError = 102
}
