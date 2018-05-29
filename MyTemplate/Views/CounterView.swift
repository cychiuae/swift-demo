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

class CounterView: UILabel {
    let props: BehaviorRelay<CounterViewProps> = BehaviorRelay(value: CounterViewProps(count: -1))
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.props
            .distinctUntilChanged()
            .map({ "Count: \($0.count)"})
            .bind(to: self.rx.text)
            .disposed(by: self.disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
