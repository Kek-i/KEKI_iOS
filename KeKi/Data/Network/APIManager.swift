//
//  APIManager.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import Foundation
import Alamofire

private let DEV_BASE_URL = "https://keki-dev.store" // 개발용 

private let buyerAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWR4IjoxLCJzdWIiOiIxIiwiZXhwIjoxNjc4NjA2ODE4fQ.0oqG7wBSUu2VaFyZCwn2ovP30KAHXq4DY7ZGoXKcUP0"    // 임시 구매자 액세스 토큰
private let sellerAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWR4IjoyLCJzdWIiOiIyIiwiZXhwIjoxNjc4MzIyMTM1fQ.oy_uRpYrWuV9yZO0vTWWpLgVNiEURasgupR5ROjsqm0"    // 임시 판매자 액세스 토큰

class APIManeger {
    // 임시 액세스 토큰 (구매자,판매자)
    static let buyerTokenHeader = HTTPHeaders(["Authorization": buyerAccessToken])
    static let sellerTokenHeader = HTTPHeaders(["Authorization": sellerAccessToken])
    
    
    private var userInfo: AuthResponse.Result? = nil
    private var header: HTTPHeaders? = nil

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
            .request(url, method: .get, parameters: parameter, headers: header ?? nil)
            .responseDecodable(of: T.self) { response in
                print(response)
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }

//    // MARK: 제네릭을 사용하지 않았을 경우의 get 통신 메소드 (회의 후 삭제 예정)
//    func getAnnouncementList(completionHandler: @escaping ([AnnouncementListResponse.Result])->Void) {
//        guard let url = URL(string: DEV_BASE_URL + "/cs/notice") else { return }
//
//        AF
//            .request(url, method: .get)
//            .responseDecodable(of: AnnouncementListResponse.self) { response in
//                switch response.result {
//                case .success(let success):
//                    completionHandler(success.result)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//            .resume()
//    }
//
//    func getAnnouncement(index: Int, completionHandler: @escaping (AnnouncementResponse.Announcement)->Void) {
//        guard let url = URL(string: DEV_BASE_URL + "/cs/notice/\(index)") else { return }
//
//        AF
//            .request(url, method: .get)
//            .responseDecodable(of: AnnouncementResponse.self) { response in
//                switch response.result {
//                case .success(let success):
//                    completionHandler(success.result)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//            .resume()
//    }
    
    
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
                               parameter: T?,
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
    
    
    // MARK: 소셜 로그인 용 임시 메소드
//    func postSignup<T: Codable>(urlEndpointString: String,
//                              dataType: T.Type,
//                              header: HTTPHeaders?,
//                              parameter: T,
//                              completionHandler: @escaping (AuthResponse) -> Void) {
//        
//        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }
//
//        AF
//            .request(url,
//                     method: .post,
//                     parameters: parameter,
//                     encoder: .json,
//                     headers: header)
//            .responseDecodable(of: AuthResponse.self) { response in
//                print("response :: \(response)")
//                switch response.result {
//                case .success(let success):
//                    print(success)
//                    completionHandler(success)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//            .resume()
//    }
}


// MARK: 소셜 로그인 기능이 병합된 후 변경할 요청 메소드 정의
extension APIManeger {
    // 앱 시작 시, SceneDelegate에서 호출할 설정 메소드
    func setUserInfo(userInfo: AuthResponse.Result) {
        self.userInfo = userInfo
        self.header = HTTPHeaders(["Authorization": userInfo.accessToken])
    }
    
    func getUserInfo() -> AuthResponse.Result { return self.userInfo! }
    
    func getHeader() -> HTTPHeaders? { return header }
    func getHeaderByToken(accessToken: String) -> HTTPHeaders { return HTTPHeaders(["Authorization": accessToken]) }
    func resetHeader() { header = nil }
    
    func testGetData<T: Decodable>(urlEndpointString: String,
                                   dataType: T.Type,
                                   parameter: Parameters?,
                                   completionHandler: @escaping (T)->Void) {

            guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }


            AF
                .request(url, method: .get,
                         parameters: parameter,
                         encoding: URLEncoding.queryString,
                         headers: self.header ?? nil)
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
    
    func testPostData<T: Codable>(urlEndpointString: String,
                              dataType: T.Type,
                              parameter: T?,
                              completionHandler: @escaping (GeneralResponseModel) -> Void) {
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .post,
                     parameters: parameter,
                     encoder: .json,
                     headers: self.header ?? nil)
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
    
    
    func testPatchData<T: Codable>(urlEndpointString: String,
                               dataType: T.Type,
                               parameter: T?,
                               completionHandler: @escaping (GeneralResponseModel) -> Void) {
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .patch,
                     parameters: parameter,
                     encoder: .json,
                     headers: self.header ?? nil)
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
    
    func testDeleteData(urlEndpointString: String,
                        completionHandler: @escaping (GeneralResponseModel) -> Void) {
             
             guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

             AF
                 .request(url,
                          method: .delete,
                          headers: self.header ?? nil)
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
    
    
    // MARK: 소셜 로그인 용 임시 메소드
    func postSignup<T: Codable>(urlEndpointString: String,
                              dataType: T.Type,
                              parameter: T,
                              completionHandler: @escaping (AuthResponse) -> Void) {
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as! String
        let header = APIManeger.shared.getHeaderByToken(accessToken: accessToken)
        
        guard let url = URL(string: DEV_BASE_URL + urlEndpointString) else { return }

        AF
            .request(url,
                     method: .post,
                     parameters: parameter,
                     encoder: .json,
                     headers: header)
            .responseDecodable(of: AuthResponse.self) { response in
                print("response :: \(response)")
                switch response.result {
                case .success(let success):
                    print(success)
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
