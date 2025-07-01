//
//  UserNewsCase.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//


import Foundation

// MARK: - UserUseCase protocol

protocol UserUseCase {
    
    // MARK: Authentication
    
    func loginSendCode(
        phone: String,
        completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void
    )
    func verifyCode(
        phone: String,
        code: String,
        uiDevice: String,
        device_model: String,
        device_version: String,
        language: String,
        completion: @escaping (Result<Tokens, NSError>) -> Void
    )
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, NSError>) -> Void
    )
    func refreshTokenWithCompletion(completion: @escaping (Result<Tokens, Error>) -> Void)
    
    // MARK: Profile
    
    func getProfile(completion: @escaping (Result<User, NSError>) -> Void)
    func deleteProfile(completion: @escaping (Result<ResponseBody?, NSError>) -> Void)
    
    // MARK: Settings
        
    func updateFCM(completion: @escaping (Result<ResponseBody?, Error>) -> Void)
    
    // MARK: History
    
}

// MARK: - DefaultUserUseCase

final class DefaultUserUseCase: UserUseCase {
    
    // MARK: Properties
    
    private let userRepository: UserRepository
    
    // MARK: Initialization

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    // MARK: Authentication
    
    func loginSendCode(
        phone: String,
        completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void
    ) {
        userRepository.loginSendCode(phone: phone, completion: completion)
    }
    
    func verifyCode(
        phone: String,
        code: String,
        uiDevice: String,
        device_model: String,
        device_version: String,
        language: String,
        completion: @escaping (Result<Tokens, NSError>) -> Void
    ) {
        userRepository.verifyCode(
            phone: phone,
            code: code,
            uiDevice: uiDevice,
            deviceModel: device_model,
            deviceVersion: device_version,
            language: language,
            completion: completion
        )
    }
    
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, NSError>) -> Void
    ) {
        userRepository.signUp(firstName: firstName, lastName: lastName, completion: completion)
    }
    
    func refreshTokenWithCompletion(completion: @escaping (Result<Tokens, Error>) -> Void) {
        userRepository.refreshTokenWithCompletion(completion: completion)
    }
    
    // MARK: Profile
    
    func getProfile(completion: @escaping (Result<User, NSError>) -> Void) {
        userRepository.getProfile(completion: completion)
    }
   
    func deleteProfile(completion: @escaping (Result<ResponseBody?, NSError>) -> Void) {
        userRepository.deleteProfile(completion: completion)
    }
    

  
    
    func updateFCM(completion: @escaping (Result<ResponseBody?, Error>) -> Void) {
        userRepository.updateFCM(completion: completion)
    }
    
   
}
