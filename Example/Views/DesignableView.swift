//
//  DesignableView.swift
//  
//
//  Created by Gunter Hager on 15.05.17.
//  Copyright © 2017 all about apps. All rights reserved.
//

import UIKit

@IBDesignable

class DesignableView: UIView {
        
    private var corners = UIRectCorner.allCorners {
        didSet {
            if corners == .allCorners {
                layer.cornerRadius = cornerRadius
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var cornerTopLeft: Bool = true {
        didSet {
            if cornerTopLeft {
                corners.insert(.topLeft)
            } else {
                corners.remove(.topLeft)
            }
        }
    }
    
    @IBInspectable var cornerTopRight: Bool = true {
        didSet {
            if cornerTopRight {
                corners.insert(.topRight)
            } else {
                corners.remove(.topRight)
            }
        }
    }
    
    @IBInspectable var cornerBottomLeft: Bool = true {
        didSet {
            if cornerBottomLeft {
                corners.insert(.bottomLeft)
            } else {
                corners.remove(.bottomLeft)
            }
        }
    }
    
    @IBInspectable var cornerBottomRight: Bool = true {
        didSet {
            if cornerBottomRight {
                corners.insert(.bottomRight)
            } else {
                corners.remove(.bottomRight)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            if corners == .allCorners {
                layer.cornerRadius = cornerRadius
            } else {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var hairlineBorderWidth: Bool = false {
        didSet {
            layer.borderWidth = hairlineBorderWidth ? 0.5 : borderWidth
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }

    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var pattern: UIImage? = nil {
        didSet {
            if let pattern = pattern {
                backgroundColor = UIColor(patternImage: pattern)
            } else {
                backgroundColor = nil
            }
        }
    }
        
    private func createRoundedCorners(corners: UIRectCorner, radius: CGFloat = 8.0) {
        layer.cornerRadius = 0
        
        // Mask layer
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = layer.bounds
        
        let path = UIBezierPath(
            roundedRect: layer.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        
        // Shadow
//        let shadowPath = UIBezierPath(
//            roundedRect: layer.bounds,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        layer.shadowPath = shadowPath.cgPath
//
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard corners != .allCorners else { return }
        createRoundedCorners(corners: corners, radius: cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layoutSubviews")
        setNeedsDisplay()
    }

}
