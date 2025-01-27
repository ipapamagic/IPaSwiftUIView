//
//  IPaScrollView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/12/24.
//

import SwiftUI

public protocol IPaScrollViewChangeObserver:View {
    var scrollView:UIScrollView {get}
    func onScrollViewChange<Type:Equatable>(_ keyPath:KeyPath<UIScrollView,Type>,action: @escaping (UIScrollView,Type)->Void) -> IPaScrollViewParameterObserver<Self,Type>
}
extension IPaScrollViewChangeObserver {
    
    public func onScrollViewChange<Type:Equatable>(_ keyPath:KeyPath<UIScrollView,Type>,action: @escaping (UIScrollView,Type)->Void) -> IPaScrollViewParameterObserver<Self,Type> {
        IPaScrollViewParameterObserver(self, scrollView: self.scrollView,keyPath:keyPath, action: action)
    }
}
public struct IPaScrollViewParameterObserver<Base:View,Value:Equatable>: View,IPaScrollViewChangeObserver {
    public var scrollView: UIScrollView {
        return self.model.targetScrollView
    }
    
    let base: Base
    let model:Model
    
    public var body: some View {
        return base
    }
    init(_ base:Base,scrollView:UIScrollView,keyPath:KeyPath<UIScrollView, Value>,action:@escaping (UIScrollView,Value)->Void) {
        self.base = base
        self.model = Model(scrollView,keyPath: keyPath, action: action)
    }
    public func onScrollViewChange<Type:Equatable>(_ keyPath:KeyPath<UIScrollView,Type>,action: @escaping (UIScrollView,Type)->Void) -> IPaScrollViewParameterObserver<Base,Type> {
        IPaScrollViewParameterObserver<Base,Type>(self.base, scrollView: self.scrollView,keyPath:keyPath, action: action)
    }
    class Model {
        let targetScrollView:UIScrollView
        var observer:NSKeyValueObservation?
        let keyPath:KeyPath<UIScrollView, Value>
        let action: (UIScrollView,Value)->Void
        init(_ scrollView:UIScrollView,keyPath:KeyPath<UIScrollView, Value>,action:@escaping (UIScrollView,Value)->Void) {
            self.targetScrollView = scrollView
            self.action = action
            self.keyPath = keyPath
            self.observer = scrollView.observe(keyPath) { (scrollView, value) in
                DispatchQueue.main.async {
                    self.action(scrollView,scrollView[keyPath: keyPath])
                }
                
            }
        }
        deinit {
            self.observer?.invalidate()
        }
        
    }
    
}
public struct IPaScrollView<Content: View>: UIViewControllerRepresentable, Equatable,IPaScrollViewChangeObserver {
    
    public static func == (lhs: IPaScrollView<Content>, rhs: IPaScrollView<Content>) -> Bool {
        return lhs.scrollViewController == rhs.scrollViewController
    }
    
    public typealias UIViewControllerType = IPaUIScrollViewController<Content>

    var content: () -> Content
    private let scrollViewController: UIViewControllerType
    public var scrollView:UIScrollView {
        return self.scrollViewController.scrollView
    }
    
    public init(_ scrollView:UIScrollView? = nil,@ViewBuilder content: @escaping () -> Content) {
        self.content = content
        let scrollView = scrollView ?? {
            
            let scrollView                                       = UIScrollView()
            
            scrollView.canCancelContentTouches                   = true
            scrollView.delaysContentTouches                      = true
            scrollView.scrollsToTop                              = false
            scrollView.backgroundColor                           = .clear
            
            
            return scrollView
        }()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollViewController = IPaUIScrollViewController(rootView: self.content(),scrollView:scrollView)
    }
    
    // MARK: - Updates
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        self.scrollViewController
    }

    public func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        viewController.updateContent(self.content)
    }
    
}

public final class IPaUIScrollViewController<Content: View> : UIViewController, ObservableObject {
    var scrollView:UIScrollView
    // MARK: - Properties
    let hostingController: UIHostingController<Content>
   
    
    // MARK: - Init
    init(rootView: Content,scrollView:UIScrollView) {
        self.scrollView = scrollView
        self.hostingController                      = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear

        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Update
    func updateContent(_ content: () -> Content) {
        
        self.hostingController.rootView = content()
        if let contentView = self.scrollView.subviews.first {
            if contentView == self.hostingController.view {
                return
            }
            else {
                contentView.removeFromSuperview()
                contentView.removeConstraints(contentView.constraints)
            }
            
        }
        
        self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(self.hostingController.view)
        
        
//        let contentSize: CGSize = self.hostingController.view.intrinsicContentSize
        
//        self.hostingController.view.frame.size = contentSize
//        self.scrollView.contentSize            = contentSize
        
        self.hostingController.view.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.hostingController.view.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.hostingController.view.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.hostingController.view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        self.view.layoutIfNeeded()
    }
}
