//
//  FeedModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/21.
//

import Foundation

struct SingleFeedResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Feed
}

