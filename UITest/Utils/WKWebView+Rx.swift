
import WebKit

import RxSwift
import RxCocoa


extension Reactive where Base: WKWebView {

    var title: Observable<String?> {
        return self
            .observe(String.self, #keyPath(WKWebView.title))
    }

    var url: Observable<URL?> {
        return self
            .observe(URL.self, #keyPath(WKWebView.url))
    }

    var isLoading: Observable<Bool> {
        return self
            .observe(Bool.self, #keyPath(WKWebView.isLoading))
            .map { $0 ?? false }
    }

    var estimatedProgress: Observable<Double> {
        return self
            .observe(Double.self, #keyPath(WKWebView.estimatedProgress))
            .map { $0 ?? 0.0 }
    }

    var canGoBack: Observable<Bool> {
        return self
            .observe(Bool.self, #keyPath(WKWebView.canGoBack))
            .map { $0 ?? false }
    }

    var canGoForward: Observable<Bool> {
        return self
            .observe(Bool.self, #keyPath(WKWebView.canGoForward))
            .map { $0 ?? false }
    }
}
