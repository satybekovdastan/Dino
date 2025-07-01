//
//  ViewControllerAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject
import UIKit

final class ViewControllerAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        
        container.register(LoginView.self) { resolver in
            guard let viewModel = resolver.resolve(LoginViewModel.self) else {
                       fatalError("Unable to resolve UserViewModel")
                   }
            return LoginView.create(with: viewModel)
               }.inObjectScope(.transient)
       
//        container.register(AuthVC.self) { resolver in
//            guard let viewModel = resolver.resolve(UserViewModel.self) else {
//                fatalError("Assembler was unable to resolve UserViewModel")
//            }
//            
//            guard let userDefaultsManager = resolver.resolve(UserDefaultsManager.self) else {
//                fatalError("Assembler was unable to resolve UserDefaultsManager")
//            }
//            
//            return AuthVC(viewModel: viewModel, userDefaultsManager: userDefaultsManager)
//        }.inObjectScope(.transient)
//        
//        container.register(VerificationVC.self) { resolver in
//            guard let viewModel = resolver.resolve(UserViewModel.self) else {
//                fatalError("Assembler was unable to resolve UserViewModel")
//            }
//            return VerificationVC.create(with: viewModel)
//        }.inObjectScope(.transient)
//        
//        container.register(SignUpVC.self) { resolver in
//            guard let viewModel = resolver.resolve(UserViewModel.self) else {
//                fatalError("Assembler was unable to resolve UserViewModel")
//            }
//            return SignUpVC.create(with: viewModel)
//        }.inObjectScope(.transient)
//        
       
    }
}
