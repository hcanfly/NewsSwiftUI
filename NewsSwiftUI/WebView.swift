//
//  WebView.swift
//  News-SwiftUI
//
//  Created by Gary Hanson on 6/13/21.
//

import SwiftUI
import WebKit


struct WebView : UIViewRepresentable {
    
    let urlString: String?
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let urlString = urlString {
            let request = URLRequest(url: URL(string: urlString)!)
            uiView.load(request)
        } else {
            // news stories sometimes have nil links.
        }
    }
    
}
