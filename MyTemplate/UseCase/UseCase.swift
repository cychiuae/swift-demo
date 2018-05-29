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
    associatedtype ReturnType
    func start() -> Observable<ReturnType>
}

protocol Cancelable {
    func cancel()
}

typealias CancelableUseCase = Cancelable & UseCase

class TodoUseCase: UseCase {
    typealias ReturnType = String
    let todoAction: String

    init(todoAction: String) {
        self.todoAction = todoAction
    }

    func start() -> Observable<String> {
        print("TODO: \(self.todoAction)")
        return Observable.just(self.todoAction)
    }
}
