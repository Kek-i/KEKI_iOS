//
//  StoreModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/23.
//

import Foundation

struct StoreResponse: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: Store?
}

struct Store: Codable {
    var nickname: String
    var storeImgUrl: String
    var introduction: String
    var orderUrl: String
}

struct ProductResponse: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: ProductResult?
}

struct ProductResult: Codable {
    var desserts: [Dessert]
    var cursorIdx: Int
    var hasNext: Bool
}

struct Dessert: Codable {
    var dessertIdx: Int
    var dessertImgUrl: String
    var dessertName: String
}
