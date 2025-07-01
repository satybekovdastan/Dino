//
//  File.swift
//  
//
//  Created by Das
//

import Foundation

public struct LoginRequestDTO: Codable {
    public let username: String
    public let password: String
    public let expiresInMins: Int
}
