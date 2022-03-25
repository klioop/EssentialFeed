//
//  UITableView+register.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/22.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}
