//
//  UIStackView+extension.swift
//  CryptoStatistics
//
//  
//

import UIKit

extension UIStackView {
    
    func addArrangesSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
