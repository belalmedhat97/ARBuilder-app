//
//  LoadingAnimator.swift
//  ARBUILDER
//
//  Created by belal medhat on 08/02/2023.
//

import SwiftUI
struct LeftToRightFillShape: Shape {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { return progress }
        set { self.progress = newValue}
    }
    func path(in rect: CGRect) -> Path {
        return leftToRight(rect: rect)
    }
    func leftToRight(rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0)) // Top Left
        path.addLine(to: CGPoint(x: rect.width * progress, y: 0)) // Top Right
        path.addLine(to: CGPoint(x: rect.width * progress, y: rect.height)) // Bottom Right
        path.addLine(to: CGPoint(x: 0, y: rect.height)) // Bottom Left
        path.closeSubpath() // Close the Path
        return path
    }
}
