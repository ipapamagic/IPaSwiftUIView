//
//  IPaGeometryHelper.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/24.
//

import SwiftUI

public struct IPaGeometryGetInfo: ViewModifier {
    var onInfoUpdate:(_ geometry:GeometryProxy)->()
    public func body(content: Content) -> some View {
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.onInfoUpdate(geometry)
            }
            return Color.clear
        }
    }
}

public struct IPaGeometryGetRect: ViewModifier {
    @Binding var rect: CGRect
    public func body(content: Content) -> some View {
        
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.rect = geometry.frame(in: .global)
            }
            return Color.clear
        }
    }
}
public struct IPaGeometryGetSize: ViewModifier {
    @Binding var size: CGSize
    public func body(content: Content) -> some View {
        
        return GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.size = geometry.frame(in: .global).size
            }
            return Color.clear
        }
    }
}
