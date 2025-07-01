//
//  UseCaseAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject

final class UseCaseAssembly: Assembly {
    
    func assemble(container: Container) {

        container.register(UserUseCase.self) { resolver in
            guard let repository = resolver.resolve(UserRepository.self) else {
                fatalError("Assembler was unable to resolve UserRepository")
            }
     
            return DefaultUserUseCase(userRepository: repository)
        }.inObjectScope(.transient)
        
        
    }
    
}
