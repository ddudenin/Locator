//
//  SignUpViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
    var onLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSignUpBindings()
    }

    @IBAction private func SignUpButtonHandler(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            showAlertController(message: "Не удалось прочитать данные пользователя")
            return
        }

        let users: Results<User>? = RealmManager
            .shared?
            .getObjects()
            .filter("login = %@", login)

        guard
            let logins = users,
            logins.isEmpty
        else {
            showAlertController(message: "Пользователь с таким именем уже зарегистрирован")
            return
        }

        do {
            let newUser = User()
            newUser.login = login
            newUser.password = password

            try RealmManager.shared?.add(object: newUser)
        } catch {
            print(error.localizedDescription)
            return
        }

        UserDefaults.standard.set(true, forKey: "isLogin")

        onLogin?()
    }

    private func showAlertController(message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        present(alert, animated: true)
    }
    
    private func configureSignUpBindings() {
        _ = Observable
            .combineLatest(
                loginTextField.rx.text,
                passwordTextField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 8
            }
            .bind { [weak signUpButton] inputFilled in
                signUpButton?.isEnabled = inputFilled
            }
    }
}
