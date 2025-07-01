//
//  UserNetworkProtocolRequest.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//


import Foundation


/// Protocol for profile request
protocol UserNetworkProtocolRequest {
    
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
        completion: @escaping (Result<Tokens, CustomNetworkError>) -> Void
    )
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, CustomNetworkError>) -> Void
    )
    func refreshTokenWithCompletion(
        completion: @escaping (Result<Tokens, CustomNetworkError>) -> Void
    )
    
    // MARK: Profile
    
    func getProfile(completion: @escaping (Result<UserResponse, CustomNetworkError>) -> Void)
    func deleteProfile(completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void)
    
    
  
   
    // MARK: Notifications and Updates
    
    func updateFCM(completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void)
    
}
