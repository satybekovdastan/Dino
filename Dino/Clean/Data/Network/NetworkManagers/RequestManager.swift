//
//  RequestManager.swift
//  Jorgo
//
//  Created by DAS on 2/6/21.
//  Copyright © 2021 Doit. All rights reserved.
//

import Foundation

final class RequestManager {
    
    static let shared = RequestManager()
    
    typealias Completion<T: Decodable> = (_ object: T?, _ error: ErrorModel?, _ isSuccess: Bool) -> ()
    
    func decode<M: Decodable>(jsonData: Data, using modelType: M.Type) -> M? {
        do {
            //here dataResponse received from a network request
            return try decoder.decode(modelType, from: jsonData) //Decode JSON Response Data
        } catch let parsingError {
            print("Error", parsingError)
        }
        return nil
    }
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
}



