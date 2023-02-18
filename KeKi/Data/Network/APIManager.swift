//
//  APIManager.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import Foundation
import Alamofire

private let DEV_BASE_URL = "https://keki-dev.store" // 개발용 

private let buyerAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWR4IjoxLCJzdWIiOiIxIiwiZXhwIjoxNjc2OTY3MDE0fQ.Fiuxn5L8uepxdXBnkTNWk2j9Mw6IXR6u6SQPjQCk6QI"    // 임시 구매자 액세스 토큰
private let sellerAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWR4IjoxLCJzdWIiOiIxIiwiZXhwIjoxNjc1NjkzODMzfQ.4o2Lc_tMUvQJY1PP_dPQOxeOaeRVkT-HyUciBR_659s"    // 임시 판매자 액세스 토큰

class APIManeger {
    
    // 임시 액세스 토큰 (구매자,판매자)
    static let buyerTokenHeader = HTTPHeaders(["Authorization": buyerAccessToken])
    static let sellerTokenHeader = HTTPHeaders(["Authorization": buyerAccessToken])
    
    static let shared = APIManeger()    // 과한 객체 생성으로 인한 메모리 낭비를 줄이기 위함
    
    // MARK: 제네릭을 활용한 서버와의 GET 통신 메소드
    // ---
    // ---
    // T -> Decodable 프로토콜을 준수하는 데이터 모델 타입 (Ex. AnnouncementListResponse 참조)
    // urlEndpointString -> get 메소드를 통한 통신을 할 api url에서 BASE URL을 제외한 나머지 url 문자열
    // completionHandler -> 아래 메소드를 통해 서버로부터 데이터를 가져온 후, VC에서 해당 데이터를 가지고 어떤 작업을 할 건지 정의(여기서 정의하는 것 X, VC에서 getData 메소드 호출하면서 정의)
    // ---
    // 제네릭을 사용하였기 때문에, 성공적으로 데이터를 가져온다면 서버에서 주는 JSON 데이터를 통째로 받아옴 (switch문의 .success 케이스)
    // 때문에 VC에서 필요한 부분만 추출하여 사용하는 것에 유의
    func getData<T: Decodable>(urlEndpointString: String,
                               dataType: T.Type,
                               header: HTTPHeaders?,
                               parameter: Parameters?,
                               completionHandler: @escaping (T)->Void) {
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }
        
        
        AF
            .request(url, method: .get,
                     parameters: parameter ?? nil,
                     encoding: URLEncoding.queryString,
                     headers: header ?? nil)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    
    // MARK: 제네릭을 활용한 서버와의 POST 통신 메소드
    func postData<T: Codable>(urlEndpointString: String,
                              dataType: T.Type,
                              header: HTTPHeaders?,
                              parameter: T,
                              completionHandler: @escaping (GeneralResponseModel) -> Void) {
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .post,
                     parameters: parameter,
                     encoder: .json,
                     headers: header)
            .responseDecodable(of: GeneralResponseModel.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
    
    // MARK: 제네릭을 활용한 서버와의 PATCH 통신 메소드 -
    func patchData<T: Codable>(urlEndpointString: String,
                               dataType: T.Type,
                               header: HTTPHeaders?,
                               parameter: T,
                               completionHandler: @escaping (GeneralResponseModel) -> Void) {
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .patch,
                     parameters: parameter,
                     encoder: .json,
                     headers: header)
            .responseDecodable(of: GeneralResponseModel.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
