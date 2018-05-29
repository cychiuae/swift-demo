//
//  App.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import UIKit

import RxSwift


protocol App {
    var store: ReduxStore { get }
}

class TemplateApp: App {
    let store: ReduxStore

    init(store: ReduxStore) {
        self.store = store
    }
}
