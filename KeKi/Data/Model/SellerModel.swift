//
//  SellerModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/27.
//

import Foundation


struct FeedAddRequest: Codable {
    let dessertIdx: Int
    let description: String
    let postImgUrls, tags: [String]
}

// MARK: - Welcome
struct FeedAddResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: FeedAddResponseResult
}

// MARK: - Result
struct FeedAddResponseResult: Codable {
    let desserts: [DessertInfo]
    let tags: [String]
}

// MARK: - Dessert
struct DessertInfo: Codable {
    let dessertIdx: Int
    let dessertName: String
}
