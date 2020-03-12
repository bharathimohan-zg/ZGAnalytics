//
//  NetworkRequest.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 7/5/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation

protocol NetworkRequest {
    func request(
        _ url: URL,
        method: RequestMethod,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completion: @escaping (Swift.Result<Data, Error>) -> Void)
}
