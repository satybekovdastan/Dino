//
//  ResponseBody.swift
//  Navi
//
//  Created by DAS on 7/11/21.
//  Copyright © 2021 Doit. All rights reserved.
//

import Foundation

struct ResponseBody: Decodable {
    var detail: String?
}

struct ResponseEmpty: Decodable { }
