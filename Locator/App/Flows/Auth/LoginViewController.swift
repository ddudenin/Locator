//
//  LoginViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    //let userRepository = UserRepository()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var recoveryLabel: UILabel!
    
    var onLogin: (() -> Void)?
    var onRecover: (() -> Void)?
    var onRegistration: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        recoveryLabel.addGestureRecognizer(guestureRecognizer)
        recoveryLabel.isUserInteractionEnabled = true
    }
    
    @IBAction func login(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text//,
                //let user = try? userRepository.compareUserData(login: login, password: password),
                //!user.isEmpty
        else {
            showTextFields()
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        onLogin?()
    }
    
    @objc func labelClicked(_ sender: Any) {
        onRecover?()
        print("UILabel clicked")
    }
    
    @IBAction func registration(_ sender: Any) {
        onRegistration?()
    }
    
    @objc func showTextFields() {
        let alert = UIAlertController(title: "Error", message: "Повторите ввод", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.passwordTextField.text = ""
            self.loginTextField.text = ""
            self.passwordTextField.isSecureTextEntry = true
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
}
