//
//  BasicModel.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import Foundation

// MARK: POST 요청에 대한 응답이 거의 통일된 형태이므로, 공통된 Response 데이터 모델을 정의
struct GeneralResponseModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
}
