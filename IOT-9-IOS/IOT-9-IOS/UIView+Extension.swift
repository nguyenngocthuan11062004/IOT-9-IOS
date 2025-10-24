//
//  UIView+Extension.swift
//  IOT-9
//
//  Created by Thuận Nguyễn on 17/10/25.
//

import UIKit

extension UIView{
    func roundCorners(corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: CGFloat) {
        if #available(iOS 11, *) {
            layer.cornerRadius = radius
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            layer.maskedCorners = cornerMask
            layer.masksToBounds = true
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
