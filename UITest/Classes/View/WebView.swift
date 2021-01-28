
import UIKit
import WebKit

import RxSwift
import RxCocoa
import SnapKit


class WebView: UIView {

    private var stackView = UIStackView()
    private var webView = WKWebView()
    private var navigationStackView = UIStackView()
    private var backButton = UIButton()
    private var forwardButton = UIButton()
    private var reloadButton = UIButton()
    private var shareButton = UIButton()
    private var closeButton = UIButton()

    private var progressView = UIProgressView()

    private var disposeBag = DisposeBag()

    var isNavigationHidden: Bool {
        get { self.navigationStackView.isHidden }
        set { self.navigationStackView.isHidden = newValue }
    }

    var customUserAgent: String? {
        get { self.webView.customUserAgent }
        set { self.webView.customUserAgent = newValue }
    }

    weak var navigationDelegate: WKNavigationDelegate? {
        get { self.webView.navigationDelegate }
        set { self.webView.navigationDelegate = newValue }
    }

    weak var uiDelegate: WKUIDelegate? {
        get { self.webView.uiDelegate }
        set { self.webView.uiDelegate = newValue }
    }


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.rx.layoutSubviews
            .take(1)
            .bind { [weak self] in
                guard let self = self else { return }
                self.setup()
                self.layout()
                self.bind()
            }
            .disposed(by: self.disposeBag)
    }
}


extension WebView {

    private func setup() {
        self.backgroundColor = .clear

        self.stackView.axis = .vertical
        self.addSubview(self.stackView)

        self.webView.backgroundColor = .clear
        self.stackView.addArrangedSubview(self.webView)

        self.navigationStackView.backgroundColor = .lightGray
        self.navigationStackView.axis = .horizontal
        self.navigationStackView.alignment = .center
        self.navigationStackView.distribution = .fillEqually
        self.stackView.addArrangedSubview(self.navigationStackView)

        self.backButton.setImage(UIImage(named:"chevron.left"), for: .normal)
        self.navigationStackView.addArrangedSubview(self.backButton)

        self.forwardButton.setImage(UIImage(named: "chevron.right"), for: .normal)
        self.navigationStackView.addArrangedSubview(self.forwardButton)

        self.reloadButton.setImage(UIImage(named: "arrow.clockwise"), for: .normal)
        self.navigationStackView.addArrangedSubview(self.reloadButton)

        self.shareButton.setImage(UIImage(named: "square.and.arrow.up"), for: .normal)
        self.navigationStackView.addArrangedSubview(self.shareButton)

        self.closeButton.setImage(UIImage(named: "xmark"), for: .normal)
        self.navigationStackView.addArrangedSubview(self.closeButton)

        self.progressView.progressTintColor = .red
        self.progressView.trackTintColor = .clear
        self.addSubview(self.progressView)
    }

    private func layout() {
        self.stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.navigationStackView.snp.makeConstraints { maker in
            maker.height.equalTo(48.0)
        }

        self.progressView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(2.0)
        }
    }

    private func bind() {
        self.backButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.webView.goBack()
            }
            .disposed(by: self.disposeBag)

        self.forwardButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.webView.goForward()
            }
            .disposed(by: self.disposeBag)

        self.reloadButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.webView.reload()
            }
            .disposed(by: self.disposeBag)

        self.webView.rx.title
            .bind {
                print("title \($0)")
            }
            .disposed(by: self.disposeBag)

        self.webView.rx.url
            .bind {
                print("url \($0)")
            }
            .disposed(by: self.disposeBag)

        self.webView.rx.isLoading
            .bind {
                print("isLoading \($0)")
            }
            .disposed(by: self.disposeBag)

        self.webView.rx.estimatedProgress
            .map { $0 == 0.0 || $0 == 1.0 }
            .bind(to: self.progressView.rx.isHidden)
            .disposed(by: self.disposeBag)

        self.webView.rx.estimatedProgress
            .map { Float($0) }
            .bind(to: self.progressView.rx.progress)
            .disposed(by: self.disposeBag)

        self.webView.rx.canGoBack
            .bind(to: self.backButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        self.webView.rx.canGoForward
            .bind(to: self.forwardButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
}


extension WebView {

    func load(_ request: URLRequest) {
        self.webView.load(request)
    }
}
