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
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Result
    
    struct Result: Codable {
        var accessToken: String
        var refreshToken: String
        var role: String
    }
}

struct ProfileResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Signup
}

struct Signup: Codable {
    var nickname: String
    var profileImg: String? = nil
}

struct NicknameValid: Codable {
    var nickname: String
}

struct Seller: Codable {
    var storeImgUrl: String
    var nickname: String
    var address: String
    var introduciton: String?
    var orderUrl: String
    var businessName: String
    var brandName: String
    var businessAddress: String
    var businessNumber: String
}
