//
//  HeartModel.swift
//  KeKi
//
//  Created by 유상 on 2023/03/13.
//

import Foundation

// MARK: - 찜 목록 조회 (GET)
struct HeartResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HeartResponseResult
}


struct HeartResponseResult: Codable {
    let feeds: [Feed]
    let cursorDate: String
    let hasNext: Bool
    let numOfRows: Int
}
