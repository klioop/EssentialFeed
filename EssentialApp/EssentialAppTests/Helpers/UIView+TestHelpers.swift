//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by klioop on 2022/07/06.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
