//
//  UIView+extension.swift
//  CryptoStatistics
//
//  
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
}
