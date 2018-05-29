//
//  CountState.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import ReSwift

struct CounterState: Equatable {
    var count: Int = 0
}

func counterStateReducer(state: CounterState?, action: Action) -> CounterState {
    var newState = state ?? CounterState()
    switch (action) {
    case CounterAction.Increment(let amount):
        newState.count = newState.count + amount
    case CounterAction.Decrement(let amount):
        newState.count = newState.count - amount
    case ComputativeAction.didPerformComputativeAction(let result):
        newState.count = newState.count + result
    default:
        break
    }
    return newState
}
