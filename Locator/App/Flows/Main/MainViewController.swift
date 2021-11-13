//
//  MainViewController.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    var onMap: (() -> Void)?
    var onLogout: (() -> Void)?
    
    @IBAction func showMap(_ sender: Any) {
        onMap?()
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onLogout?()
    }
}
