//
//  WBInstoreConnectionHandlerFactory.swift
//  WatchBoxInStore
//
//  Created by Basavaraj km on 5/31/19.
//  Copyright © 2019 Govberg Jewelers. All rights reserved.
//

import Foundation

struct WBInstoreConnectionHandlerFactory {
    static func getWBInstoreConnectionHandler(type: ConnectionType) -> WBInstoreEndPoints {
        switch type {
        case .mock:
            return WBInstoreMockConnectionHandler.shared
        case .live:
            return WBInstoreLIVEConnectionHandler.shared
        }
    }
}
