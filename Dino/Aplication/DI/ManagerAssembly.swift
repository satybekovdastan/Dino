//
//  ManagerAssembly.swift
//  Navi
//
//  Created by Daniil Rassadin on 15/4/25.
//  Copyright © 2025 Reviro. All rights reserved.
//

import Swinject

final class ManagerAssembly: Assembly {
    
    func assemble(container: Swinject.Container) {
        container.register(UserDefaultsManager.self) { _ in
            DefaultUserDefaultsManager.shared
        }.inObjectScope(.container)
      
    }
    
}
