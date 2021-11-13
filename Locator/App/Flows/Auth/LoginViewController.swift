//
//  LoginViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit
import RealmSwift

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
        
        configureRecoveryLabel()
    }
    
    @IBAction private func login(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            showAlertController(message: "Не удалось прочитать данные пользователя")
            return
        }
        
        guard
            !login.isEmpty,
            !password.isEmpty
        else {
            showAlertController(message: "Введены не все данные")
            return
        }
        
        let users: Results<User>? = RealmManager
            .shared?
            .getObjects()
            .filter("login = %@ AND password = %@", login, password)
        
        guard
            let user = users,
            !user.isEmpty
        else {
            showAlertController(message: "Данный пользователь не зарегистрирован")
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        onLogin?()
    }
    
    @IBAction private func registration(_ sender: Any) {
        onRegistration?()
    }
    
    private func showAlertController(message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func configureRecoveryLabel() {
        let guestureRecognizer = UITapGestureRecognizer(target: self,
                                                        action: #selector(recoveryLabelClicked(_:)))
        recoveryLabel.addGestureRecognizer(guestureRecognizer)
        recoveryLabel.isUserInteractionEnabled = true
    }
    
    @objc func recoveryLabelClicked(_ sender: Any) {
        onRecover?()
    }
}
