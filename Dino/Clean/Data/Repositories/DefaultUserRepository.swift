//
//  DefaultUserRepository.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//


import Foundation
import Alamofire

final class DefaultUserRepository: BaseRepository, UserRepository {
    
    // MARK: Properties

    private let api: UserNetworkProtocolRequest
    
    // MARK: Initialization

    init(api: UserNetworkProtocolRequest) {
        self.api = api
    }
    
    let error = NSError(
        domain: "com.yourapp.network", // или любое имя
        code: -1, // твой код ошибки
        userInfo: [NSLocalizedDescriptionKey: Constants.unknownError]
    )

    // MARK: Authentication
    
    func getProfile(completion: @escaping (Result<User, NSError>) -> Void) {
        
    }

    func loginSendCode(
        phone: String,
        completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void
    ) {
        api.loginSendCode(phone: phone) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func verifyCode(
        phone: String,
        code: String,
        uiDevice: String,
        deviceModel: String,
        deviceVersion: String,
        language: String,
        completion: @escaping (Result<Tokens, NSError>) -> Void
    ) {
        api.verifyCode(
            phone: phone,
            code: code,
            uiDevice: uiDevice,
            device_model: deviceModel,
            device_version: deviceVersion,
            language: language
        ) { result in
            switch result {
            case .success(let tokens):
                completion(.success(tokens))
            case .failure(let failure):
                switch failure {
                case .errorData(let data):
                    completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
//                    completion(.failure(NSError(message: data?.message ?? Constants.unknownError)))
                default:
                                completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
                }
            }
        }
    }
    
    func refreshTokenWithCompletion(completion: @escaping (Result<Tokens, Error>) -> Void) {
        api.refreshTokenWithCompletion { result in
            switch result {
            case .success(let tokens):
                completion(.success(tokens))
            case .failure(let failure):
                switch failure {
                case .errorData(let data):
                    completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
//                    completion(.failure(NSError(message: data?.message ?? Constants.unknownError)))
                default:
                                completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
                }
            }
            
        }
    }
    
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, NSError>) -> Void
    ) {
        api.signUp(firstName: firstName, lastName: lastName) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let failure):
                switch failure {
                case .errorData(let data):
                    completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
//                    completion(.failure(NSError(message: data?.message ?? Constants.unknownError)))
                default:
                                completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
                }
            }
        }
    }
    
    // MARK: Notifications and Updates
    
    func updateFCM(completion: @escaping (Result<ResponseBody?, Error>) -> Void) {
        api.updateFCM() { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    // MARK: Profile Management
    
    func deleteProfile(completion: @escaping (Result<ResponseBody?, NSError>) -> Void) {
        api.deleteProfile() { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let failure):
                switch failure {
                case .errorData(let data):
                    completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
//                    completion(.failure(NSError(message: data?.message ?? Constants.unknownError)))
                case .empty_data:
                    completion(.success(ResponseBody()))
                default:
                                completion(.failure(self.error))
//                    completion(.failure(NSError(message: Constants.unknownError)))
                }
            }
        }
    }

    // MARK: Private Methods
    
    private func getLastCall() -> Int {
        let key = LastCallKey.lastCallUsers
        return self.getLasCall(key: key)
    }
    
    private func saveLastCall() {
        let key = LastCallKey.lastCallUsers
        self.saveLasCall(key: key)
    }
    
}
