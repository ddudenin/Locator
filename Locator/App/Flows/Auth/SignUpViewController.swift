//
//  SignUpViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //let userRepository = UserRepository()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var onLogin: (() -> Void)?
    
    @IBAction func SignUpButtonHandler(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let error = checkTextFields()
        /*let repeatLogin = try? userRepository.searchUser(login: login)
         if error == nil && ((repeatLogin?.isEmpty) == true) {
         userRepository.saveUserData(login: login, password: password)
         onLogin?()
         }else{*/
        let alert = UIAlertController(title: "Error", message: "Аккаунт с таким именем уже существует", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true)
        //}
    }

    func checkTextFields() -> String? {
        if loginTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Заполните все поля."
        }else{
            return nil
        }
    }
    
    @objc func showTextFields() {
        let alert = UIAlertController(title: "Error", message: "Повторите ввод", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
        }
        alert.addAction(action)
        present(alert, animated: true)
        self.passwordTextField.text = ""
        self.loginTextField.text = ""
        self.passwordTextField.isSecureTextEntry = true
    }
}
