//
//  UIViewController+App.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit

extension UIViewController {
    var app: App {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.app
    }
}
