//
//  Assembler+Extensions.swift
//  CleanMVVM
//
//  Created by SOSA PEREZ Cesar on 22/03/2021.
//

import Swinject

extension Assembler {
    
    static let shared: Assembler = {
        let container = Container()
        
        let assembler = Assembler([
            ViewControllerAssembly(),
            ViewModelAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            NetworkAssembly(),
            PersistenceAssembly(),
            ManagerAssembly()
        ], container: container)
        
        return assembler
    }()
    
}
