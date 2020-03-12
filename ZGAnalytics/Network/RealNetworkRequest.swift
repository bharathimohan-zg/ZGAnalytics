//
//  RealNetworkRequest.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 7/5/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation
import Alamofire

class RealNetworkRequest: NetworkRequest {
    // MARK: - Properties    
    private static var sharedNetworkRequest: RealNetworkRequest = {
        let networkRequest = RealNetworkRequest()
        
        // Configuration
        // ...
        
        return networkRequest
    }()
    
    // MARK: -
    
    private let session: SessionManager
    
    // Initialization

    private init() {
        let defaultHeaders = SessionManager.defaultHTTPHeaders
        //Add additional headers if required like below
        //defaultHeaders["DNT"] = "1 (Do Not Track Enabled)"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        self.session = SessionManager(configuration: configuration)
    }
    
    // MARK: - Accessors
    
    static var shared: RealNetworkRequest {
        return sharedNetworkRequest
    }
    
    func request(_ url: URL, method: RequestMethod, parameters: [String: Any]?, headers: [String: String]?, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        let requestMethod = httpMethod(fromString: method.rawValue)
        session.request(url, method: requestMethod, parameters: parameters, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                guard let responseData = response.data
                    else {
                        completion(.failure(NoDataError.noData))
                        return
                }
                completion(.success(responseData))
            case .failure(let error):
                if let responseData = response.data, responseData.count > 0 {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                        if let responseJSON = jsonResponse as? [String: Any], let message = responseJSON[JSONKeys.Message.rawValue] as? String {
                            let errorDictionary = [NSLocalizedDescriptionKey: message]
                            let errorObj = NSError(domain: "ZZAnalytics.Server", code: WBInstoreErrorCodes.otherError.rawValue, userInfo: errorDictionary)
                            completion(.failure(errorObj))
                            return
                        }
                    } catch let parsingError {
                        completion(.failure(parsingError))
                        return
                    }
                }
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failure(error))
                    return
                }
                
                completion(.failure(self.getError(forStatusCode: statusCode) ?? error))
            }
        }
    }
}

private extension RealNetworkRequest {
    func httpMethod(fromString method: String) -> HTTPMethod {
        return HTTPMethod(rawValue: method) ?? .get
    }
    
    func parameterEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
        var parameterEncoding: ParameterEncoding = URLEncoding.default
        if method == .post || method == .put {
            parameterEncoding = JSONEncoding.default
        }
        return parameterEncoding
    }
    
    private func getError(forStatusCode statusCode: Int) -> Error? {
        var errorObj: Error?
        switch statusCode {
        case 500:
            errorObj = NoDataError.serverError
        case 404:
            errorObj = NoDataError.notFound
        default:
            errorObj = nil
        }
        return errorObj
    }
}
