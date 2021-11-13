//
//  ApplicationCoordinator.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMap()
        } else {
            toAuth()
        }
    }
    
    private func toMap() {
        let coordinator = MainCoordinator()
        
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        
        addDependency(coordinator)
        
        coordinator.start()
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        
        addDependency(coordinator)
        
        coordinator.start()
    }
}

