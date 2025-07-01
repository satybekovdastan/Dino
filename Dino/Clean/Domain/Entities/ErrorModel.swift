//
//  ErrorModel.swift
//  Jorgo
//
//  Created by DAS on 10/6/21.
//  Copyright © 2021 Doit. All rights reserved.
//


struct ErrorModel: Decodable {
    
    let code: Int?
    let message: String?
    let errorCode: ErrorCodeType?

    let detail: [ErrorDetailModel]?
}


struct ErrorDetailModel: Decodable {
    
    let loc: [String]?
    let msg: String?
    let type: String?
    let errorCode: ErrorCodeType?

}


struct ErrorDetailStringModel: Decodable {
    
    let code: Int?
    let message: String?
    let detail: String?
    let errorCode: ErrorCodeType?

}
