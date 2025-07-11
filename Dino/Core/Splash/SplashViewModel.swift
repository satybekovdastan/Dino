//
//  SplashViewModel.swift
//  Shopping
//
//  Created by Das
//

import Foundation
import SystemConfiguration
import DummyAPI

enum SplashRoutes: Hashable {
    case mainTabBar
    case login
}

@MainActor
final class SplashViewModel: ObservableObject {
    
    private let dummyAPIService: DummyAPIServiceProtocol
    private let userDefaultsManager: UserDefaultManagerProtocol
    @Published var presentConnectionAlert = false
    @Published var isAuthUser = false
    @Published var shouldLogin = false
    
    private var isNetworkReachable: Bool {
        checkReachability()
    }
    
    init(dummyAPIService: DummyAPIServiceProtocol = DummyAPIService(),
         userDefaultManager: UserDefaultManagerProtocol = USerDefaultManager()) {
        self.dummyAPIService = dummyAPIService
        self.userDefaultsManager = userDefaultManager
    }
    
    private func checkReachability() -> Bool {
        if let reachability = SCNetworkReachabilityCreateWithName(nil, "www.apple.com") {
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            
            return flags.contains(.reachable) && !flags.contains(.connectionRequired)
        }
        return false
    }
    
    func manageSplashAction(completion: @escaping (_ isAuth: Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            if self.isNetworkReachable {
                if let token = self.userDefaultsManager.getItem(key: .authToken, type: String.self) {
                    self.dummyAPIService.getAuthUser(token: token) { results in
                        DispatchQueue.main.async {
                            switch results {
                            case .success(_):
                                completion(true)
                            case .failure(let failure):
                                switch failure {
                                case .unauthorized:
                                    if let refreshToken = self.userDefaultsManager.getItem(key: .refreshToken, type: String.self) {
                                        self.dummyAPIService.refreshToken(refreshToken: refreshToken, expiresInMins: 10) { results in
                                            DispatchQueue.main.async {
                                                switch results {
                                                case .success(let success):
                                                    self.userDefaultsManager.addItem(key: .authToken, item: success?.token)
                                                    self.userDefaultsManager.addItem(key: .refreshToken, item: success?.refreshToken)
                                                    completion(true)
                                                case .failure(_):
                                                    completion(false)
                                                }
                                            }
                                        }
                                    }
                                default:
                                    completion(false)
                                }
                            }
                        }
                    }
                } else {
                    completion(false)
                }
            } else {
                self.presentConnectionAlert.toggle()
            }
        }
    }
}
