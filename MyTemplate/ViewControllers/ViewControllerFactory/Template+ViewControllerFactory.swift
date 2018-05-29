//
//  Template+ViewControllerFactory.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation
import RxSwift

extension TemplateApp: ViewControllerFactory {
    func makeCountObservable() -> Observable<Int> {
        return self.store
            .createObservable({ $0.counterState?.count })
            .unwrap()
    }

    func makeViewController() -> ViewController {
        let countObservable = self.makeCountObservable()
        let viewControllerRouteProps = ViewControllerRouteProps(
            countObservable: countObservable,
            doubleCounterViewControllerFactory: self
        )
        let v = ViewController(routeProps: viewControllerRouteProps)
        return v
    }
}

extension TemplateApp: DoubleCounterViewControllerFactory {
    func makeDoubleCounterViewController() -> DoubleCounterViewController {
        let doubleCounterViewControllerRouteProps = DoubleCounterViewControllerRouteProps(
            message: "messsage",
            count0: self.store.state.counterState?.count ?? 0,
            count1: self.store.state.counterState?.count ?? 0
        )
        let doubleCounterViewController = DoubleCounterViewController(routeProps: doubleCounterViewControllerRouteProps)
        return doubleCounterViewController
    }
}
