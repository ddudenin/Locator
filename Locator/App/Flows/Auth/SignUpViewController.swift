//
//  SignUpViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit
import RealmSwift

class SignUpViewController: UIViewController {

    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    var onLogin: (() -> Void)?

    @IBAction private func SignUpButtonHandler(_ sender: Any) {
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
}
