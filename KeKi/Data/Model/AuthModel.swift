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

struct AuthResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Result
    
    struct Result: Decodable {
        var accessToken: String
        var refreshToken: String
        var role: String
    }
}

struct Signup: Codable {
    var nickname: String
    var profileImg: String
}

struct NicknameValid: Codable {
    var nickname: String
}
