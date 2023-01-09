//
//  IPaSUIStackView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/30.
//

import SwiftUI

public struct IPaSUIStackView<Content: View>: View  {
    public enum Direction {
        case horizontal
        case vertical
    }
    let direction:Direction
    let spacing: CGFloat?
    let content: () -> Content

    public init(direction:Direction = .horizontal,spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.direction = direction
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        Group {
            if self.direction == .vertical {
                VStack(spacing: spacing, content: content)
            } else {
                HStack(spacing: spacing, content: content)
            }
        }
    }
}

struct IPaStackView_Previews: PreviewProvider {
    static var previews: some View {
        IPaSUIStackView( content: {
            Text("test")
            Text("test")
        })
    }
}
