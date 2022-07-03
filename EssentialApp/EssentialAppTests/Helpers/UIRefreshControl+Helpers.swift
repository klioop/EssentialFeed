//
//  UIKIt+Helpers.swift
//  EssentialFeediOSTests
//
//  Created by klioop on 2022/03/21.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

