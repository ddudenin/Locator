//
//  User.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 10.11.2021.
//

import RealmSwift

class User: Object {
    @objc dynamic var login : String = ""
    @objc dynamic var password : String = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
