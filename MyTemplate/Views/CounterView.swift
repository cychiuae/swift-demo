//
//  CounterView.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct CounterViewProps: Equatable {
    let count: Int
}

class CounterViewReactor: StatelessReactor {
    typealias Props = CounterViewProps
    let defaultProps = CounterViewProps(count: 0)
}

class CounterView: UILabel, StatelessComponent {
    typealias Reactor = CounterViewReactor
    let reactor = Reactor()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.reactor.props.asObservable()
            .distinctUntilChanged()
            .map({ "Count: \($0.count)"})
            .bind(to: self.rx.text)
            .disposed(by: self.disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
