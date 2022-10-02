//
//  RoundedShap.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import Foundation
import SwiftUI
struct RoundedShap: Shape {
    var corner: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: 80, height: 80))
        return Path(path.cgPath)
    }
}
