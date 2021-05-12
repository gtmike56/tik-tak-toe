//
//  BoardCell.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-09.
//

import SwiftUI

struct BoardCell: View {
    
    var geometryProxy: GeometryProxy
    var index: Int?
    var circleColor: Int
    
    
    var body: some View {
        Circle()
            .foregroundColor(getColor(circleColor: circleColor))
            .opacity(0.5)
            .frame(width: geometryProxy.size.width/3-15, height: geometryProxy.size.width/3-15)
    }
    
    func getColor(circleColor: Int) -> Color {
        switch(circleColor) {
        case 0: return .red
        case 1: return .orange
        case 2: return .yellow
        case 3: return .green
        case 4: return .blue
        case 5: return .gray
        case 6: return .pink
        case 7: return .purple
        default: return .red
        }
    }
}
