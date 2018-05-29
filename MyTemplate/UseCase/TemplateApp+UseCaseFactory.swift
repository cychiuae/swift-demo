//
//  TemplateApp+UseCaseFactory.swift
//  MyTemplate
//
//  Created by yinyinchiu on 29/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import Foundation

extension TemplateApp: IncrementCountUseCaseFactory {
    func makeIncrementCountUseCase() -> UseCase {
        return IncrementCountUseCase(reduxStore: self.store)
    }
}

extension TemplateApp: DecrementCountUseCaseFactory {
    func makeDecrementCountUseCase() -> UseCase {
        return DecrementCountUseCase(reduxStore: self.store)
    }
}
