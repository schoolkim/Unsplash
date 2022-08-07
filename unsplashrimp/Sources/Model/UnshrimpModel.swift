//
//  UnshrimpModel.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/06/24.
//

import Foundation

struct UNSearchResponse: Decodable {
    var total: Int
    var totalPages: Int
    var results: [UnPhoto]
}

struct UnTopic: Decodable, Identifiable, Hashable {
    var id: String
    var title: String
}

struct UnError : Error, Decodable {
    var errors: [String]
    
    static var decodingError: UnError {
        UnError(errors: ["Occur Decoding Error"])
    }
}

struct UnPhoto: Decodable, Hashable {    
    var id: String
    var width: Float
    var height: Float
    var color: String
    var urls: UnUrls
    var user: UnUser
}

struct UnUrls: Decodable, Hashable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

struct UnUser: Decodable, Hashable {
    var id: String
    var name: String
}
