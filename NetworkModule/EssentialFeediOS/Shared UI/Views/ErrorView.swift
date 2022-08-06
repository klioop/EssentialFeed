//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by klioop on 2022/04/06.
//

import UIKit

public final class ErrorView: UIView {
    public lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    public var message: String? {
        get { return isVisible ? button.title(for: .normal) : nil }
        set { setMessageAnimated(newValue) }
    }

    public var onHide: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure() {
        backgroundColor = .clear
        
        configureButton()
        hideMessage()
    }
    
    private func configureButton() {
        addSubview(button)
        button.backgroundColor = .errorBackgroundColor
        configureLabel()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: button.trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: button.bottomAnchor),
        ])
        
        button.addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)
    }

    private func configureLabel() {
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        button.setTitle(message, for: .normal)

        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.hideMessage() }
            })
    }

    private func hideMessage() {
        button.setTitle(nil, for: .normal)
        alpha = 0
        
        button.contentEdgeInsets = .init(top: -10.5, left: 0, bottom: -10.5, right: 0)
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.99951404330000004, green: 0.41759261489999999, blue: 0.4154433012, alpha: 1)
    }
}
