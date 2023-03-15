//
//  AppDelegate.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore

import KakaoSDKCommon
import KakaoSDKAuth

import NaverThirdPartyLogin

import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Kakao
        let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: nativeAppKey as! String)
        
        // Naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true  // 네이버 앱으로 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true // SafariViewController에서 인증하는 방식 활성화
        instance?.isOnlyPortraitSupportedInIphone() // 인증 화면을 아이폰의 세로모드에서만 적용
        
        instance?.serviceUrlScheme = "https://keki-dev.store/users/callback/naver" // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = "XEK5Tv83wP" // 상수 - client id
        instance?.consumerSecret = "XZHzyRgQditsj_BuDAHZ" // pw
        instance?.appName = "케키" // app name
        
        
        // Loacl Notification
        let center = UNUserNotificationCenter.current() // 알림 센터 가져오기
        center.delegate = self // delegate 패턴을 이용한 처리 (extension으로 구현)
        
        let options = UNAuthorizationOptions(arrayLiteral: [.badge, .sound])    // 권한 종류 (뱃지, 소리)
        
        center.requestAuthorization(options: options) { success, error in
            // 권한 요청 메서드 :: 권한에 따라 success가 허용->true, 거부->error
            if let error = error {
                print("에러 발생: \(error.localizedDescription)")
            }
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)

        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 foreground에 있을때 알림이 오면 이 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 푸쉬가 오면 다음을 표시하라는 뜻
        // 배너는 배너, 뱃지는 앱 아이콘에 숫자 뜨는 것, 사운드는 알림 소리, list는 알림센터에 뜨는 것
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    // 사용자가 알림을 터치하면 호출되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // apns에 simulator Target Bundle 아래에 추가로 전달될 값(여기선 다루지 않음)
        // let value = response.notification.request.content.userInfo["key값"]
    }
}

