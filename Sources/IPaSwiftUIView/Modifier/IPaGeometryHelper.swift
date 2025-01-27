//
//  IPaGeometryHelper.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/24.
//

import SwiftUI

struct IPaGeometryGetInfo: ViewModifier {
    var onInfoUpdate:(_ geometry:GeometryProxy)->()
    public func body(content: Content) -> some View {
        return content.overlay(GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.onInfoUpdate(geometry)
            }
            return Color.clear
        })
    }
}

struct IPaGeometryGetRect: ViewModifier {
    @Binding var rect: CGRect
    public func body(content: Content) -> some View {
        
        return content.overlay(GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.rect = geometry.frame(in: .global)
            }
            return Color.clear
        })
    }
}
struct IPaGeometryGetSize: ViewModifier {
    @Binding var size: CGSize
    public func body(content: Content) -> some View {
        
        return content.overlay(GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.size = geometry.frame(in: .global).size
            }
            return Color.clear
        })
    }
}
extension View {
    public func onUpdate(_ size:Binding<CGSize>) -> some View{
        return self.modifier(IPaGeometryGetSize(size: size))
    }
    public func onGeometryUpdate(_ callback:@escaping (GeometryProxy) -> ()) -> some View{
        return self.modifier(IPaGeometryGetInfo(onInfoUpdate: callback))
    }
    public func onUpdate(_ rect:Binding<CGRect>) -> some View {
        return self.modifier(IPaGeometryGetRect(rect:rect))
    }
}
