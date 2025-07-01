//
//  ShortUser.swift
//  Navi
//
//  Created by Daniil Rassadin on 20/12/24.
//  Copyright © 2024 Reviro. All rights reserved.
//

import Foundation

struct ShortUser: Decodable {
    
    let id: Int
    let firstName: String?
    let lastName: String?
    let phone: String
    let showPhone: Bool
    let cardNumber: String?
    
}
