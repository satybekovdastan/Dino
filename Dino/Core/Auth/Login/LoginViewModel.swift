//
//  LoginViewModel.swift
//  Shopping
//
//  Created by Das
//

import Foundation
import DummyAPI
import Swinject

protocol LoginViewModelProtocol {
    func loginTapped(completion: @escaping (_ isSuccess: Bool) -> Void)
    func signUpTapped()
}

final class LoginViewModel: ObservableObject {
    
    //Dependencies
    //    private let service: DummyAPIServiceProtocol
    private let userDefaultManager: UserDefaultManagerProtocol
    
    //Published variables
    @Published var username: String = "emilys"
    @Published var password: String = "emilyspass"
    @Published var isPresentAlert = false
    @Published var showSignup = false
    @Published var showActivity = false
    
    //Variables
    private(set) var errorMessage: String = ""
    private(set) var isProgress: Bool = false
    
    private let userUseCase: UserUseCase
    
    //Init
    //    init(service: DummyAPIServiceProtocol = DummyAPIService(),
    //         userDefaultsManager: UserDefaultManagerProtocol = USerDefaultManager()) {
    //        self.service = service
    //        self.userDefaultManager = userDefaultsManager
    //    }
    init(userUseCase: UserUseCase, userDefaultsManager: UserDefaultManagerProtocol = USerDefaultManager()) {
        self.userUseCase = userUseCase
        self.userDefaultManager = userDefaultsManager
    }
    
}

//MARK: ViewModel Protocols
extension LoginViewModel: LoginViewModelProtocol {
    
    func loginTapped(completion: @escaping (_ isSuccess: Bool) -> Void) {
        if !username.isEmpty && !password.isEmpty {
            //            self.showActivity = true
            //            service.login(username: self.username, password: self.password) { [weak self] results in
            //                guard let self else { return }
            //                DispatchQueue.main.async {
            //                    self.showActivity = false
            //                    switch results {
            //                    case .success(let login):
            //                        completion(true)
            //                        self.userDefaultManager.addItem(key: .authToken, item: login?.token)
            //                        self.userDefaultManager.addItem(key: .refreshToken, item: login?.refreshToken)
            //                    case .failure(let failure):
            //                        self.errorMessage = failure.errorDescription
            //                        self.isPresentAlert.toggle()
            //                    }
            //                }
            //            }
            
            isProgress = true
            
            userUseCase.loginSendCode(phone: username) { [weak self] result in
                guard let self else { return }
                
                isProgress = false
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    switch error {
                    case .errorData(let data):
                        print("EERROORR \(String(describing: data?.message))")
                        errorMessage = data?.message ?? Constants.unknownError
                        self.isPresentAlert.toggle()
                    default:
                        errorMessage = Constants.unknownError
                    }
                    
                }
            }
        } else {
            DispatchQueue.main.async {
                self.isPresentAlert.toggle()
                self.errorMessage = "Email or password cannot be empty."
            }
        }
        
        
    }
    
    func signUpTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.showSignup.toggle()
        }
    }
}

extension LoginViewModel {
    static var mock: LoginViewModel {
        let useCase = Assembler.shared.resolver.resolve(UserUseCase.self)!
        let vm = LoginViewModel(userUseCase: useCase)
//        vm.errorMessage = "Ошибка при авторизации"
//        vm.isPresentAlert = true
        return vm
    }
}
