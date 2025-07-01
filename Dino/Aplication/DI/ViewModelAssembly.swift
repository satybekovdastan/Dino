//
//  ViewModelAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject

final class ViewModelAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
    
//        container.register(UserViewModel.self) { resolver in
//            guard let userUseCase = resolver.resolve(UserUseCase.self) else {
//                fatalError("Assembler was unable to resolve UserUseCase")
//            }
//            
//            guard let userDefaultsManager = resolver.resolve(UserDefaultsManager.self) else {
//                fatalError("Assembler was unable to resolve UserDefaultsManager")
//            }
//            
//            return DefaultUserViewModel(
//                userUseCase:  userUseCase,
//                userDefaultsManager: userDefaultsManager
//            )
//        }.inObjectScope(.transient)
    
        container.register(LoginViewModel.self) { resolver in
            guard let userUseCase = resolver.resolve(UserUseCase.self) else {
                fatalError("Assembler was unable to resolve UserUseCase")
            }
            
            return LoginViewModel(
                userUseCase:  userUseCase
            )
        }.inObjectScope(.transient)
        
        
    }
    
}
