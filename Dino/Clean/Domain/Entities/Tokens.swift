//
//  Tokens.swift
//  Navi
//
//  Created by Daniil Rassadin on 19/12/24.
//  Copyright © 2024 Reviro. All rights reserved.
//

import Foundation

struct Tokens: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let isNew: Bool
    
}
