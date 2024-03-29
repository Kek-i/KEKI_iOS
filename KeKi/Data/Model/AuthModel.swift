//
//  AuthModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/18.
//

import Foundation

struct SocialLoginRequest: Codable {
    var email: String
    var provider: String
}

struct AuthResponse: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: Result?
    
    struct Result: Codable {
        var accessToken: String
        var refreshToken: String
        var role: String
    }
}

struct ProfileResponse<T: Codable>: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: T?
}

struct Signup: Codable {
    var nickname: String
    var profileImg: String? = nil
}

struct NicknameValid: Codable {
    var nickname: String
}

struct Seller: Codable {
    var storeImgUrl: String? = nil
    var nickname: String?
    var address: String?
    var introduction: String?
    var orderUrl: String?
    var businessName: String?
    var brandName: String?
    var businessAddress: String?
    var businessNumber: String?
}
