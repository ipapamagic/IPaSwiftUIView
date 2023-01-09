//
//  IPaSUIOrientationController.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/2/17.
//

import Foundation


import SwiftUI
import Combine
/// Use this in place of `UIHostingController` in your app's `SceneDelegate`.
///
/// Supported interface orientations come from the root of the view hierarchy.
let orientationUpdatedNotification = Notification.Name(rawValue: "orientationUpdatedNotification")

public class IPaSUIOrientationController<Content: View>: UIHostingController<IPaSUIOrientationController.Root<Content>> {
    
    var supportedIOs: UIInterfaceOrientationMask = .portrait
    var preferredIOForPresentation: UIInterfaceOrientation = .portrait
    var shouldAR = true
    var orientationAnyCancellable:AnyCancellable?
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.supportedIOs
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        self.preferredIOForPresentation
    }
    public override var shouldAutorotate: Bool {
        return self.shouldAR
    }
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(rootView: Content) {
        super.init(rootView: Root(contentView: rootView))
        
        self.orientationAnyCancellable = NotificationCenter.default.publisher(for: orientationUpdatedNotification).sink(receiveValue: { notification in
            guard let userInfo = notification.userInfo,let rawValue = userInfo["supported"] as? UInt,let prefer = userInfo["prefer"] as? Int, let preferredIOForPresentation = UIInterfaceOrientation(rawValue: prefer),let shouldAR = userInfo["shouldAutoRotate"] as? Bool  else {
                return
            }
            self.supportedIOs = UIInterfaceOrientationMask(rawValue: rawValue)
            self.preferredIOForPresentation = preferredIOForPresentation
            self.shouldAR = shouldAR
            var orientation = UIDeviceOrientation.portrait
            switch preferredIOForPresentation {
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
            
        })
        
        
    }
    public struct Root<Content: View>: View {
        
        let contentView: Content
        
        public var body: some View {
            contentView
                
                
        }
    }
}

extension UIDevice {
    public func setDevice(support orientations:UIInterfaceOrientationMask,preferred interfaceOrientation:UIInterfaceOrientation,should autoRate:Bool = true) {
        NotificationCenter.default.post(name: orientationUpdatedNotification, object: nil,userInfo: ["supported":orientations.rawValue,"prefer":interfaceOrientation.rawValue,"shouldAutoRotate":autoRate])
    }

}
