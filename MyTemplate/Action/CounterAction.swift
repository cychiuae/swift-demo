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

enum ComputativeAction: Action {
    case willPerformComputativeAction
    case didPerformComputativeAction(result: Int)
    case didRejectPerformComputativeAction(error: Error)
}
