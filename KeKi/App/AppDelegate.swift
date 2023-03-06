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
        
        instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = kConsumerKey // 상수 - client id
        instance?.consumerSecret = kConsumerSecret // pw
        instance?.appName = kServiceAppName // app name
        
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

