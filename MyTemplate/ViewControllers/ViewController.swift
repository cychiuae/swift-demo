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

struct ViewControllerRouteProps {
    let countObservable: Observable<Int>
    let doubleCounterViewControllerFactory: DoubleCounterViewControllerFactory
    let incrementCountUseCaseFactory: IncrementCountUseCaseFactory
    let decrementCountUseCaseFacotry: DecrementCountUseCaseFactory
}

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

class ViewController: UIViewController {
    private let countObservable: Observable<Int>
    private let doubleCounterViewControllerFactory: DoubleCounterViewControllerFactory
    private let incrementCountUseCaseFactory: IncrementCountUseCaseFactory
    private let decrementCountUseCaseFacotry: DecrementCountUseCaseFactory
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

    init(routeProps: ViewControllerRouteProps) {
        self.countObservable = routeProps.countObservable
        self.doubleCounterViewControllerFactory = routeProps.doubleCounterViewControllerFactory
        self.incrementCountUseCaseFactory = routeProps.incrementCountUseCaseFactory
        self.decrementCountUseCaseFacotry = routeProps.decrementCountUseCaseFacotry
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

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
        self.countObservable
            .observeOn(scheduler)
            .map { CounterViewProps(count: $0) }
            .bind(to: self.counterView.props)
            .disposed(by: self.disposeBag)

        self.incrementButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.didPressIncrementButton()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.decrementButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.didPressDecrementButton()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.incrementButton2.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.didPressIncrement2Button()
            })
            .subscribe()
            .disposed(by: self.disposeBag)

        self.nextScreenButton.rx.tap
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.didPressNextScreenButton()
            })
            .subscribe()
            .disposed(by: self.disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.disposeBag = DisposeBag()
    }
}

// MARK: Actions
extension ViewController {
    func didPressIncrementButton() {
        let useCase = self.incrementCountUseCaseFactory.makeIncrementCountUseCase()
        useCase.start()
    }

    func didPressDecrementButton() {
        let useCase = self.decrementCountUseCaseFacotry.makeDecrementCountUseCase()
        useCase.start()
    }

    func didPressIncrement2Button() {
        let useCase = self.incrementCountUseCaseFactory.makeIncrementCountUseCase()
        useCase.start()
    }

    func didPressNextScreenButton() {
        let doubleCounterViewController = self.doubleCounterViewControllerFactory.makeDoubleCounterViewController()
        self.navigationController?.pushViewController(doubleCounterViewController,
                                                      animated: true)
    }
}
