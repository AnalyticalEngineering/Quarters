//
//  TabShape.swift
//  Quarters
//
//  Created by J. DeWeese on 1/22/24.
//

import SwiftUI

/// Custom Tab Shape
struct TabShape: Shape {
    var midpoint: CGFloat
    
    /// Adding Shape Animation
    var animatableData: CGFloat {
        get { midpoint }
        set {
            midpoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            /// First Drawing the Rectangle Shape
            path.addPath(Rectangle().path(in: rect))
            /// Now Drawing Upward Curve Shape
            path.move(to: .init(x: midpoint - 100, y: 0))
            
            let to = CGPoint(x: midpoint, y: -1)
            let control1 = CGPoint(x: midpoint - 1, y: 0)
            let control2 = CGPoint(x: midpoint - 1, y: -1)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midpoint + 100, y: 0)
            let control3 = CGPoint(x: midpoint + 0, y: -1)
            let control4 = CGPoint(x: midpoint + 0, y: 0)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}

