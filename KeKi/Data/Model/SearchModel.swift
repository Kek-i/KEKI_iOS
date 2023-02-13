//
//  SearchModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/13.
//

import Foundation


struct SearchMainResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: SearchMainResult
}

// MARK: - Result
struct SearchMainResult: Codable {
    let recentSearches, popularSearches: [Search]
    let recentPostSearches: [RecentPostSearch]
}

// MARK: - Search
struct Search: Codable {
    let searchWord: String
}

// MARK: - RecentPostSearch
struct RecentPostSearch: Codable {
    let postIdx: Int
    let postImgURL: String

    enum CodingKeys: String, CodingKey {
        case postIdx
        case postImgURL = "postImgUrl"
    }
}



struct NoLoginSearchMainResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: NoLoginSearchMainResult
}

// MARK: - Result
struct NoLoginSearchMainResult: Codable {
    let recentSearches: JSONNull?
    let popularSearches: [Search]
    let recentPostSearches: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
