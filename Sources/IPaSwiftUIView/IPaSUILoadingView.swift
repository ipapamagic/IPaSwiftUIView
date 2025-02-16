//
//  IPaSUILoadingView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/1/16.
//

import SwiftUI

public struct IPaSUILoadingView<Content:View>: View {
    @Binding public var isShowing: Bool
    let content: () -> Content
    let bgColor:Color
    let paddingValue:CGFloat
    let cornerRadiusValue:CGFloat
    let labelText:String?
    let labelTextColor:Color
    public var body: some View {
        if self.isShowing {
            ZStack(alignment: .center) {
                
                self.content().blur(radius: 3).disabled(true).overlay(
                    ZStack{
                        VStack {
                            IPaSUIActivityIndicatorView()
                            if let labelText = self.labelText,labelText.count > 0 {
                                Text(labelText).foregroundColor(self.labelTextColor)
                            }
                        }
                    }.padding(self.paddingValue).background(self.bgColor)
                        .cornerRadius(self.cornerRadiusValue).shadow(radius: 3)
                        .opacity( 0.8).animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                )
            }
            
        }
        else {
            self.content()
        }
    }
    public init(isShowing:Binding<Bool>,labelText:String? = nil,labelTextColor:Color = .black,bgColor:Color = .white,padding:CGFloat = 40,cornerRadius:CGFloat = 20,content:@escaping () -> Content) {
        self._isShowing = isShowing
        self.content = content
        self.labelText = labelText
        self.labelTextColor = labelTextColor
        self.bgColor = bgColor
        self.paddingValue = padding
        self.cornerRadiusValue = cornerRadius
    }
}


