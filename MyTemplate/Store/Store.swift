//
//  Store.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import ReSwift

struct RootState: StateType, Equatable {
    var counterState: CounterState?
}

func rootStateReducer(action: Action, state: RootState?) -> RootState {
    return RootState(
        counterState: counterStateReducer(state: state?.counterState, action: action)
    )
}

typealias ReduxStore = Store<RootState>

func createStore() -> ReduxStore {
    return Store(reducer: rootStateReducer, state: nil)
}
