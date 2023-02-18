//
//  CalendarModel.swift
//  KeKi
//
//  Created by 유상 on 2023/02/10.
//

import Foundation


// MARK: 기념일 목록 조회
struct CalendarListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [CalendarList]
}

struct CalendarList: Codable {
    let calendarIdx: Int
    let title, date, calDate: String
}

// MARK: 기념일 조회
struct CalendarResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Calendar
}

struct Calendar: Codable {
    let kindOfCalendar, title, date, calDate: String
    let hashTags: [CalendarHashTag]
}

struct CalendarHashTag: Codable {
    let calendarHashTag: String
}


// MARK: Hash Tag 조회
struct HashTagListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HashTag]
}

struct HashTag: Codable {
    let tagIdx: Int
    let tagName: String
}


// MARK: 기념일 추가, 기념일 수정
struct CalendarRequest: Codable {
    let kindOfCalendar, title, date: String
    let hashTags: [HashTagList]
}

struct HashTagList: Codable {
    let calendarHashTag: String
}
