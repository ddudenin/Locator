//
//  RecoveryPasswordViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

class RecoveryPasswordViewController: UIViewController {
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var recoveryButton: UIButton!
    
    var onRecover: (() -> Void)?
    
    @IBAction private func recoveryPasswordButtonHandler(_ sender: Any) {
        onRecover?()
    }
}
