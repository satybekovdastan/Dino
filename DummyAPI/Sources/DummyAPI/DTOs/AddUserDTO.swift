//
//  File.swift
//  
//
//  Created by Das
//

import Foundation

public struct AddUserDTO: Codable {
    public let firstName: String
    public let lastName: String
    public let username: String
    public let password: String
}
