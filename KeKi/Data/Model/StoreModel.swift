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
    var nickname: String?
    var storeImgUrl: String?
    var introduction: String?
    var orderUrl: String?
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


// MARK: - 사업자 정보 조회 (GET)
struct SellerInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SellerInfo
}
struct SellerInfo: Codable {
    let businessName, brandName, businessAddress, businessNumber: String
}



// MARK: - 판매자 프로필 조회
struct SellerProfileResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SellerProfile
}

struct SellerProfile: Codable {
    let storeIdx: Int
    let storeImgURL, email, nickname: String?
    let address, introduction, orderURL, businessName: String?
    let brandName, businessAddress, businessNumber: String?

    enum CodingKeys: String, CodingKey {
        case storeIdx
        case storeImgURL = "storeImgUrl"
        case email, nickname, address, introduction
        case orderURL = "orderUrl"
        case businessName, brandName, businessAddress, businessNumber
    }
}
