//
//  TemplateApp+UseCaseFactory.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation

extension TemplateApp: IncrementCountUseCaseFactory {
    func makeIncrementCountUseCase() -> AnyUseCase<Int> {
        return AnyUseCase(IncrementCountUseCase(reduxStore: self.store))
    }
}

extension TemplateApp: DecrementCountUseCaseFactory {
    func makeDecrementCountUseCase() -> AnyUseCase<Int> {
        return AnyUseCase(DecrementCountUseCase(reduxStore: self.store))
    }
}

extension TemplateApp: ComputativeUseCaseFactory {
    func makeComputativeUseCase() -> AnyUseCase<Int> {
        return AnyUseCase(ComputativeUseCase(reduxStore: self.store, computer: FakeComputer()))
    }
}
