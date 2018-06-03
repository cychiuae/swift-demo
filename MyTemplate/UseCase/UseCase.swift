//
//  UseCase.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import RxSwift

protocol UseCase {
    associatedtype T
    func start() -> Observable<T>
}

class AnyUseCase<T>: UseCase {
    private let start_: (() -> Observable<T>)

    init<U: UseCase>(_ useCase: U) where U.T == T {
        self.start_ = useCase.start
    }

    @discardableResult
    func start() -> Observable<T> {
        return self.start_()
    }
}

protocol Cancelable {
    func cancel()
}

typealias CancelableUseCase = Cancelable & UseCase

class TodoUseCase: UseCase {
    typealias T = String
    let todoAction: String

    init(todoAction: String) {
        self.todoAction = todoAction
    }

    func start() -> Observable<String> {
        print("TODO: \(self.todoAction)")
        return Observable.just("TODO")
    }
}
