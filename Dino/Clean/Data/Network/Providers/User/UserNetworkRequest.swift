//
//  UserNetworkRequest.swift
//  Navi
//
//  Created by DAS  on 8/3/23.
//  Copyright © 2023 Doit. All rights reserved.
//

import Foundation

final class UserNetworkRequest: UserNetworkProtocolRequest {
    
    // MARK: Properties
    
    private let networkManager: NetworkRequestPerformer
    
    // MARK: Initialization
    
    init(networkManager: NetworkRequestPerformer) {
        self.networkManager = networkManager
    }
    
    // MARK: Requests
    
    // MARK: Authentication
    
    func loginSendCode(
        phone: String,
        completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void
    ) {
        let profileRouter = UserRouter.loginSendCode(phone: phone)
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    func verifyCode(
        phone: String,
        code: String,
        uiDevice: String,
        device_model: String,
        device_version: String,
        language: String,
        completion: @escaping (Result<Tokens, CustomNetworkError>) -> Void
    ) {
        let profileRouter = UserRouter.verifyCode(
            phone: phone,
            code: code,
            uiDevice: uiDevice,
            deviceModel: device_model,
            deviceVersion: device_version,
            language: language
        )
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    func signUp(
        firstName: String,
        lastName: String,
        completion: @escaping (Result<ShortUser, CustomNetworkError>) -> Void
    ) {
        let profileRouter = UserRouter.signUp(firstName: firstName, lastName: lastName)
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    func refreshTokenWithCompletion(
        completion: @escaping (Result<Tokens, CustomNetworkError>) -> Void
    ) {
        let profileRouter = UserRouter.refreshTokenWithCompletion
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    // MARK: Profile
    
    func getProfile(completion: @escaping (Result<UserResponse, CustomNetworkError>) -> Void) {
        let commentRouter = UserRouter.getProfile
        networkManager.performRequest(route: commentRouter, completion: completion)
    }
    
    func deleteProfile(completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void) {
        let profileRouter = UserRouter.deleteProfile
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    // MARK: Bonuses
    
  
    // MARK: Notifications and Updates
    
    func updateFCM(completion: @escaping (Result<ResponseBody?, CustomNetworkError>) -> Void) {
        let profileRouter = UserRouter.updateFCM
        networkManager.performRequest(route: profileRouter, completion: completion)
    }
    
    
}
