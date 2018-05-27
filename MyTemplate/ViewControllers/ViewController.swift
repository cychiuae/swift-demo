//
//  ViewController.swift
//  MyTemplate
//
//  Created by YinYin Chiu on 28/5/2018.
//  Copyright © 2018 YinYin Chiu. All rights reserved.
//

import UIKit

fileprivate enum styles {
    static let container = Style<UIView> {
        $0.backgroundColor = UIColor.white
    }
}

class ViewController: UIViewController {
    override func loadView() {
        self.view = UIView()
        self.view.apply(styles.container)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
