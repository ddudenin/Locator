//
//  AuthCoordinator.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {

    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?

    override func start() {
        showLoginModule()
    }

    private func showLoginModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)

        controller.onRecover = { [weak self] in
            self?.showRecoverModule()
        }

        controller.onRegistration = { [weak self] in
            self?.showSignUpModule()
        }

        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }

    private func showRecoverModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RecoveryPasswordViewController.self)
        rootController?.pushViewController(controller, animated: true)
    }

    private func showSignUpModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(SignUpViewController.self)
        rootController?.pushViewController(controller, animated: true)

        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }
    }
}
