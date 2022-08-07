//
//  UserDefaultKey.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/23.
//

import Foundation

enum UserDefaultKey: String {
    case recentSearch
}

extension UserDefaults {
    func get<T>(_ userDefaultKey: UserDefaultKey) -> T? {
        object(forKey: userDefaultKey.rawValue) as? T
    }
    
    func set(_ userDefaultKey: UserDefaultKey, value: Any?) {
        setValue(value, forKey: userDefaultKey.rawValue)
    }
}
