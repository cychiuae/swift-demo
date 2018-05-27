//
//  ViewController.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt
import SnapKit

fileprivate enum styles {
    static let container = Style<UIView> {
        $0.backgroundColor = UIColor.white
    }
    static let incrementButton = Style<UIButton> {
        $0.backgroundColor = UIColor.yellow
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    static let decrementButton = Style<UIButton> {
        $0.backgroundColor = UIColor.green
    }
    static let nextScreenButton = Style<UIButton> {
        $0.setTitleColor(UIColor.black, for: .normal)
    }
}

protocol ViewControllerActionDelegate: class {
    func didPressIncrementButton()
    func didPressDecrementButton()
    func didPressIncrement2Button()
}

struct ViewControllerState: Equatable {
    let count: Int
}

class ViewControllerReactor: StatefulReactor {
    typealias State = ViewControllerState
    typealias Props = Void
    let defaultProps: Void = ()
    var initialState = ViewControllerState(count: 0)

    let app: App

    init(app: App) {
        self.app = app
    }
}

extension ViewControllerReactor: ViewControllerActionDelegate {
    func didPressIncrementButton() {
        CounterActionCreator.increment(by: 1, app: self.app)
    }

    func didPressDecrementButton() {
        CounterActionCreator.decrement(by: 1, app: self.app)
    }

    func didPressIncrement2Button() {
        self.setState { (state, _) -> ViewControllerState in
            return ViewControllerState(count: (state.count + 1) * 2)
        }
    }
}

class ViewController: UIViewController, StatefulComponent {
    typealias Reactor = ViewControllerReactor
    lazy var reactor: Reactor = {
        let reactor = Reactor(app: self.app)
        self.actionDelegate = reactor
        return reactor
    }()
    private weak var actionDelegate: ViewControllerActionDelegate?
    private var disposeBag = DisposeBag()

    private let counterView = CounterView()
    private let incrementButton: UIButton = {
        let button = UIButton()
        button.apply(styles.incrementButton)
        button.setTitle("Increment", for: .normal)
        return button
    }()
    private let decrementButton: UIButton = {
        let button = UIButton()
        button.apply(styles.decrementButton)
        button.setTitle("Decrement", for: .normal)
        return button
    }()
    private let incrementButton2: UIButton = {
        let button = UIButton()
        button.apply(styles.incrementButton)
        button.setTitle("Increment 2", for: .normal)
        return button
    }()
    private let nextScreenButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.apply(styles.nextScreenButton)
        return button
    }()

    override func loadView() {
        self.view = UIView()
        self.view.apply(styles.container)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.counterView)
        self.view.addSubview(self.incrementButton)
        self.view.addSubview(self.decrementButton)
        self.view.addSubview(self.incrementButton2)
        self.view.addSubview(self.nextScreenButton)

        self.counterView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.incrementButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(self.decrementButton)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(self.decrementButton.snp.left)
        }
        self.decrementButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(self.incrementButton)
            make.right.bottom.equalToSuperview()
        }
        self.incrementButton2.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.incrementButton.snp.top)
        }
        self.nextScreenButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
        let counterStateObservable = self.app.store
            .createObservable { $0.counterState }
            .unwrap()
        Observable.combineLatest(self.reactor.state, counterStateObservable, resultSelector: {$0.count + $1.count})
            .observeOn(scheduler)
            .unwrap()
            .map { CounterViewProps(count: $0) }
            .bind(to: self.counterView.reactor.props)
            .disposed(by: self.disposeBag)

        self.incrementButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.actionDelegate?.didPressIncrementButton()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.decrementButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.actionDelegate?.didPressDecrementButton()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.incrementButton2.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.actionDelegate?.didPressIncrement2Button()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.nextScreenButton.rx.tap
            .asObservable()
            .withLatestFrom(
                Observable.combineLatest(
                    self.reactor.state,
                    counterStateObservable,
                    resultSelector: {
                        DoubleCounterViewControllerRouteProps(
                            message: "From ViewController",
                            count0: $0.count,
                            count1: $1.count
                        )
                    }
                )
            )
            .do(onNext: { [weak self] routeProps in
                guard let strongSelf = self else {
                    return
                }
                let doubleCounterViewController = DoubleCounterViewController(routeProps: routeProps)
                strongSelf.navigationController?.pushViewController(doubleCounterViewController,
                                                                    animated: true)
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
}
