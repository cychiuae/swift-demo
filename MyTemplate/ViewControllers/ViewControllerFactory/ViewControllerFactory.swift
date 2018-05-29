//
//  ViewControllerFactory.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerFactory {
    func makeViewController() -> ViewController
}

protocol DoubleCounterViewControllerFactory {
    func makeDoubleCounterViewController() -> DoubleCounterViewController
}
