//
//  IPaSUILazyView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/2/13.
//

import SwiftUI

public struct IPaSUILazyView<Content: View>: View {
    let content: () -> Content
    public init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
    public var body: Content {
        content()
    }
}
