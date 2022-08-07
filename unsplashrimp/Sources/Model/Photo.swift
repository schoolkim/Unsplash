//
//  Photo.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/06/04.
//

import Foundation
import UIKit

struct Photo: Hashable {
    var id: String
    var width: Int
    var height: Int
    var color: UIColor
    var user: User
    var urls: Urls
}

extension Photo {
    static var random: Photo {
        let width = Int.random(in: 128...256) * 10
        let height = Int.random(in: 128...256) * 10
        return Photo(id: UUID().uuidString,
                     width: width,
                     height: height,
                     color: .random,
                     user: User(id: UUID().uuidString,
                                name: .random),
                     urls: Urls(thumb: "https://picsum.photos/\(width)/\(height)")
        )
    }
}

extension String {
    static var random: String {
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return String(Data(uuidString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .prefix(12))
    }
}

struct User: Hashable {
    var id: String
    var name: String
}

struct Urls: Hashable {
    var thumb: String
}
