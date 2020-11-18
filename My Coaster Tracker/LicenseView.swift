//
//  LicenseView.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 11/17/20.
//

import SwiftUI
import Foundation
import Combine
import WebKit

struct LicenseView: View {
	@State var showCheckInView = false

	var body: some View {
		WebView()
			.navigationTitle("License")
			.navigationBarItems(trailing: Button(action: {
				self.showCheckInView.toggle()
			}, label: {
				Text("Check In")
			}).sheet(isPresented: $showCheckInView, content: {
				CheckInView(showSheetView: self.$showCheckInView)
			}))
    }
}

struct WebView: UIViewRepresentable {
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView(frame: CGRect.zero)
		webView.navigationDelegate = context.coordinator
		webView.allowsBackForwardNavigationGestures = false
		webView.scrollView.isScrollEnabled = true
		let localFilePath = Bundle.main.path(forResource: "LICENSE", ofType: "html")
		let url = URL(fileURLWithPath: localFilePath!)
		webView.loadFileURL(url, allowingReadAccessTo: url)
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		var webViewNavigationSubscriber: AnyCancellable? = nil
		
		init(_ uiWebView: WebView) {
			self.parent = uiWebView
		}
		
		deinit {
			webViewNavigationSubscriber?.cancel()
		}
		
		func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			switch navigationAction.navigationType {
			case WKNavigationType.linkActivated:
				UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
				decisionHandler(WKNavigationActionPolicy.cancel)
			default:
				decisionHandler(WKNavigationActionPolicy.allow)
			}
		}
	}
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
