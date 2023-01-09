//
//  IPaSUIFullscreenModifier.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/4/30.
//

import SwiftUI


extension View {
    public func showFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(IPaSUIFullScreenModifier(isPresented: isPresented, builder: content))
    }
}

struct IPaSUIFullScreenModifier<V: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let builder: () -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.fullScreenCover(isPresented: isPresented, content: builder)
        } else {
            content.sheet(isPresented: isPresented, content: builder)
        }
    }
}
