//
//  IPaUrlImage.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2021/5/7.
//

import SwiftUI
import IPaDownloadManager
public struct IPaUrlImage: View {
    @State public var url:URL?
    var defaultImage:UIImage? = nil
    @State public var downloadedImage:UIImage? = nil
    var displayImage:UIImage? {
        get {
            return downloadedImage ?? defaultImage
        }
    }
    init(url:URL,default image:UIImage) {
        self.init(url: url)
        self.defaultImage = image
    }
    init(url:URL,default imageName:String) {
        self.init(url: url)
        self.defaultImage = UIImage(named: imageName)
    }
    init(url:String) {
        self.init(url: URL(string: url) ?? nil)
//        IPaDownloadManager.shared.download(from: <#T##URL#>, complete: <#T##IPaDownloadCompletedHandler##IPaDownloadCompletedHandler##(Result<(URLResponse, URL), Error>) -> ()#>)
        
    }
    init(url:URL?) {
        self.url = url
//        IPaDownloadManager.shared.download(from: <#T##URL#>, complete: <#T##IPaDownloadCompletedHandler##IPaDownloadCompletedHandler##(Result<(URLResponse, URL), Error>) -> ()#>)
        
    }
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct IPaUrlImage_Previews: PreviewProvider {
    static var previews: some View {
        IPaUrlImage(url:"https://www.google.com")
    }
}
