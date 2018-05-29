//
//  Computer.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import RxSwift

protocol Computer {
    func computeVeryComplicatedValue(input: Int) -> Observable<Int>
}

class ComplicatedOperation: Operation {
    override func main() {
        Thread.sleep(forTimeInterval: 5)
    }
}

class FakeComputer: Computer {
    var queue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Other queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    func computeVeryComplicatedValue(input: Int) -> Observable<Int> {
        return Observable.create { observer in
            let work = ComplicatedOperation()
            work.completionBlock = {
                observer.onNext(10)
                observer.onCompleted()
            }
            self.queue.addOperation(work)
            return Disposables.create()
        }
    }
}
