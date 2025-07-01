//
//  NetworkAssembly.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject

final class NetworkAssembly: Assembly {
    
    func assemble(container: Container) {
        
        
           container.register(NetworkRequestPerformer.self) { resolver in
//               guard let userDefaultsManager = resolver.resolve(UserDefaultsManager.self) else {
//                   fatalError("Assembler was unable to resolve UserDefaultsManager")
//               }
               
               return DefaultNetworkRequestPerformer()
           }.inObjectScope(.container)
        
        container.register(UserNetworkProtocolRequest.self) { resolver in
            guard let networkManager = resolver.resolve(NetworkRequestPerformer.self) else {
                fatalError("Assembler was unable to resolve NetworkRequestPerformer")
            }
            
            return UserNetworkRequest(networkManager: networkManager)
        }.inObjectScope(.weak)
        
     
        
    }
    
}
