//
//  IPaInfinityGridView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/23.
//

import SwiftUI

/// Contains the gap between the smallest value for the y-coordinate of
/// the frame layer and the content layer.
public enum IPaSUIInfinityScrollViewDirection {
    case horizontal
    case vertical
}
open class IPaSUIInfinityScrollViewCoordinator: NSObject, UIScrollViewDelegate {
    open var contentSize:CGSize = .zero
    var pageScale:Int = 0
    var axis:IPaSUIInfinityScrollViewDirection = .horizontal
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.onDragComplete(scrollView)
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.onDragComplete(scrollView)
    }
    open func onDragComplete(_ scrollView:UIScrollView) {
        self.moveToCenter(scrollView)
    }
    func centerPosition(_ point:CGPoint) -> CGPoint {
        var finalPoint = point
        if self.axis == .horizontal {
            var realOffsetX = point.x.remainder(dividingBy: contentSize.width)
            realOffsetX = realOffsetX < 0 ? (realOffsetX + (contentSize.width)) : realOffsetX
            let targetPage = CGFloat(Int(Double(pageScale) * 0.5))
            finalPoint.x = targetPage * contentSize.width + realOffsetX
            
          
        }
        else {
            var realOffsetY = point.y.remainder(dividingBy: contentSize.height)
            realOffsetY = realOffsetY < 0 ? (realOffsetY + contentSize.height) : realOffsetY
            let targetPage = CGFloat(Int(Double(pageScale) * 0.5))
            finalPoint.y = targetPage * contentSize.height + realOffsetY
        }
        return finalPoint
    }
    func moveToCenter(_ scrollView:UIScrollView) {
        let offset = scrollView.contentOffset
        let finalPoint = self.centerPosition(offset)
        scrollView.setContentOffset(finalPoint, animated: false)
        
    }
}


public struct IPaInfinityScrollView<Content: View>: View,IPaSUIScrollViewChangeObserver {
    
    let content: () -> Content
    var coordinator:IPaSUIInfinityScrollViewCoordinator
    public var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    public init(_ axis:IPaSUIInfinityScrollViewDirection = .horizontal,contentOffset:CGPoint = .zero,contentSize:CGSize,contentInset:UIEdgeInsets = .zero,pageScale:Int = 10,coordinator:IPaSUIInfinityScrollViewCoordinator = IPaSUIInfinityScrollViewCoordinator() ,@ViewBuilder content: @escaping () -> Content) {
        self.scrollView.contentInset = contentInset
        var offsetX = contentOffset.x
        while offsetX > contentSize.width {
            offsetX -= contentSize.width
        }
        while offsetX < 0 {
            offsetX += contentSize.width
        }
        self.scrollView.contentSize = contentSize
        self.scrollView.contentOffset = CGPoint(x: offsetX, y: contentOffset.y)
        self.content = content
        self.coordinator = coordinator
        self.coordinator.contentSize = contentSize
        self.coordinator.axis = axis
        self.coordinator.pageScale = pageScale
        self.scrollView.delegate = self.coordinator
    }
    
    public var body: some View {
        
        IPaSUIScrollView(self.scrollView) {
            IPaSUIStackView(direction:self.coordinator.axis == .horizontal ? .horizontal : .vertical, spacing:0) {
                ForEach(0..<self.coordinator.pageScale,id:\.self) {index in
                    
                    content().frame(width: self.coordinator.contentSize.width, height: self.coordinator.contentSize.height)
                    
                }
            }
        }.onAppear(perform: {
            self.coordinator.onDragComplete(self.scrollView)
        })
    
        
    }
    
}
