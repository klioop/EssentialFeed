//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/04/06.
//

import UIKit

public final class ErrorView: UIView {
    private(set) public lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(hideMessage), for: .touchUpInside)
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
        addSubview(button)
        alpha = 0
    }
    
    public var message: String? {
        isVisible ? button.title(for: .normal) : nil
    }
    
    var isVisible: Bool {
        alpha > 0
    }
    
    func show(message: String) {
        button.setTitle(message, for: .normal)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc func hideMessage() {
        UIView.animate(withDuration: 0.25,
                       animations: { self.alpha = 0 } ,
                       completion: { completed in
            if completed {
                self.button.setTitle(nil, for: .normal)
            }
        })
    }
}
