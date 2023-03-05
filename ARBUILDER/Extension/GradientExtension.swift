//
//  GradientExtension.swift
//  ARBUILDER
//
//  Created by belal medhat on 04/02/2023.
//

import SwiftUI
extension LinearGradient {
    static var gradientColor: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom)
    }
}
