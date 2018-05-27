//
//  Reactor.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//
import RxCocoa

private var stateKey = "state"
private var propsKey = "props"

protocol StatelessReactor: class, AssociatedObject {
    associatedtype Props

    var defaultProps: Props { get }
    var currentProps: Props { get }
    var props: BehaviorRelay<Props> { get }
}

extension StatelessReactor {
    var props: BehaviorRelay<Props> {
        get {
            return self.associatedObject(forKey: &propsKey,
                                         initialValue: BehaviorRelay<Props>(value: self.defaultProps))
        }
    }
    var currentProps: Props {
        get {
            return self.props.value
        }
    }
}

protocol StatefulReactor: StatelessReactor {
    associatedtype State

    var initialState: State { get }
    var currentState: State { get }
    var state: BehaviorRelay<State> { get }
}

extension StatefulReactor {
    var state: BehaviorRelay<State> {
        get {
            return self.associatedObject(forKey: &stateKey,
                                         initialValue: BehaviorRelay<State>(value: self.initialState))
        }
    }
    var currentState: State {
        get {
            return self.state.value
        }
    }

    func setState(_ updater: ((State, Props) -> State)) {
        self.state.accept(updater(self.currentState, self.currentProps))
    }
}

protocol StatelessComponent where Self: UIView {
    associatedtype Reactor: StatelessReactor
    var reactor: Reactor { get }
}

protocol StatefulComponent where Self: UIViewController {
    associatedtype Reactor: StatefulReactor
    var reactor: Reactor { get }
}
