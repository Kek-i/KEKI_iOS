//
//  SceneDelegate.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit
import KakaoSDKAuth
import NaverThirdPartyLogin
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // MARK: Setting UserInfo (token , role)
        if let _ = UserDefaults.standard.object(forKey: "userInfo") {
            if let data = UserDefaults.standard.value(forKey: "userInfo") as? Data {
                let decodedUserInfo = try? PropertyListDecoder().decode(AuthResponse.Result.self, from: data)
                if let _ = decodedUserInfo { APIManeger.shared.setUserInfo(userInfo: decodedUserInfo!) }
            }
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DefaultTabBarController()
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
            NaverThirdPartyLoginConnection
                    .getSharedInstance()?
                    .receiveAccessToken(URLContexts.first?.url)
        }
        
        guard let scheme = URLContexts.first?.url.scheme else { return }
        if scheme.contains("com.googleusercontent.apps") {
            GIDSignIn.sharedInstance().handle(URLContexts.first?.url)
        }
    }

}

