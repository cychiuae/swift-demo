//
//  Store+Observable.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//
import ReSwift
import RxSwift

class RxStoreSubscriber<StateType>: StoreSubscriber {
    let rxObserver: AnyObserver<StateType>

    init(_ rxObserver: AnyObserver<StateType>) {
        self.rxObserver = rxObserver
    }

    func newState(state: StateType) {
        rxObserver.on(.next(state))
    }
}

extension Store {
    func createObservable<SelectedState>(
        _ selector: @escaping((State) -> SelectedState)
    ) -> Observable<SelectedState> where SelectedState: Equatable {
            return Observable.create(self.createSubscribe(selector)).distinctUntilChanged { lhs, rhs in
                return lhs == rhs
            }
    }

    func createObservable<SelectedState>(
        _ selector: @escaping((State) -> SelectedState?)
    ) -> Observable<SelectedState?> where SelectedState: Equatable {
            return Observable.create(self.createSubscribe(selector)).distinctUntilChanged { lhs, rhs in
                return lhs == rhs
            }
    }

    private func createSubscribe<SelectedState>(
        _ selector: @escaping ((State) -> SelectedState)
    ) -> ((AnyObserver<SelectedState>) -> Disposable) {
            return { [weak self] observer in
                guard let strongSelf = self else {
                    return Disposables.create()
                }
                return strongSelf.subscribe(observer, selector: selector)
            }
    }

    private func subscribe<SelectedState>(
        _ rxObserver: AnyObserver<SelectedState>,
        selector: @escaping ((State) -> SelectedState)
    ) -> RxSwift.Cancelable {
            let subscriber = RxStoreSubscriber<SelectedState>(rxObserver)

            subscribe(subscriber) { (subscription) in
                subscription.select(selector)
            }
            return makeDisposable(subscriber)
    }

    private func makeDisposable(_ subscriber: AnyStoreSubscriber) -> RxSwift.Cancelable {
        return Disposables.create {
            self.unsubscribe(subscriber)
        }
    }
}
