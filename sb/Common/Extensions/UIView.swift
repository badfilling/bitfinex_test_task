//
//  UIView.swift
//  sb
//
//  Created by Artur Stepaniuk on 23/06/2022.
//

import UIKit

extension UIView {
     func blink() {
         self.alpha = 0.4
         UIView.animate(
            withDuration: 1,
            delay: 0.0,
            options: [
                .curveLinear, .repeat, .autoreverse, .allowUserInteraction
            ],
            animations: { self.alpha = 1.0 },
            completion: nil
         )
     }
}
