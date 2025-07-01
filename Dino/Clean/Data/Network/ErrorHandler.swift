//
//  ErrorHandler.swift
//  Shopping
//
//  Created by DAS  on 26/5/25.
//


import Foundation

struct ErrorHandler {
    
    func errorMessage(data: Data?) -> ErrorModel? {
        guard let data else { return nil }
        
        if let result = RequestManager.shared.decode(jsonData: data, using: ErrorModel.self) {
            if let message = result.message {
                return ErrorModel(code: nil, message: message, errorCode: result.errorCode, detail: nil)
            } else if let detail = result.detail, let message = detail.first?.msg {
                return ErrorModel(code: nil, message: message, errorCode: detail.first?.errorCode, detail: nil)
            } else if let result = RequestManager.shared.decode(jsonData: data, using: ErrorDetailStringModel.self),
                      let detail = result.detail {
                return ErrorModel(code: nil, message: detail, errorCode: result.errorCode, detail: nil)
            }
        } else if let result = RequestManager.shared.decode(jsonData: data, using: ErrorDetailStringModel.self),
                  let detail = result.detail  {
            return ErrorModel(code: nil, message: detail, errorCode: result.errorCode, detail: nil)
        }
        
        return nil
    }
    
   
}
