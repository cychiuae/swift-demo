//
//  DoubleCounterViewController.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct DoubleCounterViewControllerRouteProps {
    let message: String
    let count0: Int
    let count1: Int
}

fileprivate enum styles {
    static let container = Style<UIView> {
        $0.backgroundColor = UIColor.white
    }
    static let messageLabel = Style<UILabel> {
        $0.textColor = UIColor.blue
        $0.font = UIFont.systemFont(ofSize: 36)
    }
}

class DoubleCounterViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let routeProps: Observable<DoubleCounterViewControllerRouteProps>

    private let messgaeLabel: UILabel = {
        let label = UILabel()
        label.apply(styles.messageLabel)
        return label
    }()
    private let counterView0 = CounterView()
    private let counterView1 = CounterView()

    init(routeProps: DoubleCounterViewControllerRouteProps) {
        self.routeProps = Observable.just(routeProps)
        super.init(nibName:nil, bundle:nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = UIView()
        self.view.apply(styles.container)
    }

    override func viewDidLoad() {
        self.view.addSubview(self.messgaeLabel)
        self.view.addSubview(self.counterView0)
        self.view.addSubview(self.counterView1)

        self.messgaeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            make.centerX.equalToSuperview()
        }
        self.counterView0.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.centerY)
        }
        self.counterView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.centerY)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.routeProps
            .map { $0.message }
            .bind(to: self.messgaeLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.routeProps
            .map { CounterViewProps(count: $0.count0) }
            .bind(to: self.counterView0.reactor.props)
            .disposed(by: self.disposeBag)

        self.routeProps
            .map { CounterViewProps(count: $0.count1) }
            .bind(to: self.counterView1.reactor.props)
            .disposed(by: self.disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
}
