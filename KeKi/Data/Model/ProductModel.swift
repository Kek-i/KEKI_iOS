//
//  ProductModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/23.
//

import Foundation

struct ProductsResponse: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: Product?
}

struct Product: Codable {
    var nickname: String
    var dessertName: String
    var dessertPrice: Int
    var dessertDescription: String
    var images: [Post]
}

struct Post: Codable {
    var imgIdx: Int
    var imgUrl: String
}



