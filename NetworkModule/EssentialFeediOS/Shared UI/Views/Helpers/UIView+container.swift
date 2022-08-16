//
//  UIView+container.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/08/16.
//

import UIKit

extension UIView {
    func containerView() -> UIView {
        let container = UIView()
        container.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return container
    }
}
