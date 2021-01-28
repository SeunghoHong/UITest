
import UIKit
import WebKit

import RxSwift
import RxCocoa
import SnapKit


class Web_VC: UIViewController {

    private var closeButton = UIButton()
    private var webView = WebView()

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Web_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.webView.backgroundColor = .lightGray
        self.webView.load(URLRequest(url: URL(string: "https://naver.com")!))
        self.view.addSubview(self.webView)
    }

    private func layout() {
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.webView.snp.makeConstraints { maker in
            maker.top.equalTo(self.closeButton.snp.bottom).offset(16.0)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            maker.leading.trailing.equalToSuperview()
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Web_VC {
}


extension Web_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

