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

protocol ComputativeUseCaseFactory: class {
    func makeComputativeUseCase() -> UseCase
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

class ComputativeUseCase: UseCase {
    let reduxStore: Store<RootState>
    let computer: Computer

    init(reduxStore: Store<RootState>, computer: Computer) {
        self.reduxStore = reduxStore
        self.computer = computer
    }

    func start() {
        self.reduxStore.dispatch(ComputativeAction.willPerformComputativeAction)
        _ = self.computer.computeVeryComplicatedValue(input: self.reduxStore.state.counterState?.count ?? 0)
            .subscribe(
                onNext: { i in
                    self.reduxStore.dispatch(ComputativeAction.didPerformComputativeAction(result: i))
                },
                onError: { error in
                    self.reduxStore.dispatch(ComputativeAction.didRejectPerformComputativeAction(error: error))
            })
    }
}
