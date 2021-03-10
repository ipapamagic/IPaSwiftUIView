//
//  IPaSwiftUIOrientationController.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/2/17.
//

import Foundation


import SwiftUI
struct ShouldAutoRotatePreferenceKey:PreferenceKey {
    typealias Value = Bool
    static var defaultValue: Bool {
        true
    }
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}
struct PreferredInterfaceOrientationPreferenceKey: PreferenceKey {
    typealias Value = UIInterfaceOrientation
    static var defaultValue: UIInterfaceOrientation {
        .portrait
    }
    static func reduce(value: inout UIInterfaceOrientation, nextValue: () -> UIInterfaceOrientation) {
        value = nextValue()
    }
}
struct SupportedOrientationsPreferenceKey: PreferenceKey {
    typealias Value = UIInterfaceOrientationMask
    static var defaultValue: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        else {
            return .allButUpsideDown
        }
    }
    
    static func reduce(value: inout UIInterfaceOrientationMask, nextValue: () -> UIInterfaceOrientationMask) {
        // use the most restrictive set from the stack
        value = nextValue()
    }
}

/// Use this in place of `UIHostingController` in your app's `SceneDelegate`.
///
/// Supported interface orientations come from the root of the view hierarchy.
public class IPaSwiftUIOrientationController<Content: View>: UIHostingController<IPaSwiftUIOrientationController.Root<Content>> {
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.rootView.model.supportedOrientations
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        self.rootView.model.preferredInterfaceOrientationForPresentation
    }
    public override var shouldAutorotate: Bool {
        return self.rootView.model.shouldAutoRotate
    }
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(rootView: Content) {
        super.init(rootView: Root(contentView: rootView))
    }
    public struct Root<Content: View>: View {
        class Model {
            var supportedOrientations: UIInterfaceOrientationMask = SupportedOrientationsPreferenceKey.defaultValue
            var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation = .portrait
            var shouldAutoRotate = true
        }
        let contentView: Content
        let model: Model = Model()
        
        public var body: some View {
            contentView
                .onPreferenceChange(SupportedOrientationsPreferenceKey.self) { value in
                    // Update the binding to set the value on the root controller.
                    self.model.supportedOrientations = value
                   
                    UIViewController.attemptRotationToDeviceOrientation()
                }.onPreferenceChange(PreferredInterfaceOrientationPreferenceKey.self) { value in
                    self.model.preferredInterfaceOrientationForPresentation = value
                    var orientation = UIDeviceOrientation.portrait
                    switch value {
                    case .portrait:
                        orientation = .portrait
                    case .landscapeLeft:
                        orientation = .landscapeLeft
                    case .landscapeRight:
                        orientation = .landscapeRight
                    case .portraitUpsideDown:
                        orientation = .portraitUpsideDown
                    case .unknown:
                        break
                    
                    @unknown default:
                        break
                    }
                    
                    UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
                    UIViewController.attemptRotationToDeviceOrientation()
                    
                }.onPreferenceChange(ShouldAutoRotatePreferenceKey.self) { value in
                    self.model.shouldAutoRotate = value
                    
                }
            
        }
    }
}

extension View {
    public func supported(orientations: UIInterfaceOrientationMask) -> some View {
        // When rendered, export the requested orientations upward to Root
        preference(key: SupportedOrientationsPreferenceKey.self, value: orientations)
    }
    public func preferred(interfaceOrientation:UIInterfaceOrientation) -> some View {
        preference(key: PreferredInterfaceOrientationPreferenceKey.self, value: interfaceOrientation)
    }
   
    public func shouldAutoRotate(_ autoRotate:Bool) -> some View {
        preference(key: ShouldAutoRotatePreferenceKey.self, value: autoRotate)
    }
}
