//
//  ConnectionIssueButton.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import UIKit

class ConnectionIssueButton: UIButton {
    
    let size: CGFloat = 20
    var onTap: () -> Void
    
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
        
        layer.cornerRadius = size / 2
        backgroundColor = .orange
        blink()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc
    func didTap() {
        onTap()
    }
}
