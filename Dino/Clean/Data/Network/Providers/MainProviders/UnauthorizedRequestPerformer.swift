//
//  UnauthorizedRequestPerformer.swift
//  Navi
//
//  Created by DAS  on 29/8/24.
//  Copyright © 2024 Reviro. All rights reserved.
//

import Foundation
import Swinject

// Обертка для хранения любого запроса
struct AnyPendingRequest {
    let route: APIConfiguration
    let perform: (APIConfiguration) -> Void
}

extension DefaultNetworkRequestPerformer {
    
    private func refreshToken(completion: @escaping (Result<Void, CustomNetworkError>) -> Void) {
//        if userDefaultsManager.token.isEmpty {
//            logout()
//            return
//        }
        guard !isRefreshingToken else { return }
        
        isRefreshingToken = true
        
        // Запрос на обновление токена
        let route = UserRouter.refreshTokenWithCompletion
        performRequest(route: route) { [weak self] (result: Result<Tokens, CustomNetworkError>) in
            guard let self else { return }
            
            switch result {
            case .success(let tokens):
//                userDefaultsManager.token = tokens.accessToken
//                userDefaultsManager.refreshToken = tokens.refreshToken
                processPendingRequests()
            case .failure:
                logout()
            }
            isRefreshingToken = false
        }
    }
    
    private func processPendingRequests() {
        while !pendingRequests.isEmpty {
            let request = pendingRequests.removeFirst()
            request.perform(request.route) // Выполнение запроса с передачей маршрута
        }
    }
    
    func handleUnauthorizedStatusCode<T: Decodable>(
        route: APIConfiguration,
        completion: @escaping (Result<T, CustomNetworkError>) -> Void
    ) {
        if let url = route.urlRequest?.url?.absoluteString,
           url == "\(AppRequestConfigurations.baseStringURL)api/v1/auth/generate-tokens/" {
            logout()
            completion(.failure(.error_401))
            return
        }
        
        // Обертка выполнения запроса для универсальности
        let perform: (APIConfiguration) -> Void = { [weak self] route in
            self?.performRequest(route: route, completion: completion)
        }
        
        // Добавление запроса в обертке
        let pendingRequest = AnyPendingRequest(route: route, perform: perform)
        pendingRequests.append(pendingRequest)
        
        // Если токен не обновляется, запускаем процесс обновления токена
        if !isRefreshingToken {
            refreshToken { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    processPendingRequests()
                case .failure:
                    logout()
                }
            }
        }
    }
    
    func logout() {
        isRefreshingToken = false
        pendingRequests.removeAll()
        LoginLogoutManager.logout()
    }
    
}
