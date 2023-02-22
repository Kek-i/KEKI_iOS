//
//  HomeModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/09.
//

import Foundation

struct HomeResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Result
}

struct Result: Codable {
    var userIdx: Int? = nil
    var nickname: String? = nil
    var calendarTitle: String? = nil
    var calendarDate: Int? = nil
    var homeTagResList: [HomeTagRes]
}

struct HomeTagRes: Codable {
    var tagIdx: Int
    var tagName: String
    var homePostRes: [HomePostRes]
}

struct HomePostRes: Codable {
    var postIdx: Int
    var storeTitle: String
    var postImgUrl: String
}
