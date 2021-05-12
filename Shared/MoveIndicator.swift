//
//  MoveIndicator.swift
//  Tic-Tak-Toe
//
//  Created by Mikhail Udotov on 2021-05-09.
//

import SwiftUI

struct MoveIndicator: View {
    
    var imageSystemString: String
    
    var geometryProxy: GeometryProxy
    
    var index: Int?
    
    var body: some View {
        Image(systemName: imageSystemString)
            .resizable()
            .frame(width: geometryProxy.size.width/7, height: geometryProxy.size.width/7)
            .foregroundColor(.white)
            .opacity(index == nil ? 0 : 1)
    }
}
