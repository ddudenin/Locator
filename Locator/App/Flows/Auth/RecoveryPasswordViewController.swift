//
//  RecoveryPasswordViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

import UIKit

class RecoveryPasswordViewController: UIViewController {
    
    //MARK: - Constants and Variables
    //let userRepository = UserRepository()
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBAction func recoveryPasswordButtonHandler(_ sender: Any) {
        guard
            let login = loginTextField.text//,
                //let user = try? userRepository.searchUser(login: login),
                //!user.isEmpty
        else {
            
            return
        }
        
        //showPassword(user: user)
    }
    
    /*private func showPassword(user: [User]) {
     let alert = UIAlertController(title: "Пароль", message: "\(user[0].password)", preferredStyle: .alert)
     
     let ok = UIAlertAction(title: "OK", style: .cancel)
     alert.addAction(ok)
     present(alert, animated: true)
     }*/
}
