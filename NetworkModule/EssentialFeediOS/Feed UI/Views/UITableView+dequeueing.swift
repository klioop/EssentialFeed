//
//  UITableView+dequeueing.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/03/21.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
