//
//  AppDelegate.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let app: App = {
        let app = TemplateApp(store: createStore())
        return app
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

