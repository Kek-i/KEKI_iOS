//
//  SearchModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/13.
//

import Foundation

// MARK: 로그인 O 검색 메인 화면 (최근 검색어, 인기 검색어, 최근 본 케이크)
struct SearchMainResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SearchMainResult
}

struct SearchMainResult: Codable {
    let recentSearches, popularSearches: [Search]
    let recentPostSearches: [RecentPostSearch]
}

// MARK: 로그인 X 검색 메인 화면 (최근 검색어 X, 인기 검색어, 최근 본 케이크 X)
struct NoLoginSearchMainResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NoLoginSearchMainResult
}

struct NoLoginSearchMainResult: Codable {
    let recentSearches: [Search]?
    let popularSearches: [Search]
    let recentPostSearches: [RecentPostSearch]?
}

// MARK: 최근 검색어
struct RecentSearchesResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Search]
}

struct Search: Codable {
    let searchWord: String
}

struct RecentPostSearch: Codable {
    let postIdx: Int
    let postImgURL: String

    enum CodingKeys: String, CodingKey {
        case postIdx
        case postImgURL = "postImgUrl"
    }
}

// MARK: 검색 결과
struct SearchResultResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SearchResult
}

struct SearchResult: Codable {
    let feeds: [Feed]?
    let cursorIdx: Int?
    let cursorPrice, cursorPopularNum: Int?
    let hasNext: Bool
    let numOfRows: Int
}

struct Feed: Codable {
    let postIdx: Int
    let dessertIdx: Int
    let dessertName: String
    let dessertPrice: Int
    let description: String
    let postImgUrls: [String]
    let tags: [String]
    let storeIdx: Int
    let storeName: String
    let storeProfileImg: String?
    let like: Bool
}



