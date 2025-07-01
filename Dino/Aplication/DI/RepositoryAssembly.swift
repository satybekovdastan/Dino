//
//  RepositoryAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject

final class RepositoryAssembly: Assembly {
    
    func assemble(container: Container) {

        container.register(UserRepository.self) { resolver in
            
            guard let api = resolver.resolve(UserNetworkProtocolRequest.self) else {
                fatalError("Assembler was unable to resolve UserNetworkProtocolRequest")
            }

            return DefaultUserRepository(api: api)
        }.inObjectScope(.weak)
       
        
    }
    
}
