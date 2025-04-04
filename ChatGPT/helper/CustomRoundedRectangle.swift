//
//  CustomRoundedRectangle.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import Foundation
import SwiftUI

struct CustomRoundedRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 20
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY)) // 左下角
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius)) // 左上角开始弧度
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY)) // 右上角开始弧度
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius), control: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 右下角
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // 左下角闭合
        
        return path
    }
}
