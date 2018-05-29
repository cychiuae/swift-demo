//
//  CountUseCase.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation

import ReSwift
import RxSwift

protocol IncrementCountUseCaseFactory: class {
    func makeIncrementCountUseCase() -> UseCase
}

protocol DecrementCountUseCaseFactory: class {
    func makeDecrementCountUseCase() -> UseCase
}

class IncrementCountUseCase: UseCase {
    let reduxStore: Store<RootState>

    init(reduxStore: Store<RootState>) {
        self.reduxStore = reduxStore
    }

    func start() {
        self.reduxStore.dispatch(CounterAction.Increment(amount: 1))
    }
}

class DecrementCountUseCase: UseCase {
    let reduxStore: Store<RootState>

    init(reduxStore: Store<RootState>) {
        self.reduxStore = reduxStore
    }

    func start() {
        self.reduxStore.dispatch(CounterAction.Decrement(amount: 1))
    }
}
