

import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Banner_VC: UIViewController {

    private var bannerView = BannerView()
    private var closeButton = UIButton()
    private var loadButton = UIButton()

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerView.startScrolling()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.bannerView.stopScrolling()
    }
}


extension Banner_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.bannerView.backgroundColor = .clear
        self.view.addSubview(self.bannerView)

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)
    }

    private func layout() {
        self.bannerView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(self.view.snp.width)
        }

        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.loadButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)

        self.loadButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onLoad()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Banner_VC {

    func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    func onLoad() {
        let views: [UIView] = zip((0...4), [UIColor.green, UIColor.red, UIColor.blue, UIColor.gray, UIColor.orange]).map {
            let view = UIView()
            view.backgroundColor = $1
            let label = UILabel()
            label.text = "\($0)"
            view.addSubview(label)
            label.snp.makeConstraints { maker in
                maker.center.equalToSuperview()
            }
            return view
        }

        self.bannerView.items.accept(views)
    }
}

