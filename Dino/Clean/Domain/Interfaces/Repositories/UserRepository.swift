//
//  UserRepository.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//

import Foundation

protocol UserRepository {
    
    
    // MARK: Profile
    
    func getProfile(completion: @escaping (Result<User, NSError>) -> Void)
    
    // MARK: Authentication
    
    func loginSendCode(
        phone: String,
        completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void
    )
    func verifyCode(
        phone: String,
        code: String,
        uiDevice: String,
        deviceModel: String,
        deviceVersion: String,
        language: String,
        completion: @escaping (Result<Tokens, NSError>) -> Void
    )
    func refreshTokenWithCompletion(completion: @escaping (Result<Tokens, Error>) -> Void)
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, NSError>) -> Void
    )
    
    func updateFCM(completion: @escaping (Result<ResponseBody?, Error>) -> Void)
    
    // MARK: Profile Management
    
    func deleteProfile(completion: @escaping (Result<ResponseBody?, NSError>) -> Void)
    
}
