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

class IncrementCountUseCase: UseCase {
    typealias ReturnType = Void
    let reduxStore: Store<RootState>

    init(reduxStore: Store<RootState>) {
        self.reduxStore = reduxStore
    }

    func start() -> Observable<Void> {
        self.reduxStore.dispatch(CounterAction.Increment(amount: 1))
        return Observable.just(())
    }
}
