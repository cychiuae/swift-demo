//
//  ViewController.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit
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
}

struct ViewControllerState: Equatable {
    let count: Int
}

class ViewControllerReactor: StatefulReactor {
    typealias State = ViewControllerState
    typealias Props = Void
    let defaultProps: Void = ()
    var initialState = ViewControllerState(count: 0)
}

class ViewController: UIViewController, StatefulComponent {
    typealias Reactor = ViewControllerReactor
    let reactor = Reactor()

    let counterView = CounterView()
    let incrementButton: UIButton = {
        let button = UIButton()
        button.apply(styles.incrementButton)
        button.setTitle("Increment", for: .normal)
        return button
    }()
    let decrementButton: UIButton = {
        let button = UIButton()
        button.apply(styles.decrementButton)
        button.setTitle("Decrement", for: .normal)
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
    }
}
