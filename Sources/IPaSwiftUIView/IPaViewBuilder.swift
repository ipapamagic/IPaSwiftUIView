//
//  IPaViewBuilder.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/10/31.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    @ViewBuilder
    public func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    @ViewBuilder
    public func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
    @available(
      iOS, introduced: 13, deprecated: 14,
      message: "Use .ignoresSafeArea(.keyboard) directly"
    ) 
    @ViewBuilder
    public func ignoreKeyboard() -> some View {
        if #available(iOS 14.0, *) {
            ignoresSafeArea(.keyboard)
        } else {
            self // iOS 13 always ignores the keyboard
        }
    }
}

