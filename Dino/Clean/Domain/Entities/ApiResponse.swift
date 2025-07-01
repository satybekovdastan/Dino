//
//  ApiResponse.swift
//  Jorgo
//
//  Created by DAS on 2/6/21.
//  Copyright © 2021 Doit. All rights reserved.
//

struct ApiResponse<T: Decodable>: Decodable {
    var result : T?
    var meta : T?
}
