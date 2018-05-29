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
    func start()
}

protocol Cancelable {
    func cancel()
}

typealias CancelableUseCase = Cancelable & UseCase

class TodoUseCase: UseCase {
    let todoAction: String

    init(todoAction: String) {
        self.todoAction = todoAction
    }

    func start() {
        print("TODO: \(self.todoAction)")
    }
}
