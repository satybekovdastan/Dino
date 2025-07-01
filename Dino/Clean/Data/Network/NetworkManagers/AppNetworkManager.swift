//
//  AppNetworkManager.swift
//  Navi
//
//  Created by DAS  on 6/4/23.
//  Copyright © 2023 Doit. All rights reserved.
//

import Foundation
import Swinject

final class AppNetworkManager {
    
    static let shared = AppNetworkManager()
    
    private let userNetworkRequest = Assembler.shared.resolver.resolve(UserNetworkProtocolRequest.self)!
   
    /// Получения данные пользователя
    func fetchUser(completion: ((UserResponse) -> Void)? = nil) {
        userNetworkRequest.getProfile { result in
            switch result {
            case .success(let data):
                completion?(data)
            case .failure:
                break
            }
        }
    }
 
    
    /// Обновления FCM токена
    func updateFCM() {
//        if Utils().isUserAuth() {
            userNetworkRequest.updateFCM { result in
                switch result {
                case .success:
                    print("updateFCM", "true")
                case .failure:
                    print("updateFCM", "false")
                }
            }
//        }
    }
    
   
}

