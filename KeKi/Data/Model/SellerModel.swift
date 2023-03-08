//
//  SellerModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/27.
//

import Foundation

// MARK: - 피드 등록 (POST)
struct FeedAddRequest: Codable {
    let dessertIdx: Int
    let description: String
    let postImgUrls, tags: [String]
}

// MARK: - 피드 등록 화면 (GET)
struct FeedAddResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: FeedAddResponseResult
}

struct FeedAddResponseResult: Codable {
    let desserts: [DessertInfo]
    let tags: [String]
}

struct DessertInfo: Codable {
    let dessertIdx: Int
    let dessertName: String
}




