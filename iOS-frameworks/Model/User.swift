//
//  User.swift
//  iOS-frameworks
//
//  Created by Vit K on 26.02.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login : String? = nil
    @objc dynamic var password : String? = nil
    
    override static func primaryKey() -> String? {
        return "login"
    }
}
