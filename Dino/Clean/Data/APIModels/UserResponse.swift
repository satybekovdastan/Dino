//
//  UserResponse.swift
//  Navi
//
//  Created by Daniil Rassadin on 19/12/24.
//  Copyright © 2024 Reviro. All rights reserved.
//

import Foundation

struct UserResponse: Decodable {
    
    let id: Int
    let firstName: String?
    let lastName: String?
    let phone: String
    let showPhone: Bool
    let language: String?
    let cardNumber: String?
    let unreadNewsCount: Int
    let hasUnreadMessage: Bool
    let bonus: Int
    let useBonuses: Bool
    let isFamilyOwner: Bool
    
  
}
