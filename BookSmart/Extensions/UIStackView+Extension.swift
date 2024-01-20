//
//  UIStackView+Extension.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 19.01.24.
//

import UIKit

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0, borderColor: UIColor = .clear, borderWidth: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        subView.layer.cornerRadius = radiusSize
        subView.layer.borderColor = borderColor.cgColor
        subView.layer.borderWidth = borderWidth
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}
