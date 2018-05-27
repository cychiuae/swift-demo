//
//  Style.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit

struct Style<View: UIView> {
    let style: (View) -> Void

    public func apply(to view: View) {
        style(view)
    }

    public func compose(_ styles: Style<View>...) -> Style<View> {
        return Style { view in
            for style in styles {
                style.apply(to: view)
            }
        }
    }
}

extension UIView {
    func apply<View: UIView>(_ style: Style<View>) {
        style.apply(to: (self as! View))
    }
}
