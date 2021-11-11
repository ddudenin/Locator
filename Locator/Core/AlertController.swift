//
//  AlertController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 11.11.2021.
//

import UIKit

func showAlertController(message: String) {
    let alert = UIAlertController(title: "Ошибка",
                                  message: message,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    
    present(alert, animated: true)
}
