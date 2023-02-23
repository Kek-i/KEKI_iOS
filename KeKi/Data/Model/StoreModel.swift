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
