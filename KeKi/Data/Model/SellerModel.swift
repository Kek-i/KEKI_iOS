//
//  SellerModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/27.
//

import Foundation

// MARK: - 피드 등록 및 피드 수정 (POST, PATCH)
struct FeedRequest: Codable {
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

// MARK: - 피드 수정 화면 (GET)
struct FeedEditResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: FeedEdit
}

struct FeedEdit: Codable {
    let postIdx, currentDessertIdx: Int
    let currentDessertName, description: String
    let postImgUrls: [String]
    let currentTags: [String]
    let desserts: [DessertInfo]
    let tagCategories: [String]
}

// MARK: - 피드 추가 및 수정 공통 사용
struct DessertInfo: Codable {
    let dessertIdx: Int
    let dessertName: String
}


// MARK: - 상품 추가 및 수정 (POST, PATCH)
struct ProductRequest: Codable {
    let dessertName, dessertPrice, dessertDescription, dessertImg: String
}


// MARK: - 상품 수정 화면 (GET)
struct ProductEditResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ProductEdit
}

struct ProductEdit: Codable {
    let nickname: String
    let dessertImg: String
    let dessertName: String
    let dessertPrice: Int
    let dessertDescription: String
}
