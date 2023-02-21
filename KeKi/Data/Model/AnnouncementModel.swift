//
//  AnnouncementModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import Foundation

// MARK: 공지사항에 대한 서버 통신에 필요한 데이터 모델 정의
struct AnnouncementListResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [Result]
    
    struct Result: Decodable {
        var noticeIdx: Int
        var noticeTitle: String
    }
}

struct AnnouncementResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Announcement
    
    struct Announcement: Decodable {
        var noticeTitle: String
        var noticeContent: String
    }
}
