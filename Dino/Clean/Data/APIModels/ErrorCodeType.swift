//
//  ErrorCodeType.swift
//  Navi
//
//  Created by Daniil Rassadin on 14/2/25.
//  Copyright © 2025 Reviro. All rights reserved.
//

import Foundation

enum ErrorCodeType: String, Decodable {
    
    case createRideByVisaIsNotAllowed = "CreateRideByVisaIsNotAllowed"
    case riderInNewDevice
    case rideEstimationNotFound = "RideEstimationNotFound"
    case activeRidesNotFound = "ActiveRidesNotFound"
    case regionOutOfServiceDistanceError = "RegionOutOfServiceDistanceError"
    case rideNotFound = "RideNotFound"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = ErrorCodeType(rawValue: rawValue) ?? .unknown
    }

}
