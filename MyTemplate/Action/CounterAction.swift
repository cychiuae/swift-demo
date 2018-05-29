//
//  CounterAction.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import ReSwift

enum CounterAction: Action {
    case Increment(amount: Int)
    case Decrement(amount: Int)
}

protocol CounterActionCreatorI: class {
  static func increment(by amount: Int, app: App)
  static func decrement(by amount: Int, app: App)
}

class CounterActionCreator: CounterActionCreatorI {
    static func increment(by amount: Int, app: App) {
        app.store.dispatch(CounterAction.Increment(amount: amount))
    }

    static func decrement(by amount: Int, app: App) {
        app.store.dispatch(CounterAction.Decrement(amount: amount))
    }
}
